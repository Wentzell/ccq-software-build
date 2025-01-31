#!/bin/bash
#SBATCH --job-name="vasp-test-rome"
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --ntasks-per-core=1
#SBATCH --constraint=rome 
#SBATCH --partition=ccq
#SBATCH --output=out.%j
#SBATCH --error=err.%j

#======START=====

# set OMP_NUM_THREADS so that times ntasks-per-node is the total number of cores on each node
# Vasp is currently compiled without OpenMP support!
export OMP_NUM_THREADS=1
ulimit -s unlimited

module purge
module load slurm 
module load vasp/6.2.0_nixpack_gnu
######################
# for skylake jobs!!
# comment this line for skylake jobs:
#module load openmpi-opa
#######################

# with map by socket a maximum of number of cores per physical cores are spawned! This is cores per node/2
# if more threads are needed switch socket -> node
mpirun --map-by socket:pe=$OMP_NUM_THREADS vasp_std

#=====END====
