.PHONY: build push

ORG?=uvilla

TARGET:=${ORG}/tps_env_parla:gnu9-mvapich2
CUDA_ARCH_NUMBER ?= 80

all: push push-cuda

build:
	sudo docker build -t ${TARGET} --build-arg base_image=${ORG}/tps_env:gnu9-mvapich2 .

push: build
	sudo docker push ${TARGET}

build-cuda:
	sudo docker build -t ${TARGET}-sm_${CUDA_ARCH_NUMBER} \
	--build-arg base_image=${ORG}/tps_env:gnu9-mvapich2-sm_${CUDA_ARCH_NUMBER} .


push-cuda: build-cuda
	sudo docker push ${TARGET}-sm_${CUDA_ARCH_NUMBER}