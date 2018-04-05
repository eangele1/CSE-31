#include <stdio.h>

void swap (int *px, int *py, int* temp) {
	*temp = *px; //Crashes here with or without proc...
	*px = *py;
	*py = *temp;
}

int* proc(int a, int b){
	int sum = a+b;
	return &sum;
}

int main () {
	int a = 1, b = 2;
	
	printf("%d %d\n",a,b);

	int *x = proc(3,4); //If this is commented out or not.

	swap(&a,&b,x);

	printf("%d %d\n",a,b);

	return 0;
}