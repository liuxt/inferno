#include "map.h"
#include <string>
#include "merge.h"
#include <fstream>
#include "reduce.h"
#include <iostream>
#include "userFileParser.h"

int serialStart;
int serialEnd;

const string shebang = "#!/dis/sh -n";

static void generateHeader() {
  freopen("host.sh", "w", stdout);

  cout << shebang << endl;
  cout << endl; 
  
  cout << "load std file2chan" << endl;
}

static void generateParallelPart() {

  serialStart = 1;
  serialEnd = parallelPosVec[0].pos.begin - 1;
  
  for (int i = 0; i < parallelPosVec.size(); i ++) {
    parallelID = i;
    
    // block of parallel code
    for (int j = serialStart; j <= serialEnd; j ++) {
      cout << context[j] << endl;
    }
    cout << endl;

    switch (parallelPosVec[i].type) {
      case mapType : {
        generateHostMapParallel(i);
        break;
      }
      case reduceType : {
        generateHostReduceParallel(i);
        break; 
      }	
      case mergeType : {
        generateHostMergeParallel(i);
        break; 
      }
    }

    serialStart = parallelPosVec[i].pos.end  + 1;
    if (i == parallelPosVec.size() - 1)
      serialEnd = context.size() - 1;
    else
      serialEnd = parallelPosVec[i + 1].pos.begin - 1;
    
  }

}

void static generateTail() {
  // last block of serial code
  for (int i = serialStart; i <= serialEnd; i ++)
    cout << context[i] << endl; 
    
  fclose(stdout);
}

void getHostCode() {
  generateHeader();
  generateParallelPart();
  generateTail();
}

