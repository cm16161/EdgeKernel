# Evaluation #

To run the evaluations, we first need to create the OpenWhisk actions in the `OW-Actions/` directory.
Execute the following commands: 
```
$ wsk action create alert alert.js --web true
$ wsk action create dhs dhs.js --web true
$ wsk action create fdc fdc.js --web true 
$ wsk action create fib fib.js --web true
$ wsk action create lights lights.js --web true
$ wsk action create time time.js --web true
$ wsk action create usecase usecase.js --web true

```

Before being able to run the Evaluation scripts, it is **ESSENTIAL** that the `EdgeKernelAPI.ml` file 
in `Kernels/MirageOS/` is modified so that it has the correct IP address of the local Redis client.

This can be done by modifying `Line 9`:

```
(*    Change this line to the IP address bound to Redis     *) 
  combine "192.168.0.37" <- (*CHANGE THIS IP ADDRESS*)
```

Once this has been updated, you will need to build all of the unikernels.
This can be done by executing the `create_all.sh` script in the `Kernels/MirageOS/` directory. 


## Exp-01 ##

### EdgeKernel ###

Run each script, and in a **SEPARATE** terminal, run EdgeKernel.
On this terminal, the script will print out the time to complete a single
pass in *ms*.

### OpenWhisk  ###

Run each script and it will print out the time it takes to complete a single pass in *ms*.

