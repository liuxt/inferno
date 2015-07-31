#include "map.h"
#include "merge.h"
#include "reduce.h"
#include "configParser.h"
#include "templateConverter.h"

void printVar(string type, string varName) {
  if (type == "merge") {
    if (varName == "parallel_array1_var")
      cout << merge_parallel_array1_var;
    else if (varName == "i_var")
      cout << merge_i_var;
    else if (varName == "parallel_array_var")
      cout << merge_parallel_array_var;
    else if (varName == "parallel_function_var")
      cout << merge_parallel_function_var;
    else if (varName == "parallel_output_var")
      cout << merge_parallel_output_var;
  }
  else if (type == "map") {
    if (varName == "parallel_function_var")
      cout << map_parallel_function_var;
    else if (varName == "i_var")
      cout << map_i_var;
    else if (varName == "parallel_array_var")
      cout << map_parallel_array_var; 
  }
  else if (type == "reduce") {
    if (varName == "i_var")
      cout << reduce_i_var;
    else if (varName == "parallel_array_var")
      cout << reduce_parallel_array_var;
    else if (varName == "parallelID_var")
      cout << reduce_parallelID_var;
    else if (varName == "parallel_output_parallelID_var")
      cout << reduce_parallel_output_parallelID_var;
    else if (varName == "parallel_function_deviceCount_var")
      cout << reduce_parallel_function_deviceCount_var;
    else if (varName == "parallel_function_parallelID_var") 
      cout << reduce_parallel_function_parallelID_var;
  }
}

void convertFromTemplate(string type, string fileName, string voidName) {
  readConfig(fileName);
  
  string s;
  string varName = ""; 
  int flag = 0; 
  while ((s = getNextString(voidName)) != "NULL") {
    for (int i = 0; i < s.size(); i ++) {
      if (s[i] == '?') {
	flag = (flag + 1) % 2;
	if (flag == 0) {
	  printVar(type, varName);
	  varName = ""; 
	}
      }
      else if (flag) {
	varName += s[i]; 
      }
      else
	cout << s[i]; 
    }
    cout << endl; 
  }
  //  cerr << s << endl;
}
