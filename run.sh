docker run -it \
    --gpus all\
    --env DISPLAY=$DISPLAY \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --privileged \
    pyrobot:3.0

#     --user=$(id -u $USER):$(id -g $USER) \
    #--gpus all \
    #--workdir="/home/$USER" \
    #--volume="/home/$USER:/home/$USER" \

