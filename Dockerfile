FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# Install fundamental tools.
RUN apt-get update -q && apt-get install -qy apt-utils curl && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes
# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update -q && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | \
        xargs apt-get install -qy --reinstall && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

# Install useful tools.
RUN apt-get update -q && apt-get install -qy \
        build-essential software-properties-common \
        vim git sudo wget && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

# Install C++.
RUN apt-get update -q && apt-get install -qy clang clang-format && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

# Install Python3(as default)
RUN apt-get update -q && apt-get install -qy python3 python3-pip && \
    unlink /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

# Install Python Library
ADD ./requirements.txt /tmp/
RUN  pip install -r /tmp/requirements.txt

# Install Bazel.
ARG BAZEL_VERSION=1.1.0
RUN apt-get update -q && apt-get install -qy unzip && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/* && \
    curl -L -o installer \
    "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    chmod +x installer && ./installer && rm ./installer && \
    echo 'source /usr/local/lib/bazel/bin/bazel-complete.bash' > /etc/profile.d/99-bazel-complete.sh && \
    chmod +x /etc/profile.d/99-bazel-complete.sh

# Make wheel user
RUN sed -i -e "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su && \
    echo "wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    addgroup wheel

# Make user by entrypoint.sh
ENV USER docker
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chmod u+s /usr/sbin/useradd && chmod u+s /usr/sbin/groupadd
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]