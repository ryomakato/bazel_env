# Make Bazel Enviroment with Docker
This repository lets you make bazel enviroment with Docker.

## What will be installed
- bazel 1.1.0
- etc.

Please check Dockerfile for more details.

## Prerequirement  
- Docker

## Build Dockerfile
```bash
$ make build
```

## Run the Docker image
```bash
$ make run
```

### Change a mount place
If you want to change a mount place, please modify **Makefile**.
```Makefile
SOURCEDIR = ${PWD}/src
```

### Install python library
Before build Dockerfile, you have to specify python librarys which you want to install in **requirements.txt**.
