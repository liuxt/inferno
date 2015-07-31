#include <vector>
#include <string>
#include <fstream>

#define parallelPos 1
#define subfnPos 2

#define mapType 0
#define reduceType 1
#define mergeType 2

using namespace std;

void getContext();
void showPattern(string); 

/* contains the begin line number and the end line number of a block */
struct position {
  int begin;
  int end;

  position() {}
  
  position(int _begin, int _end) :
    begin(_begin), end(_end) {}
  
};

struct parallelCode {
  position pos;
  int type;

  parallelCode(position _pos, int _type) :
    pos(_pos), type(_type) {} 
  
}; 

extern char* fileName; // the file name of user.sh 
extern vector<int> loads; 
extern vector<string> context; // a copy of user.sh
extern vector<parallelCode> parallelPosVec; // blocks of parallel commandsv
extern vector<position> subfnPosVec; // blocks of subfns
extern int parallelID; 
extern int last_load_line;
