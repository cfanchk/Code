#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main()
{
	int rid,cid,status;
	rid=fork();
	if(rid<0){printf("fork error!");exit(1);}
	if(rid==0)
	{
		printf("I am child.I'll sleep!\n");
		sleep(5);
		exit(0);
	}
	cid=wait(&status);
	printf("I catched a child with PID of %d.\n",cid);
	if((status&0377)==0)
		printf("It exited normally with status of %d.\n",status>>8);
	else
		printf("It is terminated by signal %d.\n",status&0177);
	exit(0);
}
