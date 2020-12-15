current_user=$(whoami)

echo "export COPPELIASIM_ROOT=/home/${current_user}/vrep/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/${current_user}/vrep/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04" >> ~/.bashrc
echo "export QT_QPA_PLATFORM_PLUGIN_PATH=/home/${current_user}/vrep/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04" >> ~/.bashrc

export COPPELIASIM_ROOT=/home/${current_user}/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/${current_user}/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04
export QT_QPA_PLATFORM_PLUGIN_PATH=/home/${current_user}/CoppeliaSim_Edu_V4_1_0_Ubuntu16_04

# echo "PATH="/home/${current_user}/miniconda3/bin:${PATH}"" >> ~/.bashrc

#~/pyrobot/locobot_install_all.sh -t full -p 3 -l interbotix

source ~/pyenv_pyrobot_python3/bin/activate
cd PyRep && pip3 install -r requirements.txt
python3 setup.py install

cp -r ~/low_cost_ws/src/pyrobot/src/pyrobot/vrep_locobot/ ~/pyenv_pyrobot_python3/lib/python3.6/site-packages/pyrobot/
touch ~/pyenv_pyrobot_python3/lib/python3.6/site-packages/pyrobot/vrep_locobot/__init__.py
