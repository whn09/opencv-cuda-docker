FROM nvidia/cudagl:10.2-devel-ubuntu18.04

RUN apt-get update && apt-get remove -y x264 libx264-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo clang-format wget apt-utils libcudnn7 libcudnn7-dev

# Get OpenCV dependencies
RUN apt-get update && apt-get install -y build-essential checkinstall cmake pkg-config yasm git \
    gfortran libjpeg8-dev libtiff5-dev libavcodec-dev libavformat-dev \
    libswscale-dev libdc1394-22-dev libxine2-dev libv4l-dev \
    qt5-default libgtk2.0-dev libtbb-dev libatlas-base-dev \
    libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev \
    libopencore-amrwb-dev x264 v4l-utils libprotobuf-dev protobuf-compiler libgoogle-glog-dev \
    libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen \
    python-dev python-pip python3-dev python3-pip &&\
    rm -rf /var/lib/apt/lists/* &&\
    pip2 install -U pip numpy -i https://opentuna.cn/pypi/web/simple &&\
    pip3 install -U pip numpy -i https://opentuna.cn/pypi/web/simple &&\
    pip install numpy scipy matplotlib scikit-image scikit-learn ipython -i https://opentuna.cn/pypi/web/simple

# Fetch OpenCV
RUN cd /opt && git clone --verbose https://github.com/opencv/opencv.git -b 4.4.0 &&\
    cd /opt && wget https://github.com/opencv/opencv_contrib/archive/4.4.0.tar.gz &&\
    mkdir opencv_contrib && tar -xf 4.4.0.tar.gz -C opencv_contrib --strip-components 1

RUN cd /opt/opencv && mkdir release && cd release && \
    cmake -G "Unix Makefiles" -DENABLE_PRECOMPILED_HEADERS=OFF -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
    CMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DWITH_TBB=ON -DBUILD_NEW_PYTHON_SUPPORT=ON -DWITH_V4L=ON -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=ON -DBUILD_EXAMPLES=OFF -DWITH_QT=ON -DWITH_OPENGL=ON \
    -DWITH_CUDA=ON -DWITH_CUDNN=ON -DCUDA_ARCH_BIN=7.0 -DOPENCV_DNN_CUDA=ON -DCUDA_GENERATION=Auto -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    .. &&\
    make -j"$(nproc)"  && \
    make install && \
    ldconfig &&\
    cd /opt/opencv/release && make clean
    
