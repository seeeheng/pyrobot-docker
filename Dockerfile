FROM nvidia/cudagl:11.1-base-ubuntu18.04

# SHELL ["/bin/bash", "-c"]
# USER root

# //////////////////////////////////////////////////////////////////////////////
# general tools install
RUN export DEBIAN_FRONTEND=noninteractive \ 
  && apt-get update --no-install-recommends \
  && apt-get install -y \
  build-essential \
  cmake \
  cppcheck \
  gdb \
  git \
  lsb-release \
  software-properties-common \
  sudo \
  vim \ 
  wget \
  tmux \
  curl \ 
  less \
  net-tools \
  byobu \
  libgl-dev \
  iputils-ping \
  nano \
  doxygen \
  graphviz \
  python-requests \
  python-pip \
  locales \
  xvfb \
  tzdata \
  emacs \
  python3 \
  python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
#hard coded sia
ARG user_id=1000
ENV USERNAME developer
ENV USER=developer
RUN useradd -U $USERNAME --uid $user_id -ms /bin/bash \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
# Commands below run as the developer user
USER $USERNAME
# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# remove ssh host checking (for git clone in container)
# eventually to be removed by the above ssh keys setup
RUN mkdir $HOME/.ssh && ssh-keyscan bitbucket.org >> $HOME/.ssh/known_hosts

# Set the timezone
RUN sudo ln -fs /usr/share/zoneinfo/Asia/Singapore /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# //////////////////////////////////////////////////////////////////////////////
# ros install
# RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
#  && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
#  && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
#  && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
#  && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
#  && sudo apt-get update \
#  && sudo apt-get install -y --no-install-recommends \
#   # general ros melodic dependencies \
#   python-rosdep \
#   libboost-all-dev \
#   libeigen3-dev \
#   assimp-utils \
#   libcgal-dev \
#   libcgal-qt5-dev \
#   libproj-dev \
#   libnlopt-dev \
#   python-wstool \
#   python-catkin-tools \
#   libglfw3-dev \
#   libblosc-dev \
#   libopenexr-dev \
#   liblog4cplus-dev \
#   libsuitesparse-dev \
#   libsdl1.2-dev \
#   # basic ros-melodic packages \
#   ros-melodic-catch-ros \
#   ros-melodic-smach-viewer \
#   ros-melodic-tf-conversions \
#   ros-melodic-gazebo-* \
#   ros-melodic-random-numbers \
#   ros-melodic-cmake-modules \
#   ros-melodic-rqt-gui-cpp \
#   ros-melodic-rviz \
#   # common workspace dependencies \
#   ros-melodic-ros-type-introspection \
#   ros-melodic-geometry \
#   ros-melodic-tf2-geometry-msgs \
#  && sudo apt-get clean \
#  && sudo rm -rf /var/lib/apt/lists/*
# # force a rosdep update
# RUN sudo rosdep init && rosdep update

RUN pip install --upgrade pip

# basic python packages
RUN pip3 install --user \
 wheel \
 setuptools \
 PyYAML \
 pexpect \
 tmuxp \
 libtmux

RUN mkdir /home/$USERNAME/pyrobot \
&& curl 'https://raw.githubusercontent.com/facebookresearch/pyrobot/master/robots/LoCoBot/install/locobot_install_all.sh' > /home/$USERNAME/pyrobot/locobot_install_all.sh \
&& chmod +x pyrobot/locobot_install_all.sh 

# RUN pyrobot/locobot_install_all.sh -t sim_only -p 3 -l interbotix

# add tmux configuration
RUN git clone https://github.com/gpakosz/.tmux.git \
 && ln -s -f .tmux/.tmux.conf \
 && cp .tmux/.tmux.conf.local .

 # //////////////////////////////////////////////////////////////////////////////
# export environment variables

# Ugly: update the python environment path
ENV PYTHONPATH=${PYTHONPATH}:/home/$USERNAME/.local/lib/python2.7/site-packages/
ENV PATH=${PATH}:/home/$USERNAME/.local/bin/

