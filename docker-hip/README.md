# Container for ls6 with tps-bte preinstalled

Locally install apptainer and define the environment variable `$APPTAINER_ROOT` pointing at the apptainer installation directory.

Load the following modules
```
module load cray-mpich-abi
module load rocm/5.7.1
```

## Apptainer
Pull the image
```
$APPTAINER_ROOT/bin/apptainer pull docker://uvilla/tps-bte-tioga:latest
```

Run the example
```
flux run -N 2 -n 4 $APPTAINER_ROOT/bin/apptainer run --nv tps-bte-tioga_latest.sif /tps/build-gpu/src/tps-bte_0d3v.py -run input.ini
```

## Charliecloud

### Installation
Install charliecloud locally
```
mkdir /usr/workspace/$USER/python
cd /usr/workspace/$USER/python
mkdir charliecloud-tioga 
cd charliecloud-tioga
python3 -m venv --system-site-packages . 
source ./bin/activate 
pip install --upgrade pip 
pip install requests 
mkdir git
cd git
git clone https://github.com/hpc/charliecloud
cd charliecloud
./autogen.sh 
./configure
make
```

Set up environment
```
cd /usr/workspace/$USER/python/charliecloud-tioga
source ./bin/activate
cd git/charliecloud/bin
export PATH=$PWD:$PATH
```

```
ch-image pull registry.hub.docker.com/uvilla/tps-bte-tioga:latest
ch-convert registry.hub.docker.com/uvilla/tps-bte-tioga:lastest tps-bte-tioga.sqfs
ch-convert tps-bte-tioga.sqfs /usr/workspace/villa13/apptainer/tps-containers/docker-hip/tps-bte-tioga-dir
flux run -N 1 -n 1 ch-run -b /var/tmp/$USER:/var/tmp/$USER --set-env -w /usr/workspace/villa13/apptainer/tps-containers/docker-hip/tps-bte-tioga-dir  -- /tps/build-gpu/src/tps -run /input.ini
```
