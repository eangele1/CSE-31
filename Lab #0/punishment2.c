#include <stdio.h>

int main(){

	printf("Enter the number of lines for the punishment: ");

	int a, b;

	scanf("%d", &a);

	if(a < 1){
		printf("You entered an incorrect value for the number of lines!\n");
		return 0;
	}

	printf("Enter the line for which we want to make a typo: ");

	scanf("%d", &b);

	if (b < 1 || b > a){
		printf("You entered an incorrect value for the line typo!\n");
		return 0;
	}

	for(int i = 1; i <= a; i++){
		if (i == b)
			printf("C programming lanugage is the bet! ");
		else
			printf("C programming lanugage is the best! ");
	}

	return 0;
}