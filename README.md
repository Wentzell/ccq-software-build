# ccq-software-build

CCQ software build scripts to be run on rusty, workstations, or popeye with available modules.

topdir lists available codes, and subdirs should be labelled by version numbers, and build chain. We should limit ourselves to OpenMPI and IntelMPI build chains. Hence, a typical module file should load for example the following modules:

```
gcc/10 openmpi4 intel-oneapi-mkl
```

Each code dir contains helper files, and a bash script `install.sh`. Executing this this script with bash:
```
bash install.sh
```
compiles the code, ideally completely without adaptions,  and finally creates a module file. By adding the following line to your bashrc you can load these modules:
```
export MODULEPATH=/path/to/ccq-software-build/modules:$MODULEPATH
```
Just exchange the modulepath above with the location of the git repo on your machine. 

The following codes are supported:
* Wannier90 ver 3.1 using the same build chain as Vasp 6.2
    * required to build first for Vasp and QE
* Vasp ver 6.2 linked against Wannier90 ver 3.1 
    * vasp tgz file required 
    * OpenMPI 4, Intel MKL including Scalapack and blacs, FFTW
    * Wannier90 is fully MPI enabled
* Quantum Espresso ver 6.8
* Elk ver 6.8.4 including wannier90 interface
    * OpenMPI 4, Intel MKL including Scalapack and blacs, FFTW
* triqs 3.x.x unstable branch using the same build chain as the above DFT codes
    * includes the triqs applications: cthyb, dfttools, maxent, TPRF, ctseg, ctint, ForkTPS, solid_dmft

To start just go into one of the software folders provides and just `bash install.sh`.

### Note on MPI version

For running on different parts of rusty/popeye the MPI version needs to be adapted. At the moment everything is compiled using the default `openmpi4` module, which is optimal for all infiband connected nodes (rome and worker0xxx), e.g. the constrain `rome` or no constraint. Moreover, these version works fine on all Linux workstations. To use the compiled code on the skylake or broadwell nodes with constraint skylake or broadwell in a slurm job one has to change the MPI module before each job by loading afterwards additionally the module `openmpi-opa`. In general no recompiling of the code is necessary. More information can be found here: https://docs.simonsfoundation.org/index.php/MPI

For triqs job files for rusty rome and skylake can be found in the directory of the install script. A first benchmark indicated that using cthyb on 3-4 skylake nodes will have the same speed as one rome node with 128 cores. 

## new nixpack module system

The new module system is rolled out and the scripts are updated for the new system. Right now both module systems work in parallel. To switch to the old module system execute `module load modules-traditional`. However, this will reset the `MODULEPATH` env variable. To conveniently switch to the new system one can create an alias in `~/.bashrc`: 

```
alias modules_new='module load modules-new && export MODULEPATH=~/git/ccq-software-build/modules:$MODULEPATH
```

the new install scripts will copy the modules to a different location to make the loading of modules faster.
