#!/bin/bash

# Kontrola aktuálnej lokácie
locale  # overenie nastavení UTF-8

# Aktualizácia zoznamu balíkov a inštalácia locales
sudo apt update && sudo apt install locales

# Generovanie a nastavenie lokalizácie na en_US.UTF-8
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Overenie nastavení lokácie
locale  # overenie nastavení

# Aktualizácia zoznamu balíkov a upgrade balíkov
sudo apt update && sudo apt upgrade -y

# Aktivácia repozitára Universe, ak ešte nie je
sudo apt install software-properties-common
sudo add-apt-repository universe

# Aktualizácia zoznamu balíkov a inštalácia curl pre stiahnutie kľúča
sudo apt update && sudo apt install curl -y

# Stiahnutie a pridanie GPG kľúča pre ROS 2
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Pridanie repozitára ROS 2 do zoznamu repozitárov
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Aktualizácia zoznamu balíkov
sudo apt update

# Inštalácia ROS, RViz, demos, tutorials
sudo apt install ros-foxy-desktop python3-argcomplete python3-colcon-common-extensions -y

# Source ROS2 Foxy
source /opt/ros/foxy/setup.bash

# Limit ROS2 communication to your PC
export ROS_LOCALHOST_ONLY=1

# [Optional] Permanent setup of ROS2 foxy
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
echo "export ROS_LOCALHOST_ONLY=1" >> ~/.bashrc

# Aktualizácia zoznamu balíkov
sudo apt update

# Inštalácia qt5-default
sudo apt install qt5-default -y

# Rozbaľovanie a inštalácia uds_kobuki_sim
unzip uds_kobuki_sim.zip
cd uds_kobuki_sim

# Vytvorenie Makefile z Qt projektu a kompilácia `kobukiSIM`
qmake
make

# Inštalácia vykonateľného súboru a ďalších súborov do `/opt/kobuki/sim/`
sudo make install

# Source ROS2 Foxy
source /opt/ros/foxy/setup.bash
export ROS_LOCALHOST_ONLY=1

# Vytvorenie ROS 2 workspace a klonovanie repozitára uds_kobuki_ros
cd ..
mkdir -p ros2_ws/src
cd ros2_ws/src
git clone https://github.com/stecf/uds_kobuki_ros.git

# Kompilácia balíčkov
cd ..
colcon build --symlink-install --packages-select uds_kobuki_ros
source install/local_setup.bash

# Inštalácia balíčkov do /opt/kobuki/install
sudo colcon build --symlink-install --packages-select uds_kobuki_ros --install-base /opt/kobuki/install
source /opt/kobuki/install/setup.bash

# [Optional] Permanent setup of ROS2 workspace
echo "source /opt/kobuki/install/setup.bash" >> ~/.bashrc

echo Done
