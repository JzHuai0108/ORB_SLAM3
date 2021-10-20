echo "Configuring and building Thirdparty/DBoW2 ..."

ORBSLAM_DIR=$(pwd)
Pangolin_DIR=$ORBSLAM_DIR/Thirdparty/Pangolin/devel/lib/cmake/Pangolin # Directory containing PangolinConfig.cmake.

buildAndInstallPangolin() {
cd Thirdparty
# git clone https://github.com/stevenlovegrove/Pangolin
cd Pangolin && git checkout v0.6
mkdir -p devel
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11 -DCMAKE_INSTALL_PREFIX=$ORBSLAM_DIR/Thirdparty/Pangolin/devel ..
make -j4 && make install
cd ../../../
}

buildAndInstallPangolin

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DPangolin_DIR=$Pangolin_DIR
make -j
