#a simple makefile for hello
hello:hello.o print.o
	g++ -o hello hello.o print.o
hello.o: hello.c print.h
	g++ -c hello.c print.h
print.o: print.c print.h
	g++ -c print.c print.h
clean:
	rm -f *.o *.h.gch hello 
