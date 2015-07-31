#include <string> 
#include <iostream>
#include "userFileParser.h"

using namespace std;

char* fileName; // the file name of user.sh 
vector<int> loads; 
vector<string> context; // a copy of user.sh
vector<parallelCode> parallelPosVec; // blocks of parallel commandsv
vector<position> subfnPosVec; // blocks of subfns
int parallelID = 0;
int last_load_line = 0; 

void showPattern(string s) {
  cout << s << endl; 
}

/** parse user.sh to generate neccessary info which is used to generate device.sh & host.sh **/
void getContext() { 
  string s;
  int pos_type; // currently parallelPos / subfnPos
  int line_num = 0; // currently line number
  int begin, end;
  int bracket_num = 0; // num of {
  int parallelCodeType; // currently map / reduce

  freopen(fileName, "r", stdin);
  
  while (getline(cin, s)) {
    context.push_back(s);

    /* load module commands */
    if (s.substr(0, 4) == "load") {
      loads.push_back(line_num);
      last_load_line = line_num;
    }

    /* blocks of parallel commands */
    if (s == "@parallel_begin") {
      pos_type = parallelPos; 
      begin = line_num;
    }
    if (pos_type == parallelPos && line_num == begin + 1) {
      if (s.substr(0, 3) == "map")
	parallelCodeType = mapType;
      if (s.substr(0, 6) == "reduce")
	parallelCodeType = reduceType;
      if (s.substr(0, 5) == "merge")
	parallelCodeType = mergeType;
    }
    if (s == "@parallel_end") {
      end = line_num;
      parallelPosVec.push_back(parallelCode(position(begin, end), parallelCodeType)); 
    }

    /* blocks of parallel commands */
    if (s.substr(0, 5) == "subfn") {
      pos_type = subfnPos;
      begin = line_num; 
      bracket_num = 0;
    }
    if (pos_type == subfnPos) {
      for (int i = 0; i < s.size(); i ++)
	if (s[i] == '{')
	  bracket_num ++;
	else if (s[i] == '}')
	  bracket_num --;
      if (bracket_num == 0) {
	end = line_num;
	subfnPosVec.push_back(position(begin, end));
	pos_type = 0;
      }
    }
      
    line_num ++;
  }
  fclose(stdin);
}
