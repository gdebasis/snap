# N2V-Mod (Modularity driven Node Embedding)

This is a fork from the Stanford Graph processing library, [SNAP]([https://github.com/snap-stanford/snap](https://github.com/snap-stanford/snap)). This library implements a variation of skip-gram and continuous bag-of-words of [word2vec](https://github.com/tmikolov/word2vec), where in order to obtain node embeddings that respect a given community structure (obtained by a [modularity ](https://en.wikipedia.org/wiki/Modularity_(networks)) heuristic method.

It turns out that the results obtained with the additional constraints tend to improve the community detection.

To evaluate community-driven node embedding, first execute
```
make
```
in the project folder. This will compile the SNAP project files and build the executables.

Next do the following to make the word2vec variant.
```
cd n2v_mod
cd word2vec
make
cd ..
```

I have provided a the following as sample data.
1. A synthetically generated graph, named LFR4k, comprising 4000 nodes.
2.  A community structure.
3. The ground-truth of the graph.

For executing the community-driven node embedding on this sample data, simply execute
```
sh snapw2v.sh data/lfr4k/lfr4k.graph.txt data/lfr4k/emb.mod 150 data/lfr4k/gt.txt data/lfr4k/mod.txt
```
The script takes the following arguments:

1. The path of the graph file (in the above example this points to the synthetic LFR4k graph).
2. Prefix of the output path for writing out the embedding (binary and text format) and the clusters.
3. The number of desired communities.
4. The ground-truth for evaluation.
5. The modularity driven partition.

The last parameter is optional. If you don't specify a value then the algorithm boils down to standard node2vec.

