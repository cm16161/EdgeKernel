# Experiment 1 #

This experiment compares the overall speed performance of EdgeKernel against OpenWhisk

Scripts have been provided which simulate various workloads to be completed by EdgeKernel and OpenWhisk

## EdgeKernel (EK) ##

To run the EdgeKernel tests, execute each script in the directory.
In addition to running the script, run EdgeKernel (`EdgeKernel.rb`) in a **SEPARATE** terminal

In order to run the `Evaluate_EK/EK-EvalDHS.sh` script, `eval_test_dhs_current_average` and `eval_test_dhs_day_count` need to have values set in the redis queue.
This is done by launching the `redis-cli` and using the command `set eval_test_dhs_current_average <value>` and `set eval_test_dhs_day_count <value>`, i.e. 
```
set eval_test_dhs_current_average 10
set eval_test_dhs_day_count 10
```

In order to run the `Evaluate_EK/EK-EvalFib.sh` script, the variable `fib_number` needs to have a value set in the redis queue.
This is done by launching the `redis-cli` and using the command `set fib_number <value>`, i.e. `set fib_number 10`.

### Output  ###

In the terminal which runs the evaluation script, the expected output will be the time it takes to complete that workload in *ms*

``` bash
$ ./EK-EvalAlert.sh
20 ms
14 ms
13 ms
15 ms
15 ms
14 ms
17 ms
14 ms
14 ms
14 ms
Finished

```

## OpenWhisk (OW) ##

Before the experiments can be run, all of the actions need to be created so that they can be used on OpenWhisk

This can be done by following the instructions in the `OW-Actions/` directory.

The scripts in this folder gather the total time taken to run a workload on OpenWhisk

### Output ###

In a terminal run the evaluation scripts. The results should look like so:

```bash
$ ./OW-EvalAlert.sh
158 ms
32 ms
36 ms
36 ms
35 ms
42 ms
44 ms
46 ms
47 ms
41 ms
41 ms
39 ms
...
```
