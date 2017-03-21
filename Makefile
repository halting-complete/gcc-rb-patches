CC = $(PWD)/../gcc-build/vroot/usr/local/bin/gcc

ENV_test1 = SOURCE_PREFIX_MAP=$$PWD=.
CFLAGS_test1 = -g

ENV_test2 = SOURCE_PREFIX_MAP=$$PWD=.

DATE_1973 = @100000000

PRERUN_test3 = touch -d$(DATE_1973) test3.c
ENV_test3 = SOURCE_DATE_EPOCH=0

PRERUN_test4 = touch -d$(DATE_1973) test4.c
ENV_test4 = SOURCE_DATE_EPOCH=$$(date +%s)

all: run-test1 run-test2 run-test3 run-test4
clean: clean-test1 clean-test2 clean-test3 clean-test4

clean-test%:
	rm -f test$*

run-test1: clean-test1 test1
	strings ./test1 | { ! grep "$$(basename "$$PWD")"; }

run-test2: clean-test2 test2
	./test2 | { ! grep "$$(basename "$$PWD")"; }

run-test3: clean-test3 test3
	./test3 | grep 1970

run-test4: clean-test4 test4
	./test4 | grep 1973

test%: test%.c
	$(PRERUN_$@)
	$(ENV_$@) $(CC) $(CFLAGS_$@) "$$PWD/$<" -o "$@"

test4.c: test3.c
	cp "$<" "$@"
