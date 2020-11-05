# DOCKER CONTAINER WITH VREP 3.6.2 + Pyrobot + Pyvrep

1. Build the image:
docker build --tag pyrobot .

2. Configure xhost:
xhost +local:docker

3. Go into image:
./run.sh

4. Change permissions for install.sh
cd ~
sudo chown `whoami` install.sh && chmod +x install.sh

5. Install everything
./install.sh
