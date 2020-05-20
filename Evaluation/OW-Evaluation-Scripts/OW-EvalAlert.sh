#!/bin/bash

for i in {1..50}
do

    wsk action invoke --result time -p initial $( date +%s%N )
	# a=$(../get_value.sh ow-sensor-reading)
	# b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/alert?sensor=$a)
	# ../set_value.sh ow-alert-output $b > /dev/null
done
