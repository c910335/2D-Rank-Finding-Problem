BIN_DIR=bin
BUILD_DIR=build
TMP_DIR=tmp

all: clean build

clean:
	rm -rf $(BIN_DIR) $(BUILD_DIR) $(TMP_DIR)

build:
	mkdir $(BIN_DIR)
	mkdir $(BUILD_DIR)
	crystal build --release main.cr -o $(BIN_DIR)/crystal
	gcc -O2 main.c -o $(BIN_DIR)/c
	g++ -O2 main.cpp -o $(BIN_DIR)/cpp
	javac -d $(BIN_DIR) Main.java
	ghc -O2 -dynamic main.hs -outputdir=$(BUILD_DIR) -o $(BIN_DIR)/haskell

test:
	mkdir $(TMP_DIR)
	crystal generate_test_data.cr > $(TMP_DIR)/test_data.in
	$(BIN_DIR)/crystal < $(TMP_DIR)/test_data.in > $(TMP_DIR)/crystal.out
	ruby main.rb < $(TMP_DIR)/test_data.in > $(TMP_DIR)/ruby.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/ruby.out || exit 1
	$(BIN_DIR)/c < $(TMP_DIR)/test_data.in > $(TMP_DIR)/c.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/c.out || exit 1
	$(BIN_DIR)/cpp < $(TMP_DIR)/test_data.in > $(TMP_DIR)/cpp.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/cpp.out || exit 1
	java -cp $(BIN_DIR) Main < $(TMP_DIR)/test_data.in > $(TMP_DIR)/java.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/java.out || exit 1
	$(BIN_DIR)/haskell < $(TMP_DIR)/test_data.in > $(TMP_DIR)/haskell.out
	@cmp $(TMP_DIR)/crystal.out $(TMP_DIR)/haskell.out || exit 1
