ORG ?= uvilla

all:
	$(MAKE) -C tps_base ORG=${ORG} && \
	$(MAKE) -C tps_env ORG=${ORG} && \
	$(MAKE) -C tps_env_parla ORG=${ORG}

local:
	$(MAKE) build -C tps_base ORG=${ORG} && \
	$(MAKE) build -C tps_env ORG=${ORG} && \
	$(MAKE) build -C tps_env_parla ORG=${ORG}