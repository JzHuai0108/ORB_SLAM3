#!/bin/bash
pathDatasetTUM_VI=$1
outputDir=$2

ORBSLAM_DIR=$(pwd)
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:$ORBSLAM_DIR/Examples/ROS

StereoIneritialSession() {
datasetname=$1
echo "Launching $datasetname with Stereo-Inertial sensor"

roslaunch ORB_SLAM3 orbslam3_rosbag.launch vocabulary_path:=$ORBSLAM_DIR/Vocabulary/ORBvoc.txt \
config_filename:=$ORBSLAM_DIR/Examples/Stereo-Inertial/TUM_512.yaml \
bag_file:="$pathDatasetTUM_VI"/dataset-"$datasetname"_512_16.bag output_file:=$outputDir/$datasetname.txt
}

datasetname=corridor1
# rosrun rosbag fastrebag.py "$pathDatasetTUM_VI"/dataset-"$datasetname"_512_16.bag "$pathDatasetTUM_VI"/dataset-"$datasetname"_512_16_small_chunks.bag

StereoIneritialSession corridor1
exit 0
