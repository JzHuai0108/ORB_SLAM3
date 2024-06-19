bagname=$1
outputdir=$2

orbslam3_dir=/home/jhuai/Documents/orbslam3_ws/src
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/jhuai/Documents/orbslam3_ws/src/ORB_SLAM3/Examples_old/ROS
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/$USER/Documents/slam_devel/lib

cd $orbslam3_dir
rosrun  ORB_SLAM3 MonoBag $bagname $outputdir
