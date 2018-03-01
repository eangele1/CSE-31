#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char hello[] = "hello ", world[] = "world!\n", *s;
    
    s = malloc(strlen(hello));
    
    strcpy(s, hello);
    strcat(s, world);
    
    printf("%s",s);
    
    free(s);
    
    return 0;
}
