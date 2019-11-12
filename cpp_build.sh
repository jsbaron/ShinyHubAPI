git clone https://github.com/Microsoft/cpprestsdk.git casablanca
cd casablanca
mkdir build.debug
cd build.debug
cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Debug
ninja
