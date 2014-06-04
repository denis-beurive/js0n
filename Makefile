SHELL := /bin/bash

INCLUDE_DIR = include
SRC_DIR     = src
TMP_DIR     = tmp
BIN_DIR     = bin
LIB_DIR     = lib
TEST_DIR    = test
CC          = gcc
CFLAGS      = -Wall -I$(INCLUDE_DIR)
AR          = ar
ARFLAGS     = rcs



# ---------------------------------------------------------------------------
# Build all objects.
# ---------------------------------------------------------------------------

$(TMP_DIR)/j0g.o: $(SRC_DIR)/j0g.c $(INCLUDE_DIR)/j0g.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(TMP_DIR)/js0n.o: $(SRC_DIR)/js0n.c $(INCLUDE_DIR)/js0n.h
	$(CC) -c $(CFLAGS) -o $@ $< 

# ---------------------------------------------------------------------------
# Build the library.
# ---------------------------------------------------------------------------

$(LIB_DIR)/libjs0n.a: $(TMP_DIR)/j0g.o $(TMP_DIR)/js0n.o
	$(AR) $(ARFLAGS) $(LIB_DIR)/libjs0n.a $^

lib: $(LIB_DIR)/libjs0n.a

# ---------------------------------------------------------------------------
# Execute the unit tests.
# ---------------------------------------------------------------------------

test: $(TEST_DIR)/js0n_test.c lib
	$(CC) -o $(BIN_DIR)/js0n_test $(CFLAGS) -L$(LIB_DIR) $< -ljs0n
	diff <($(BIN_DIR)/js0n_test $(TEST_DIR)/data/test.js) $(TEST_DIR)/data/res_test.txt
	diff <($(BIN_DIR)/js0n_test $(TEST_DIR)/data/test_utf8.js) $(TEST_DIR)/data/res_test_utf8.txt

all: lib test

clean:
	rm -f $(TMP_DIR)/*.o $(LIB_DIR)/*.a $(BIN_DIR)/*
