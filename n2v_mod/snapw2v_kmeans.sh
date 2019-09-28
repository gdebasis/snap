#!/bin/bash

if [ $# -lt 4 ]
then
	echo "Usage: $0 <graph file> <output-file> <communities> <ground-truth>"
        exit
fi

WORD2VEC=word2vec/word2vec
N2V=../examples/node2vec/node2vec
BETA=1

GRAPH_FILE=$1
OUTFILE=$2
K=$3
GT=$4

GRAPH_RW=$GRAPH_FILE.rw

if [ ! -e $GRAPH_RW ]
then 

#Generate the random walk with the SNAP executable
$N2V -i:$GRAPH_FILE -o:$GRAPH_RW -v -ow

fi

#### params ####
SIZE=128
WINDOW=10
NS=20
ITERS=5

if [ ! -e $OUTFILE.vec ]
then
#First pass node2vec
$WORD2VEC -train $GRAPH_RW -output $OUTFILE -size $SIZE -window $WINDOW -sample 1e-4 -negative $NS -hs 0 -cbow 0 -iter $ITERS -min-count 1 -classes $K -debug 2
fi

CLUST_FILE=$OUTFILE.clust
cat $CLUST_FILE | tail -n+2 | awk '{list[$2] = list[$2] " " $1} END{for (c in list) print list[c]}' > $CLUST_FILE.$BETA.gecmi

GECMI=gecmi/bin/Release/gecmi
$GECMI $GT $CLUST_FILE.$BETA.gecmi

#Create a partition file based on the clusters
NUMSAMPLES=100
echo "writing out $NUMSAMPLES samples"
./shuf.sh $CLUST_FILE.$BETA.gecmi $NUMSAMPLES $WINDOW > $CLUST_FILE.kmeans

cat $CLUST_FILE.kmeans > $GRAPH_RW.kmeans
cat $GRAPH_RW >> $GRAPH_RW.kmeans

BETA=0.6
#2nd pass Node2vec
$WORD2VEC -train $GRAPH_RW.kmeans -output $OUTFILE.kmeans -size $SIZE -window $WINDOW -sample 1e-4 -negative $NS -hs 0 -cbow 0 -iter $ITERS -min-count 1 -classes $K -debug 2 -ct $CLUST_FILE.kmeans -ct-match-wt $BETA -pt $OUTFILE.bin

OUTFILE=$OUTFILE.kmeans

CLUST_FILE=$OUTFILE.clust
cat $CLUST_FILE | tail -n+2 | awk '{list[$2] = list[$2] " " $1} END{for (c in list) print list[c]}' > $CLUST_FILE.$BETA.gecmi

$GECMI $GT $CLUST_FILE.$BETA.gecmi

