#set to the compiler of your system... use gcc-7 for MAC
CC = gcc  
#Using -Ofast instead of -O3 might result in faster code, but is supported only by newer GCC versions
CFLAGS = -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result

all: word2vec distance 

word2vec : word2vec.c
	$(CC) word2vec.c -o word2vec $(CFLAGS)
distance : distance.c
	$(CC) distance.c -o distance $(CFLAGS)

clean:
	rm -rf word2vec distance
