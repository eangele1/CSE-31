#include <stdio.h>

int main(){

	char name[70];

	printf("Please enter your name: ");
	scanf("%[^\n]", name);

	printf("Welcome to CSE31, %s", name);
	printf("!");
	printf("\n");

	return 0;
}