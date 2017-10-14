BIN_DIR=bin
BUILD_DIR=build
TMP_DIR=tmp

all: clean build

clean:
	rm -rf $(BIN_DIR) $(BUILD_DIR) $(TMP_DIR)

build:
	mkdir $(BIN_DIR)
	mkdir $(BUILD_DIR)
	crystal build main.cr -o $(BIN_DIR)/crystal
	gcc -O2 main.c -o $(BIN_DIR)/c
	g++ -O2 main.cpp -o $(BIN_DIR)/cpp
	javac -d $(BIN_DIR) Main.java
	ghc -O2 main.hs -outputdir=$(BUILD_DIR) -o $(BIN_DIR)/haskell
	luac -o $(BIN_DIR)/lua main.lua

test:
	mkdir $(TMP_DIR)
	crystal generate_test_data.cr > $(TMP_DIR)/test_data.in
	$(BIN_DIR)/crystal < $(TMP_DIR)/test_data.in > $(TMP_DIR)/crystal.out
	ruby main.rb < $(TMP_DIR)/test_data.in > $(TMP_DIR)/ruby.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/ruby.out || (echo "Failed: Ruby" && exit 1)
	$(BIN_DIR)/c < $(TMP_DIR)/test_data.in > $(TMP_DIR)/c.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/c.out || (echo "Failed: C" && exit 1)
	$(BIN_DIR)/cpp < $(TMP_DIR)/test_data.in > $(TMP_DIR)/cpp.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/cpp.out || (echo "Failed: C++" && exit 1)
	java -cp $(BIN_DIR) Main < $(TMP_DIR)/test_data.in > $(TMP_DIR)/java.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/java.out || (echo "Failed: Java" && exit 1)
	$(BIN_DIR)/haskell < $(TMP_DIR)/test_data.in > $(TMP_DIR)/haskell.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/haskell.out || (echo "Failed: Haskell" && exit 1)
	python3 main.py < $(TMP_DIR)/test_data.in > $(TMP_DIR)/python3.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/python3.out || (echo "Failed: Python3" && exit 1)
	lua $(BIN_DIR)/lua < $(TMP_DIR)/test_data.in > $(TMP_DIR)/lua.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/lua.out || (echo "Failed: Lua" && exit 1)
	@echo "Passed"
