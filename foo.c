// Karl Amrhein

#include <stdio.h>

extern char **environ;

int 
main (int argc, char *argv[])
{

        int i = 0;
        for (i=0; environ[i] != NULL; i++) 
        {
                printf ("environ[%2d] == %x == %s\n", i, &environ[i], environ[i]);

        }

        printf ("\n");
        exit(0);
}
