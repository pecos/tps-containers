# Container for ls6 with tps-bte preinstalled

Locally install apptainer and define the enviromental variable `$APPTAINER_ROOT` pointing at the apptainer installation directory.

Load the following modules
```
module purge
module load cray-mpich-abi
```

Pull the image
```
$APPTAINER_ROOT/bin/apptainer pull docker://uvilla/tps-bte-ls6:latest
```

Run the example
```
flux run -N 2 -n 4 $APPTAINER_ROOT/bin/apptainer run --nv tps-bte-ls6_latest.sif /tps/build-gpu/src/tps-bte_0d3v.py -run input.ini
```

