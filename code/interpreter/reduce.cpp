#include <iostream>
#include "reduce.h"
#include "userFileParser.h"
#include "templateConverter.h"
#include "deviceCodeGenerator.h"


using namespace std;

int deviceNum = 0;

int reduce_i_var; 
string reduce_parallel_array_var;
int reduce_parallelID_var;
string reduce_parallel_output_parallelID_var;
string reduce_parallel_function_deviceCount_var;
string reduce_parallel_function_parallelID_var; 

void generateListPrepare(int i) {
  reduce_parallel_array_var = parallel_array[i];
  convertFromTemplate("reduce", "reduce.template", "generateListPrepare"); 
}

void getDeviceNum() {
  deviceNum = 0; 
  FILE *fp;
  fp = fopen("device_ip", "r");
  char tmp[30]; 
  while (EOF != fscanf(fp, "%s", tmp))
    deviceNum ++; 
  fclose(fp);
}

void generateDevideListLoop(){
  for (int i = 0; i < deviceNum; i ++) {
    reduce_i_var = i;
    reduce_parallelID_var = parallelID;
    convertFromTemplate("reduce", "reduce.template", "generateDevideListLoop"); 
  }
}

static void generateDevideList(int i) {
  generateListPrepare(i);
  getDeviceNum(); 

  cout << endl; 
  generateDevideListLoop();
}

void generateIO_logPartLoop_cannotWrite(){
  for (int i = 0; i < deviceNum; i ++) {
    reduce_i_var = i;
    reduce_parallelID_var = parallelID;
    convertFromTemplate("reduce", "reduce.template", "generateIO_logPartLoop_cannotWrite");     
  }
}

void generateIO_logPartLoop_file2chan(){
  for (int i = 0; i < deviceNum; i ++) {
    reduce_parallelID_var = parallelID;
    reduce_i_var = i;
    convertFromTemplate("reduce", "reduce.template", "generateIO_logPartLoop_file2chan");     
  }
}

void generateIO_logPart() {
  cout << "host = `{cat device_ip}" << endl;

  /* log */
  for (int i = 0; i < deviceNum; i ++)
    cout << "mode" << parallelID << "_" <<  i << " = ''" << endl;
  cout << "hostLogPath = /pool/host.log" << endl;
  cout << endl; 
  
  /* cannotWrite */
  generateIO_logPartLoop_cannotWrite();

  /* file2chan */
  cout << endl; 
  generateIO_logPartLoop_file2chan();
}

void generateHostTail_exe(int i){
  reduce_i_var = i;
  reduce_parallelID_var = parallelID;
  convertFromTemplate("reduce", "reduce.template", "generateHostTail_exe");       
}

void generateHostTail_process(){
  reduce_parallelID_var = parallelID;
  reduce_parallel_function_parallelID_var = parallel_function[parallelID];
  reduce_parallel_output_parallelID_var = parallel_output[parallelID];
  convertFromTemplate("reduce", "reduce.template", "generateHostTail_process");         
}

void generateHostTail(int id) {
  generateHostTail_exe(id);

  for (int i = 0; i < deviceNum; i ++) {
    cout << "while {! ftest -e /pool/finish" << i << "}{" << endl;
    cout << "}" << endl;
    cout << endl;
  }

  for (int i = 0; i < deviceNum; i ++) {
    cout << "while {ftest -e /pool/finish" << i << "} {" << endl; 
    cout << "    rm /pool/finish" << i << endl; 
    cout << "}" << endl;
    cout << endl; 
  }
  generateHostTail_process();
}

void generateHostReduceParallel(int i) {
  generateDevideList(i);
  generateIO_logPart();
  generateHostTail(i); 
}

/* deviceCount means the current device file index                                                                                                  
  This function generates parallel_command & parallel_function & parallel_array                                                                             
*/
void generateDeviceReduceParallel(int deviceCount) {
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
      else
	parallel_array.push_back(parallel_command[deviceCount].substr(i + 1, lastPos - i - 1));
    }
  parallel_array1.push_back("");
}

void generateDeviceReduceTail(int deviceCount) {
  reduce_parallel_function_deviceCount_var = parallel_function[deviceCount];
  convertFromTemplate("reduce", "reduce.template", "generateDeviceReduceTail"); 
}
