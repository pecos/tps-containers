#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** Serial Job in Normal Queue***
# 
# Goal pull the docker image and configure/build TPS
# This script assumes TPS is already present in the same
# same folder as the submission script
#----------------------------------------------------

#SBATCH -J build-tps           # Job name
#SBATCH -o build-tps.o%j       # Name of stdout output file
#SBATCH -e build-tps.e%j       # Name of stderr error file
#SBATCH -p normal                  # Queue (partition) name
#SBATCH -N 1                       # Total # of nodes (must be 1 for serial)
#SBATCH -n 128                       # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 00:10:00                # Run time (hh:mm:ss)
##SBATCH --mail-type=all            # Send email at begin and end of job
#SBATCH -A CDA23007               # Project/Allocation name (req'd if you have more than 1)
##SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module purge
module load gcc/11.2.0 mvapich2/2.3.7 tacc-apptainer/1.1.8
ml list

export ORG=uvilla
export IMAGE_NAME=tps_env_parla
export TAG=gnu9-mvapich2-sm_80


export IMAGE=$(pwd)/${IMAGE_NAME}_$TAG.sif

rm -f $IMAGE
apptainer pull docker://$ORG/$IMAGE_NAME:$TAG
cd tps
apptainer exec --cleanenv $IMAGE /bin/bash --login -c "./bootstrap"
rm -rf build-gpu
mkdir build-gpu && cd build-gpu
apptainer exec  --cleanenv $IMAGE /bin/bash --login -c "../configure --enable-pybind11 --enable-gpu-cuda"
apptainer exec  --cleanenv $IMAGE /bin/bash --login -c "make -j && make -j check TESTS=vpath.sh"
apptainer exec $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH cat /etc/ld.so.conf.d/tps.conf
apptainer exec $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH ldd ./src/.libs/tps
apptainer exec $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH /bin/bash -c "ldd ./src/.libs/tps"
apptainer exec $IMAGE LD_LIBRARY_PATH=$LD_LIBRARY_PATH /bin/bash -c "ldconfig; ldd ./src/.libs/tps"
