# Container for ls6 with tps-bte preinstalled

Locally install apptainer and define the enviromental variable `$APPTAINER_ROOT` pointing at the apptainer installation directory.

Load the following modules
```
module load cray-mpich-abi
module load rocm/5.7.1
```

Pull the image
```
$APPTAINER_ROOT/bin/apptainer pull docker://uvilla/tps-bte-tioga:latest
```

Run the example
```
flux run -N 2 -n 4 $APPTAINER_ROOT/bin/apptainer run --nv tps-bte-tioga_latest.sif /tps/build-gpu/src/tps-bte_0d3v.py -run input.ini
```

