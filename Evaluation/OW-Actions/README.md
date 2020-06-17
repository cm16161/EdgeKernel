# OW-Actions #

This directory stores the actions which are used by OpenWhisk to run
the evaluation tests.

Enter the following commands to create the actions:

```bash
wsk action create alert alert.js --web true
wsk action create dhs dhs.js --web true
wsk action create fib fibonnaci.js --web true
wsk action create fdc fdc.js --web true
wsk action create lights lights.js --web true
wsk action create time time.js --web true
wsk action create usecase usecase.js --web true
```
