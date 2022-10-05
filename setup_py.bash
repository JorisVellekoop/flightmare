#!/bin/bash

if [[ ! -f "$(pwd)/setup_py.bash" ]]
then
  echo "please launch from the agile_flight folder!"
  exit
fi

flightmare_path=$PWD
echo $flightmare_path

echo "Making sure submodules are initialized and up-to-date"
git submodule update --init --recursive

echo "Using apt to install dependencies..."
echo "Will ask for sudo permissions:"
sudo apt update
sudo apt install -y --no-install-recommends build-essential cmake libzmqpp-dev libopencv-dev 

#echo "Ignoring unused Flightmare folders!"
#touch flightmare/flightros/CATKIN_IGNORE

# echo "Downloading Trajectories..."
#wget "https://download.ifi.uzh.ch/rpg/Flightmare/trajectories.zip" --directory-prefix=$project_path/flightmare/flightpy/configs/vision 

#echo "Unziping Trajectories... (this might take a while)"
#unzip -o $project_path/flightmare/flightpy/configs/vision/trajectories.zip -d $project_path/flightmare/flightpy/configs/vision/ | awk 'BEGIN {ORS=" "} {if(NR%50==0)print "."}'

#echo "Removing Trajectories zip file"
#rm $project_path/flightmare/flightpy/configs/vision/trajectories.zip

#echo "Downloading Flightmare Unity standalone..."
#wget "https://download.ifi.uzh.ch/rpg/Flightmare/RPG_Flightmare.zip" --directory-prefix=$flightmare_path/flightrender
#
#echo "Unziping Flightmare Unity Standalone... (this might take a while)"
#unzip -o $flightmare_path/flightrender/RPG_Flightmare.zip -d $flightmare_path/flightrender | awk 'BEGIN {ORS=" "} {if(NR%10==0)print "."}'
#
#echo "Removing Flightmare Unity Standalone zip file"
#rm $flightmare_path/flightrender/RPG_Flightmare.zip

# 
echo "export FLIGHTMARE_PATH=$flightmare_path" >> ~/.bashrc
source ~/.bashrc

# 
echo "Creating an conda environment from the environment.yaml file. Make sure you have anaconda installed"
conda env create -f environment.yaml

# 
echo "Source the anaconda environment. If errors, change to the right anaconda path."
source ~/anaconda3/etc/profile.d/conda.sh

# 
echo "Activate the environment"
conda activate pubflight

echo "Compiling the flightmare environment and install the environment as python package"
cd $flightmare_path/flightlib/build
cmake ..
make -j10
pip install .


echo "Install RPG baseline"
cd $flightmare_path/flightpy/flightrl
pip install .

#echo "Run the first vision demo."
#cd $project_path/envtest
#python3 -m python.run_vision_demo --render 1

echo "Done!"
echo "Have a save flight!"