# //////////////////////////////////////////////////////////////////////////////
# copy any thirdparty data
# COPY --chown=$USERNAME:$USERNAME thirdparty-software/ /home/$USERNAME/thirdparty-software/

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup
# //////////////////////////////////////////////////////////////////////////////

# # entrypoint path inside the docker container
# ENV entry_path /docker-entrypoint/

# # add entrypoint scripts (general & system specific)
# ADD entrypoints/ $entry_path/

# # execute entrypoint script
# RUN sudo chown -R $USERNAME:$USERNAME $entry_path/
# RUN sudo chmod +x -R $entry_path/

# # set image to run entrypoint script
# ENTRYPOINT $entry_path/docker-entrypoint.bash

## Part 1: Installing packages and stuff
# RUN apt-get update -y && apt-get install -y \
#  lsb-release \ 
#  apt-utils \
#  mesa-utils \
#  build-essential \
#  software-properties-common \
#  locales \
#  x11-apps \
#  git \
#  xvfb \
#  vim \
#  screen \
#  tree \
#  sudo \
#  ssh \
#  wget \
#  curl \
#  unzip \
#  htop \
#  gdb \
#  valgrind \
#  libcanberra-gtk* \
#  build-essential \
#  libglib2.0-0 \
#  libgl1-mesa-glx \
#  xcb \
#  libx11-xcb-dev \
#  libglu1-mesa-dev \
#  libxrender-dev \
#  libxi6 \
#  libdbus-1-3 \
#  libfontconfig1 \
#  && rm -rf /var/lib/apt/lists/* \
#  && apt-get clean

# ## Part 1b: Setting up user with same user_id and g_id as outside the container.
# ARG user_id=1000
# ARG group_id=1000
# ENV USERNAME pyrobot

# RUN useradd -ms /bin/bash $USERNAME

# RUN echo "$USERNAME:$USERNAME" \ 
# && adduser $USERNAME sudo \ 
# && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
# WORKDIR /home/$USERNAME
# RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
# USER $USERNAME

# # ## Part 2: Downloading Conda
# # RUN mkdir /home/$USERNAME/conda \
# # && wget --no-verbose -P /home/$USERNAME/conda https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
# # && chmod +x conda/Miniconda3-latest-Linux-x86_64.sh

# ## Part 3: Installing CoppeliaSim Edu 4.1.0 and opengl dependencies
# #RUN mkdir /home/$USERNAME/vrep \ 
# # && wget --no-verbose -P /home/$USERNAME/vrep https://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04.tar.xz \
# # && tar -xvf /home/$USERNAME/vrep/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04.tar.xz \
# # && sudo apt-get update -y && sudo apt-get install --no-install-recommends -y \
# # libgl1-mesa-dev \
# # libavcodec-dev \
# # libavformat-dev \
# # libswscale-dev \
# # libopencv* \
# # pyqt5-dev-tools \
# # pyqt5-dev \
# # qt5-default \
# # udev

# ## Part 3b OpenGL Dependencies
# RUN sudo apt-get update -y && sudo apt-get install --no-install-recommends -y \
# libgl1-mesa-dev \
# libavcodec-dev \
# libavformat-dev \
# libswscale-dev \
# libopencv* \
# pyqt5-dev-tools \
# pyqt5-dev \
# qt5-default \
# udev

# ## Part 4: Downloading pyrobot
# RUN mkdir /home/$USERNAME/pyrobot \
# && curl 'https://raw.githubusercontent.com/facebookresearch/pyrobot/master/robots/LoCoBot/install/locobot_install_all.sh' > /home/$USERNAME/pyrobot/locobot_install_all.sh \
# && chmod +x pyrobot/locobot_install_all.sh 

# ## Part 5: Downloading pyrep
# #RUN git clone https://github.com/stepjam/PyRep.git 

# ## Part 6: Copying install script in
# #COPY install.sh /home/$USERNAME/install.sh

# ## Final environment config
# # Reset APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE to default value
# ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=0

# # Make SSH available
# EXPOSE 22

# # This is required for sharing Xauthority
# ENV QT_X11_NO_MITSHM=1

# # Set the starting working directory.
# WORKDIR /

# # Set the image to start opening a new bash terminal
# ENTRYPOINT ["/bin/bash"]
