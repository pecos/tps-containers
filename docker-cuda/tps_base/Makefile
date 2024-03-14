.PHONY: build push

ORG?=uvilla

all: push

build: build-mvapich2

build-mvapich2:
	sudo docker build -t ${ORG}/tps_base:gnu9-mvapich2 --build-arg mpicompiler=mvapich2 .

build-impi:
	sudo docker build -t ${ORG}/tps_base:gnu9-impi --build-arg mpicompiler=impi .

push-mvapich2: build-mvapich2
	sudo docker push ${ORG}/tps_base:gnu9-mvapich2

push-impi: build-impi
	sudo docker push ${ORG}/tps_base:gnu9-impi

push: push-mvapich2
	
