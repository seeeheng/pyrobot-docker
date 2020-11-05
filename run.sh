docker run -it \
    --user=$(id -u $USER):$(id -g $USER) \
    --gpus all\
    --env DISPLAY=$DISPLAY \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --privileged \
    pyrobot:2.0

    #--gpus all \
    #--workdir="/home/$USER" \
    #--volume="/home/$USER:/home/$USER" \

