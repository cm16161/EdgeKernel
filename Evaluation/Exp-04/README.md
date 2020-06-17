# Scalability #

Evaluates whether or not EdgeKernel can scale when demand is high, and what performance benefits can be seen when running multiple unikernels concurrently to process large amounts of data.

To run this experiment, execute teh `burstThroughput.sh` script. 

In a separate terminal execute EdgeKernel

This experiment sends an increasing workload for EdgeKernel to process. For each *i* in range 1 to 100, process *100i* data-items.
The terminal which runs the script will output the following information.

## Output ##


```bash
1 / 100
86 ms
2 / 100
117 ms
3 / 100
148 ms
4 / 100
233 ms
5 / 100
284 ms
6 / 100
336 ms
7 / 100
240 ms
8 / 100
424 ms
9 / 100
459 ms
10 / 100
532 ms
...
```
