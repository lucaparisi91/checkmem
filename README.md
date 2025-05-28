# Check_mem 

Simple script to monitor memory usage on a node. By default collects
the total memory used on a node. However it accepts an option to
collect memory per process ( by parsing the output of ps ) and
filtering only processors with a memory usage above a certain
thresold. All memory units are in KB.  You can find a more detailed
description by typing

```bash 
bash check_mem.sh -h
```
## Running on muliple nodes 

If you are using multiple nodes you need to launch the script on
multiple nodes. With Slurm this means using srun to launch it in the
backround before launching your parallel application.

You can find an example script below for ARCHER2.

```
#!/bin/bash

#SBATCH --job-name=MY_JOB_NAME
#SBATCH --time=00:10:00
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=standard
#SBATCH --qos=short

export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=1

# Need overlap, oversubscribe and mem options to have two sruns running at the same time

srun --overlap --oversubscribe --mem=1GB --ntasks=$SLURM_NNODES --ntasks-per-node=1 ./run_check_mem.sh &

# Make sure it has started before running the main code
sleep 30 

srun --overlap --oversubscribe --mem=220GB --unbuffered --distribution=block:block --hint=nomultithread my_mpi_code
```

This will create a separate log file for each node with the Slurm job
id appended, e.g. `checkmem-nid004263-4103755.out`.  As supplied
`run_check_mem.sh` runs `check_mem.sh` so it reports the memory consumed
(in KB) per node every 60 seconds - just edit it to change, for
example, the frequency.

> [!IMPORTANT]
>
> Both the scripts need to be executable - after downloading them, issue:
>
> `chmod +x *.sh`
