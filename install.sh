current_user=$(whoami)

echo "VREP_ROOT=/home/${current_user}/V-REP_PRO_EDU_V3_6_2_Ubuntu16_04" >> ~/.bashrc
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$VREP_ROOT" >> ~/.bashrc
echo "QT_QPA_PLATFORM_PLUGIN_PATH=$VREP_ROOT" >> ~/.bashrc
echo "PATH="/home/${current_user}/miniconda3/bin:${PATH}"" >> ~/.bashrc

~/conda/Miniconda3-latest-Linux-x86_64.sh -b

exec bash
conda init bash 
exec bash

conda create --name cmu python=3.6 && conda activate cmu
echo "conda activate cmu" >> ~/.bashrc

~/pyrobot/locobot_install_all.sh -t full -p 3 -l interbotix

source ~/pyenv_pyrobot_python3/bin/activate
cd ~ && git clone https://github.com/kalyanvasudev/PyRep.git
cd PyRep && pip3 install -r requirements.txt
python3 setup.py install
