CC=clang++
CFLAGS=-std=c++11 -stdlib=libc++ -lcpprest -lssl -lcrypto -lboost_system -lboost_thread-mt -lboost_chrono-mt -L/usr/local/opt/openssl/lib -I/usr/local/opt/openssl/include -fsanitize=address -fno-omit-frame-pointer
EXEC=bing_request
MAIN=bing_request.cpp
OUTPUT=results.html


all: build run open

print:
	./targets.sh

docker_build:
	sudo docker build --rm --tag valgrind .

docker_run:
	sudo docker run --hostname valgrind --name valgrind -v app:/root/build -d -p 22021:22 valgrind

docker_copy:
	docker cp app valgrind:root/build

open:
	open -a "Google Chrome" app/$(OUTPUT)
	
run:
	app/$(EXEC)

build: app/$(MAIN)
	$(CC) -o app/$(EXEC) $(CFLAGS) app/$(MAIN)

clean:
	rm -rf app/$(EXEC) app/$(OUTPUT) app/a.out