# Experiment 3 #

This experiment compares the overall CPU usage of EdgeKernel as a whole and the individual CPU usage of a unikernel.

Scripts have been provided to monitor the CPU consumption of the system as a whole at a given timestamp.

EdgeKernel will also periodically output the number of Unikernels that are being run at a given timestamp.

## Setup ##

To run this experiment, run the `metrics.sh` script simultaneously with `EdgeKernel.rb` and the `burstThroughput.sh` script.

## Output ##

The output will be a separate file called `cpu.txt` which outputs the total amount of memory being used on your machine.

Additionally, a separate file called `server/active_unikernels.txt` will be generated which outputs the number of active unikernels for a given timestamp.
