#include "configParser.h"

using namespace std;

map<string, int> voidMap; 
vector<string> configSaver[10];
int configSaverPos[10]; 

void clear() {
  for (int i = 0; i < 10; i ++) {
    configSaver[i].clear();
    configSaverPos[i] = 0; 
  }
  voidMap.clear();
}

void readConfig(string path) {

  clear(); 

  int voidNum = 0; 
  ifstream fin(path.c_str());
  string s;
  int flag = 0; 

  while (getline(fin, s)) {
    //    cerr << s << endl;
    if (fin.eof())
      break; 
    if (s.substr(0, 4) == "void") {
      string voidName = s.substr(5);
      voidMap[voidName] = ++ voidNum;
      flag = 1; 
    }
    else if (s == "end") {
      flag = 0;
    }
    else if (flag) {
      configSaver[voidNum].push_back(s);
    }
  }
  
  fin.close(); 
}

string getNextString(string voidName) {
  //  for (map<string, int> :: iterator i  = voidMap.begin(); i != voidMap.end(); i ++)
  //cerr << i->first << endl;
  int voidNum = voidMap[voidName];
  if (configSaverPos[voidNum] == configSaver[voidNum].size()) {
    configSaverPos[voidNum] = 0; 
    return "NULL";
  }
  else
    return configSaver[voidNum][configSaverPos[voidNum] ++]; 
}
