/**
* This file is part of ORB-SLAM3
*
* Copyright (C) 2017-2021 Carlos Campos, Richard Elvira, Juan J. Gómez Rodríguez, José M.M. Montiel and Juan D. Tardós, University of Zaragoza.
* Copyright (C) 2014-2016 Raúl Mur-Artal, José M.M. Montiel and Juan D. Tardós, University of Zaragoza.
*
* ORB-SLAM3 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* ORB-SLAM3 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
* the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with ORB-SLAM3.
* If not, see <http://www.gnu.org/licenses/>.
*/


#include<iostream>
#include<algorithm>
#include<fstream>
#include<chrono>
#include <csignal>
#include <condition_variable>

#include <ros/ros.h>
#include <rosbag/bag.h>
#include <rosbag/view.h>
#include <cv_bridge/cv_bridge.h>

#include"../../../include/System.h"

using namespace std;

bool shutdown = false;
condition_variable shutdown_cond;
mutex shutdown_mutex;                                               
void sigintHandler(int sig)
{
    shutdown = true;
    shutdown_cond.notify_all();
}

int main(int argc, char **argv)
{
    if(argc < 2)
    {
        std::cerr << "Usage: rosrun ORB_SLAM3 MonoBag path_to_bag [output_path] [path_to_vocabulary] [path_to_settings] [image_topic]" << endl;        
        return 1;
    }

    std::string bag_path = argv[1];
    std::string voc_file = "ORB_SLAM3/Vocabulary/ORBvoc.txt";
    std::string setting_file = "ORB_SLAM3/Examples_old/ROS/ORB_SLAM3/config/ZED2iLeft.yaml";
    std::string image_topic = "/zed2i/zed_node/left_raw/image_raw_gray/compressed";
    std::string output_path = "";
    if (argc > 2)
    {
        output_path = argv[2];
    }
    if (argc > 3)
    {
        voc_file = argv[3];
    }
    if (argc > 4)
    {
        setting_file = argv[4];
    }
    if (argc > 5)
    {
        image_topic = argv[5];
    }

    std::cout << "Mono orb slam3 on bag file: " << bag_path << " with image topic: " << image_topic << std::endl;
    std::cout << "voc file: " << voc_file << " setting file: " << setting_file << std::endl;
    std::cout << "output path: " << output_path << std::endl;

    signal(SIGINT, sigintHandler);
    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM3::System SLAM(voc_file, setting_file, ORB_SLAM3::System::MONOCULAR,true);

    rosbag::Bag bag;
    bag.open(bag_path, rosbag::bagmode::Read);
    std::vector<std::string> topics;
    topics.push_back(image_topic);
    rosbag::View view(bag, rosbag::TopicQuery(topics));
    int num_images = 0;
    std::cout << "Processing images on topic " << image_topic << " of images " << view.size() << std::endl;
    for (rosbag::MessageInstance const m : view)
    {
        if (shutdown)
        {
            break;
        }
        shutdown_mutex.lock();
        sensor_msgs::CompressedImage::ConstPtr img = m.instantiate<sensor_msgs::CompressedImage>();
        if (img != NULL)
        {
            cv_bridge::CvImagePtr cv_ptr;
            try
            {
                cv_ptr = cv_bridge::toCvCopy(img, sensor_msgs::image_encodings::MONO8);
            }
            catch (cv_bridge::Exception& e)
            {
                std::cerr << "cv_bridge exception: " << e.what() << std::endl;
                return 1;
            }
            SLAM.TrackMonocular(cv_ptr->image, img->header.stamp.toSec());
            num_images++;
        }
        shutdown_mutex.unlock();
        shutdown_cond.notify_all();
    }
    std::cout << "Finished processing all images " << num_images << std::endl;

    // Stop all threads
    SLAM.Shutdown();

    // Save camera trajectory
    std::string frame_traj_file = output_path + "/FrameTrajectory.txt";
    std::string keyframe_traj_file = output_path + "/KeyFrameTrajectory.txt";
    SLAM.SaveTrajectoryEuRoC(frame_traj_file);
    SLAM.SaveKeyFrameTrajectoryTUM(keyframe_traj_file);
    return 0;
}


