#include <stdio.h>

int main(){

	printf("Enter the number of lines for the punishment: ");

	int a;

	scanf("%d", &a);

	if(a < 1)
	{
		printf("You entered an incorrect value for the number of lines!\n");
		return 0;
	}

	for(int i =0; i < a; i++)
		printf("C programming lanugage is the best! ");

	return 0;
}