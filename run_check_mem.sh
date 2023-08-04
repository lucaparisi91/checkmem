#!/bin/bash

./check_mem.sh -t 60 > checkmem-${SLURMD_NODENAME}-${SLURM_JOB_ID}.out
