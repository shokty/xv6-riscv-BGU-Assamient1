#include "kernel/types.h"
#include "kernel/syscall.h"
#include "user/user.h"
#include "kernel/fcntl.h"



// Task 3 
struct perf{
  int ctime;                    // Creation time 
  int ttime;                    // Termination time
  int stime;                    // Sleep total time 
  int retime;                   // Runnable total time
  int rutime;                   // Running total time 
  int bursttime;                // Estimated burst time   
};


int main(int argc , char** argv) {
    int sum = 0;
    if(fork() == 0){
        // Child 
        
        sleep(50);
        if(sbrk(5) != 0 ){
            for(int i = 0 ; i < 300 && sbrk(1) ; i ++ )
                if(chdir("\\"))
                    {sum += 1;} 

        }
        printf("sum = %d\n",sum);
    }  else {
        // Parent 
        int status = 0 ;
        struct perf performance = {0 , 0 , 0 , 0 , 0 , 0 }; 
        wait_stat(&status,&performance);
        printf("status = %d , ctime = %d , ttime = %d , stime = %d , retime = %d , rutime = %d \n",
        status, 
        performance.ctime,
        performance.ttime,
        performance.stime,
        performance.retime,
        performance.rutime
        );
    }
    exit(0);
}