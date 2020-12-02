# OpenCV CUDA Docker

## Version

```
Ubuntu: 18.04
CUDA: 10.2
CUDNN: 7.6.5
CUDA_ARCH_BIN: 7.0 (NVIDIA Tesla V100)
OpenCV: 4.4.0
Python: 3.6.9 / 2.7.17
```

## Usage

```
docker pull whn09/opencv-cuda:latest
nvidia-docker run -it whn09/opencv-cuda:latest /bin/bash
```

or

```
docker build -t opencv-cuda -f Dockerfile .
nvidia-docker run -it opencv-cuda /bin/bash
```

## Test


