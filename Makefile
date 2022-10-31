.POSIX:
CC = cc
CFLAGS = -std=c99 -Wall -Wextra -Os
LDFLAGS = -g

all: snowid

test: unit
	./unit

benchmark: bench
	./bench

unit: snowid.o snowid_util.o snowid_checkpoint.o snowid_test.o 
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ snowid.o snowid_util.o snowid_checkpoint.o snowid_test.o

snowid_test.o: tests/snowid_test.c snowid.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c tests/snowid_test.c -o $@ -I$(PWD)

snowid: snowid.o snowid_util.o snowid_checkpoint.o main.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ snowid.o snowid_util.o snowid_checkpoint.o main.o

snowid.o: snowid.c snowid.h
	$(CC) $(CFLAGS) -c snowid.c -o $@

snowid_util.o: snowid_util.c snowid_util.h
	$(CC) $(CFLAGS) -c snowid_util.c -o $@

snowid_checkpoint.o: snowid_checkpoint.c snowid_checkpoint.h
	$(CC) $(CFLAGS) -c snowid_checkpoint.c -o $@

main.o: examples/main.c snowid.h
	$(CC) $(CFLAGS) -c examples/main.c -o $@ -I$(PWD)

bench: snowid.o snowid_util.o snowid_checkpoint.o bench.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ snowid.o snowid_util.o snowid_checkpoint.o bench.o

bench.o: examples/bench.c snowid.h
	$(CC) $(CFLAGS) -c examples/bench.c -o $@ -I$(PWD)

clean:
	rm -rf main.o snowid.o snowid_util.o snowid_checkpoint.o snowid_test.o bench.o
	rm -rf snowid bench unit timestamp.out 
.PHONY: clean