echo "Building ROS nodes"

ORBSLAM_DIR=$(pwd)
source /opt/ros/melodic/setup.bash
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:$ORBSLAM_DIR/Examples/ROS
Pangolin_DIR=$ORBSLAM_DIR/Thirdparty/Pangolin/devel/lib/cmake/Pangolin


cd Examples/ROS/ORB_SLAM3
mkdir build
cd build
cmake .. -DROS_BUILD_TYPE=Release -DPangolin_DIR=$Pangolin_DIR

make -j
