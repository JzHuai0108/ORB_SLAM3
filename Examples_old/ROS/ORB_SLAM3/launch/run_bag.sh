bagname=$1
outputdir=$2

orbslam3_dir=/home/pi/Documents/vision
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:$orbslam3_dir/ORB_SLAM3/Examples_old/ROS
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/$USER/Documents/slam_devel/lib

cd $orbslam3_dir
rosrun ORB_SLAM3 MonoBag $bagname $outputdir
