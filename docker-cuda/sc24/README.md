# Container for ls6 with tps-bte preinstalled

Load the following modules
```
module purge
module load cuda/12.2 gcc/11.2.0 tacc-apptainer/1.1.8  mvapich2/2.3.7
```

Request interactive GPU node (e.g. a100-gpu-small)
```
idev -p gpu-a100-small -A FTA-SUB-Ghattas
```

Pull the image
```
apptainer pull docker://uvilla/tps-bte-ls6:latest
```

Run the example
```
MV2_SMP_USE_CMA=0 ibrun -n 2 apptainer run --nv tps-bte-ls6_latest.sif /tps/build-gpu/src/tps-bte_0d3v.py -run input.ini
```

See also the `submission.slurm` example