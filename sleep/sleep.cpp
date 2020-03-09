#include <iostream>
#include <unistd.h>

using namespace std;

int sleep_main(){
  cout<<"Sleeping\n";
  sleep(100);
  cout<<"slept\n";
  return 0;
}

int main(){
  return sleep_main();
}
