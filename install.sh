current_user=$(whoami)
sudo mkdir /home/$current_user
sudo chown $current_user: /home/$current_user

echo "PATH="/home/${current_user}/miniconda3/bin:${PATH}"" >> ~/.bashrc
source ~/.bashrc

mkdir /home/${current_user}/.conda  
/conda/Miniconda3-latest-Linux-x86_64.sh -b

conda create --name cmu python=3.6
conda init bash 
echo "conda activate cmu" >> ~/.bashrc

source ~/.bashrc

pyrobot/locobot_install_all.sh -t full -p 3 -l interbotix

source ~/pyenv_pyrobot_python3/bin/activate
cd ~ && git clone https://github.com/kalyanvasudev/PyRep.git
cd PyRep && pip3 install -r requirements.txt
python3 setup.py install
