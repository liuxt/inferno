#include "merge.h"
#include <iostream>
#include "userFileParser.h"
#include "templateConverter.h"
#include "deviceCodeGenerator.h"

using namespace std;

string merge_parallel_array1_var;
string merge_parallel_array_var;
string merge_parallel_output_var; 
int merge_i_var;
string merge_parallel_function_var; 

/* i means the i^th parallel code block  */
void generateHostMergeParallel(int i) {
  merge_i_var = i;
  merge_parallel_array_var = parallel_array[i];
  merge_parallel_array1_var = parallel_array1[i];
  merge_parallel_output_var = parallel_output[i]; 
  convertFromTemplate("merge", "merge.template", "generateHostMergeParallel"); 
}

/* deviceCount means the current device file index
   This function generates parallel_command & parallel_function & parallel_array
*/
void generateDeviceMergeParallel(int deviceCount) {
  parallel_command.push_back(context[parallelPosVec[deviceCount].pos.begin + 1]);
  int flag = 0;
  int lastPos;
  for (int i = parallel_command[deviceCount].size() - 1; i >= 0; i --)
    if (parallel_command[deviceCount][i] == ' ') {
      if (!flag) {
	parallel_output.push_back(parallel_command[deviceCount].substr(i + 1));
	lastPos = i;
	flag = 1;
      }
      else if (flag == 1) {
	parallel_function.push_back(parallel_command[deviceCount].substr(i + 1, lastPos - i - 1));
	lastPos = i;
	flag = 2;
      }
      else if (flag == 2) {
	parallel_array.push_back(parallel_command[deviceCount].substr(i + 1, lastPos - i - 1));
	lastPos = i;
	flag = 3; 
      }
      else if (flag == 3) {
	parallel_array1.push_back(parallel_command[deviceCount].substr(i + 1, lastPos - i - 1));
	lastPos = i;
      }
    }
}

void generateDeviceMergeTail(int deviceCount) {
  merge_parallel_function_var = parallel_function[deviceCount]; 
  convertFromTemplate("merge", "merge.template", "generateDeviceMergeTail");   
}
