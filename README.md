# Make Bazel Enviroment with Docker
This repository lets you make bazel enviroment with Docker.

## What will be installed
- bazel 1.1.0
- etc.

Please check Dockerfile for more details.

## Prerequirement  
- Docker

## 1. Build Dockerfile
```bash
$ make build
```

## 2. Run the Docker image
```bash
$ make run
```

### Change a mount place
Initially, `make run` command mount `./src` directory.
If you want to change a mount place, please modify **Makefile**.
```Makefile
SOURCEDIR = ${PWD}/src
```

### Install python library
Before build Dockerfile, you have to specify python librarys which you want to install in **requirements.txt**.
