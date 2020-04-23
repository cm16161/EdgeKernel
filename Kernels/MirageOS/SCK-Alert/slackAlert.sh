#!/bin/bash

url=$(redis-cli rpop SCK-ALERT)
wget -O/dev/null -q $url
