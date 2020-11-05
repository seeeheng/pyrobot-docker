docker run -it \
    --user=$(id -u $USER):$(id -g $USER) \
    --gpus all\
    --env DISPLAY=$DISPLAY \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --privileged \
    pyrobot:latest

    #--gpus all \
    #--workdir="/home/$USER" \
    #--volume="/home/$USER:/home/$USER" \

