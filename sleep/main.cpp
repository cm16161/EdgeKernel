#include <os>
#include <iostream>

void Service::start(){
  extern int sleep_main();
  sleep_main();
  exit(EXIT_SUCCESS);
}
