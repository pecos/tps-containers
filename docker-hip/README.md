# Container for Tioga with tps-bte preinstalled

Load the following modules
```
module load cray-mpich-abi
module load rocm/5.4.1
```

Pull the image
```
singularity pull docker://uvilla/tps-bte:el8-rocm5.4.1
```

Run the example
```
cp input.ini $HOME/
cp restart_output-plasma.sol.h5 $HOME/
flux run -N 2 -n 4 singularity run --rocm tps-bte_el8-rocm5.4.1.sif /tps/build-gpu/src/tps-bte_0d3v.py -run input.ini
```

