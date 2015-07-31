#include "map.h"
#include "merge.h"
#include "reduce.h"
#include <iostream>
#include "userFileParser.h"
#include "deviceCodeGenerator.h"

position pos;
int deviceCount;
int parallelCodeType;

vector<string> parallel_array;   // the name of the array been mapped
vector<string> parallel_array1;   // the name of the array been mapped
vector<string> parallel_function; // the function used to map
vector<string> parallel_command; // e.g. map array add
vector<string> parallel_output; 

const string shebang = "#!/dis/sh -n";

static void generateHeader() {
  string deviceFileName = "device";
  deviceFileName += (char)(deviceCount + '0');
  deviceFileName += ".sh";
  
  freopen(deviceFileName.c_str(), "w", stdout);

  cout << shebang << endl;
  cout << endl;

  // display load modules command  
  for (int i = 0; i < loads.size(); i ++)
    cout << context[loads[i]] << endl;

  switch (parallelPosVec[deviceCount].type) {
    case reduceType :  {
      cout << "flag = 0" << endl;
      cout << "ANS = 0" << endl;
      break; 
    }
  default : break;  
  }
  
  cout << endl;
}

static void generateSubfns() {
  for (int i = last_load_line + 1; i < subfnPosVec[0].begin; i ++)
    cout << context[i] << endl; 
  for (int i = 0; i < subfnPosVec.size(); i ++) {
    position pos = subfnPosVec[i];
    for (int j = pos.begin; j <= pos.end; j ++)
      cout << context[j] << endl;
    cout << endl; 
  }
}

static void generateParallelPart() {
  switch (parallelPosVec[deviceCount].type) {
  case mapType : {
    generateDeviceMapParallel(deviceCount);
    break;
  }
  case reduceType :  {
    generateDeviceReduceParallel(deviceCount);
    break;
  }
  case mergeType :  {
    generateDeviceMergeParallel(deviceCount);
    break;
  }
  }
}

/* This functions generate the code blocks of IO parts which is used to communicate with host's file2chan and log parts */

static void generateIO_logPart() {
  cout << "subfn writeRequest {" << endl;
  cout << "      while {! ftest -e '/n/client/pool/'^${pid}} {" << endl;
  cout << "            echo ${pid} $* > $sharedPath" << endl;
  cout << "      }" << endl;
  cout << "      rm /n/client/pool/${pid}" << endl;
  cout << "}" << endl;
  cout << endl;

  cout << "subfn getTask {" << endl;
  cout << "      ${writeRequest 'get'}" << endl;
  cout << "      result = `{sed 1q < $sharedPath}" << endl;
  cout << "}" << endl;
  cout << endl; 

  cout << "sharedPath = $1" << endl;
  cout << "hostname = `{os hostname}" << endl;
  cout << "workerLogPath = /n/client/pool/$hostname.log" << endl;
  cout << endl; 

  cout << "echo $hostname is pending >> $workerLogPath" << endl;
  cout << endl;

}

static void generateTail() {
  cout << "while {} {" << endl;
  cout << "      current = ${getTask}" << endl;
  cout << "      if {~ $current 'done'} {raise break}" << endl;
  cout << "         echo $hostname fetched $current >> $workerLogPath" << endl;
  
  switch (parallelPosVec[deviceCount].type) {
  case mapType : {
    generateDeviceMapTail(deviceCount);
    break;
  }
  case reduceType :  {
    generateDeviceReduceTail(deviceCount);
    break;
  }
  case mergeType :  {
    generateDeviceMergeTail(deviceCount);
    break;
  }
  }
  
  cout << "echo ${pid} $hostname is finished >> $workerLogPath" << endl;

  fclose(stdout); 
  
}

static void generateDeviceCode(int _deviceCount, parallelCode _parallelCode) {
  deviceCount = _deviceCount, pos = _parallelCode.pos;
  parallelCodeType = _parallelCode.type; 
  generateHeader(); 
  generateSubfns(); 
  generateParallelPart();
  generateIO_logPart(); 
  generateTail(); 
}

void getDeviceCode() {
  for (int i = 0; i < parallelPosVec.size(); i ++) {
    generateDeviceCode(i, parallelPosVec[i]); 
  }
}
