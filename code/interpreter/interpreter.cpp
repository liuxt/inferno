#include "userFileParser.h"
#include "deviceCodeGenerator.h"
#include "hostCodeGenerator.h"

int main(int argc, char* argv[]) {

  fileName = argv[1];

  getContext();
  /* can't change the order of getDeviceCode() & getHostCode()
     because getHostCode() rely the info (e.g. map_function) generates in getDeviceHost() 
   */
  getDeviceCode();
  getHostCode(); 
  
  return 0;
}
