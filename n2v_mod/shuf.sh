#!/bin/bash

if [ $# -lt 3 ]
then
	echo "Usage: $0 <gecmi fmt partition> <num samples> <wsize>"
  exit
fi

while read line
do
	for i in `seq 1 1 $2`
	do
		echo $line | awk '{for(i=1;i<=NF;i++)print $i}' | shuf | head -n $3 | awk '{b=b " " $1} END{print b}'
	done
done < $1
