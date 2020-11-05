FROM nvidia/cudagl:11.1-base-ubuntu16.04

SHELL ["/bin/bash", "-c"]
USER root

## Part 1: Installing packages and stuff
RUN apt-get update -y && apt-get install -y \
 lsb-release \ 
 apt-utils \
 mesa-utils \
 build-essential \
 software-properties-common \
 locales \
 x11-apps \
 git \
 xvfb \
 vim \
 screen \
 tree \
 sudo \
 ssh \
 wget \
 curl \
 unzip \
 htop \
 gdb \
 valgrind \
 libcanberra-gtk* \
 build-essential \
 libglib2.0-0 \
 libgl1-mesa-glx \
 xcb \
 libx11-xcb-dev \
 libglu1-mesa-dev \
 libxrender-dev \
 libxi6 \
 libdbus-1-3 \
 libfontconfig1 \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

## Part 1b: Setting up user with same user_id and g_id as outside the container.
ARG user_id=1000
ARG group_id=1000
ENV USERNAME pyrobot

RUN useradd -ms /bin/bash $USERNAME

RUN echo "$USERNAME:$USERNAME" \ 
&& adduser $USERNAME sudo \ 
&& echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
WORKDIR /home/$USERNAME
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME

## Part 2: Downloading Conda
RUN mkdir /home/$USERNAME/conda \
&& wget --no-verbose -P /home/$USERNAME/conda https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& chmod +x conda/Miniconda3-latest-Linux-x86_64.sh

## Part 3: Installing VREP 3.6.2 and opengl dependencies
RUN mkdir /home/$USERNAME/vrep \ 
 && wget --no-verbose -P /home/$USERNAME/vrep https://www.coppeliarobotics.com/files/V-REP_PRO_EDU_V3_6_2_Ubuntu16_04.tar.xz \
 && tar -xvf /home/$USERNAME/vrep/V-REP_PRO_EDU_V3_6_2_Ubuntu16_04.tar.xz \
 && sudo apt-get update -y && sudo apt-get install --no-install-recommends -y \
 libgl1-mesa-dev \
 libavcodec-dev \
 libavformat-dev \
 libswscale-dev \
 libopencv* \
 pyqt5-dev-tools \
 pyqt5-dev \
 qt5-default

## Part 4: Downloading pyrobot
RUN mkdir /home/$USERNAME/pyrobot \
&& curl 'https://raw.githubusercontent.com/facebookresearch/pyrobot/master/robots/LoCoBot/install/locobot_install_all.sh' > /home/$USERNAME/pyrobot/locobot_install_all.sh \
&& chmod +x pyrobot/locobot_install_all.sh 

## Part 5: Copying install script in
COPY install.sh /home/$USERNAME/install.sh

## Final environment config
# Reset APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE to default value
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=0

# Make SSH available
EXPOSE 22

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

# Set the starting working directory.
WORKDIR /

# Set the image to start opening a new bash terminal
ENTRYPOINT ["/bin/bash"]
