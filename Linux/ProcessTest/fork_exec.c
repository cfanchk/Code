#include<stdio.h>
#include<unistd.h>

int main()
{
	int rid;
	rid=fork();
	if(rid<0)
	{
		printf("Fork error!");
		return 0;
	}
	if(rid>0)
		printf("I am parent, my rid is %d, my PID is %d\n",rid,getpid());
	else
	{
		printf("I am child, I'm changing to echo!\n");
		execlp("echo","echo","hello!",NULL);
	}
	return 1;
}
