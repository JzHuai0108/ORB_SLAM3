# Note change the folder to one containing ORB_SLAM3.
folders=(handheld
ebike
zongmu)
datadir=/media/jhuai/MyBookDuo/jhuai/data/homebrew
resultdir=/media/jhuai/MyBookDuo/jhuai/results/orbslam3

for folder in "${folders[@]}"
do
    echo "Processing $folder"
    python3 ./ORB_SLAM3/Examples_old/ROS/ORB_SLAM3/launch/run_bags.py $datadir/$folder $resultdir
done
