#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>


int main(void) 
{

 int pid;
 pid = fork();
 pid = fork();
 if (pid == -1) 
 {
    perror("failed: ");
    exit(123);
 }
 if (pid ==  0) 
 {
    printf("child == %d, %d\n", getpid(), pid);
    sleep(90);
    _exit(0);
 }
 printf("parent == %d, and my child == %d\n", getpid(), pid);
 waitpid(pid, 0, 0);
 exit(0);
}
