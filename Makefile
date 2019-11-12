CC=clang++
CFLAGS=-std=c++11 -stdlib=libc++ -lcpprest -lssl -lcrypto -lboost_system -lboost_thread-mt -lboost_chrono-mt -L/usr/local/opt/openssl/lib -I/usr/local/opt/openssl/include -fsanitize=address -fno-omit-frame-pointer
EXEC=bing_request
MAIN=bing_request.cpp
OUTPUT=results.html
DOCKER_SRC=/root/build/app
QUERY=ferns


all: build run open

print:
	./targets.sh

docker_leak_check:
	docker exec -it valgrind valgrind --leak-check=full $(DOCKER_SRC)/$(EXEC) $(QUERY)

docker_build:
	sudo docker build --rm --tag valgrind .

docker_run_container:
	sudo docker run --hostname valgrind --name valgrind -v app:/root/build -d -p 22021:22 valgrind

docker_run:
	docker exec -it valgrind $(DOCKER_SRC)/$(EXEC) $(QUERY)

docker_compile:
	docker exec -it valgrind g++ -o $(DOCKER_SRC)/$(EXEC) $(DOCKER_SRC)/$(MAIN) -lboost_system -lcrypto -lssl -lcpprest -std=c++11

docker_copy:
	docker cp app valgrind:root/build

open:
	open -a "Google Chrome" $(OUTPUT)

run:
	app/$(EXEC) $(QUERY)

build: app/$(MAIN)
	$(CC) -o app/$(EXEC) $(CFLAGS) app/$(MAIN)

clean:
	rm -rf app/$(EXEC) $(OUTPUT)