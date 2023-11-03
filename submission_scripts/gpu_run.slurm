#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** Parallel Job in GPU queue***
# 
#----------------------------------------------------

#SBATCH -J tps_cylinder           # Job name
#SBATCH -o tps_cylinder.o%j       # Name of stdout output file
#SBATCH -e tps_cylinder.e%j       # Name of stderr error file
#SBATCH -p gpu-a100                  # Queue (partition) name
#SBATCH -N 1                       # Total # of nodes (must be 1 for serial)
#SBATCH -n 3                       # Total # of mpi tasks (should be 1 for serial)
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


export IMAGE=$(pwd)/$IMAGE_NAME_$TAG.sif

rm -f $IMAGE
apptainer pull docker://$ORG/$IMAGE_NAME:$TAG

export EXE=$(pwd)/tps/build-gpu/src/tps
export PYEXE=$(pwd)/tps/build-gpu/src/tps-time-loop.py

echo "#! /bin/bash" > wrapper.sh
echo "$EXE $@" >> wrapper.sh
chmod +x wrapper.sh

export WRAPPER=$(pwd)/wrapper.sh

cd tps/build-gpu/test
ibrun -n 1 apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH ldd ../src/.libs/tps
ibrun -n 1 apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH /bin/bash -c "ldd ../src/.libs/tps"
ibrun -n 1 apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH /bin/bash -c "ldconfig; ldd ../src/.libs/tps"
echo "Try $EXE"
ibrun apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $EXE -run inputs/coupled-3d.ini
echo "Try $WRAPPER"
ibrun apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $WRAPPER -run inputs/coupled-3d.ini
echo "Try $PYEXE"
ibrun apptainer exec --nv $IMAGE env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $PYEXE -run inputs/coupled-3d.ini
