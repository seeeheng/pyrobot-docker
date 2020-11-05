# DOCKER CONTAINER WITH VREP 3.6.2 + Pyrobot + Pyvrep

## 1. Build the image:
docker build --tag pyrobot .

## 2. Configure xhost:
xhost +local:docker

## 2. Go into image:
./run.sh

## 3. Change permissions for install.sh
sudo chmod +x install.sh

## 4. Run
./install.sh
