#!/bin/bash

if [ $# -lt 4 ]
then
	echo "Usage: $0 <graph file> <output-file> <communities> <ground-truth> [<modularity>]"
        exit
fi

WORD2VEC=word2vec/word2vec
N2V=../examples/node2vec/node2vec

if [ $# -gt 4 ]
then
	MODULARITY_FILE=$5
	#remove trailing spaces
	cat $MODULARITY_FILE | sed 's/ $//g' > tmp
	mv tmp $MODULARITY_FILE 
fi

GRAPH_FILE=$1
OUTFILE=$2
K=$3
GT=$4

GRAPH_RW=$GRAPH_FILE.rw

#if [ ! -e $GRAPH_RW ]
#then 

#Generate the random walk with the SNAP executable
$N2V -i:$GRAPH_FILE -o:$GRAPH_RW -v -ow

#fi


#### params ####
SIZE=128
WINDOW=10
NS=20
ITERS=5
BETA=0.6

if [ $# -gt 4 ]
then
	$WORD2VEC -train $GRAPH_RW -output $OUTFILE -size $SIZE -window $WINDOW -sample 1e-4 -negative $NS -hs 0 -cbow 0 -iter $ITERS -min-count 1 -classes $K -ct $MODULARITY_FILE -ct-match-wt $BETA -debug 2
else
	$WORD2VEC -train $GRAPH_RW -output $OUTFILE -size $SIZE -window $WINDOW -sample 1e-4 -negative $NS -hs 0 -cbow 0 -iter $ITERS -min-count 1 -classes $K -debug 2
fi

CLUST_FILE=$OUTFILE.clust
cat $CLUST_FILE | tail -n+2 | awk '{list[$2] = list[$2] " " $1} END{for (c in list) print list[c]}' > $CLUST_FILE.$BETA.gecmi

GECMI=gecmi/bin/Release/gecmi
$GECMI $GT $CLUST_FILE.gecmi

