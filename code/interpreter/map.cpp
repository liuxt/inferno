#include "map.h"
#include <iostream>
#include "configParser.h"
#include "templateConverter.h"
#include "userFileParser.h"
#include "deviceCodeGenerator.h"

using namespace std;

string map_parallel_array_var; 
string map_parallel_function_var;
int map_i_var;

/* i means the i^th parallel code block  */
void generateHostMapParallel(int i) {
  map_i_var = i;
  map_parallel_array_var = parallel_array[i];
  convertFromTemplate("map", "map.template", "generateHostMapParallel"); 
}

/* deviceCount means the current device file index
   This function generates parallel_command & parallel_function & parallel_array
*/
void generateDeviceMapParallel(int deviceCount) {
  parallel_command.push_back(context[parallelPosVec[deviceCount].pos.begin + 1]);
  int flag = 0;
  int lastPos;
  for (int i = parallel_command[deviceCount].size() - 1; i >= 0; i --)
    if (parallel_command[deviceCount][i] == ' ') {
      if (!flag) {
	parallel_function.push_back(parallel_command[deviceCount].substr(i + 1));
	lastPos = i;
	flag = 1;
      }
      else {
	parallel_array.push_back(parallel_command[deviceCount].substr(i + 1, lastPos - i - 1));
      }
    }
  parallel_output.push_back("");
  parallel_array1.push_back("");
}

void generateDeviceMapTail(int deviceCount) {
  map_parallel_function_var = parallel_function[deviceCount];
  convertFromTemplate("map", "map.template", "generateDeviceMapTail"); 
}
