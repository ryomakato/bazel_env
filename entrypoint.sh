#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# make group
if [ x"$GROUP_ID" != x"0" ]; then
    groupadd -g $GROUP_ID -o $USER
fi

# make user
if [ x"$USER_ID" != x"0" ]; then
    useradd -d /home/$USER -m -s /bin/bash -u $USER_ID -g $GROUP_ID $USER
fi

# let user use su without password
sudo usermod -aG wheel $USER

# for permission problem on bazel
sudo mkdir /.cache
sudo chown $(id -u):$(id -g) /.cache

# return back permition
sudo chmod u-s /usr/sbin/useradd
sudo chmod u-s /usr/sbin/groupadd

exec $@
