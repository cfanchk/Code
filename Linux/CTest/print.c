#include<stdio.h>
#include<string.h>
#include"print.h"
void my_print(char* str)
{
	int i;
	for(i=0;i<strlen(str)+4;i++)
		printf("%c",borderchar);
	printf("\n");
	printf("%c %s %c",borderchar,str,borderchar);
	printf("\n");
	for(i=0;i<strlen(str)+4;i++)
		printf("%c",borderchar);
	printf("\n");
}
