echo "Building ROS nodes"

cd Examples_old/ROS/ORB_SLAM3
mkdir build
cd build
cmake .. -DROS_BUILD_TYPE=Release -DPangolin_DIR=/home/$USER/Documents/slam_devel/lib/cmake/Pangolin
make -j
