ANTLR_JAR ?= libs/antlr-4.13.2-complete.jar

GRAMMAR   := SplLexer
GEN_DIR   := src/main/java/generated/$(GRAMMAR)
CLASS_DIR := target/classes
JAR_FILE  := target/project1.jar

TEST_IN_DIR  := testcases/project1/in
TEST_OUT_DIR := testcases/project1/out

.PHONY: all generate compile build run test clean

all: build


generate:
	rm -rf $(GEN_DIR)
	mkdir -p $(GEN_DIR)
	java \
		-Xms16m \
		-Xmx256m \
		-XX:MaxMetaspaceSize=128m \
		-jar $(ANTLR_JAR) \
		-Dlanguage=Java \
		-o $(GEN_DIR) \
		-package generated.$(GRAMMAR) \
		$(GRAMMAR).g4


compile: generate
	rm -rf $(CLASS_DIR)
	mkdir -p $(CLASS_DIR)
	javac \
		-J-Xms16m \
		-J-Xmx256m \
		-J-XX:MaxMetaspaceSize=128m \
		-encoding UTF-8 \
		-cp $(ANTLR_JAR) \
		-d $(CLASS_DIR) \
		$$(find src/main/java -name '*.java' -print)


build: compile
	mkdir -p target
	jar \
		--create \
		--file $(JAR_FILE) \
		-C $(CLASS_DIR) .


run: build
	java \
		-Xms16m \
		-Xmx128m \
		-XX:MaxMetaspaceSize=128m \
		-cp $(JAR_FILE):$(ANTLR_JAR) \
		Main


test: build
	@set -e; \
	found=0; \
	passed=0; \
	total=0; \
	for input in $(TEST_IN_DIR)/*.splc; do \
		[ -e "$$input" ] || continue; \
		found=1; \
		total=$$((total + 1)); \
		name=$$(basename "$$input" .splc); \
		expected="$(TEST_OUT_DIR)/$$name.out"; \
		if [ ! -f "$$expected" ]; then \
			echo "[MISSING] $$expected"; \
			exit 1; \
		fi; \
		actual=$$(mktemp); \
		java \
			-Xms16m \
			-Xmx128m \
			-XX:MaxMetaspaceSize=128m \
			-cp $(JAR_FILE):$(ANTLR_JAR) \
			Main < "$$input" > "$$actual"; \
		if diff -u "$$expected" "$$actual" > /dev/null; then \
			echo "[PASS] $$name"; \
			passed=$$((passed + 1)); \
		else \
			echo "[FAIL] $$name"; \
			echo "----------------------------------------"; \
			diff -u "$$expected" "$$actual" || true; \
			echo "----------------------------------------"; \
		fi; \
		rm -f "$$actual"; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "No testcases found in $(TEST_IN_DIR)."; \
		exit 1; \
	fi; \
	echo; \
	echo "Result: $$passed / $$total passed"; \
	if [ "$$passed" -ne "$$total" ]; then \
		exit 1; \
	fi


clean:
	rm -rf target
	rm -rf src/main/java/generated