#include <string>
#include <vector>

using namespace std;

extern string map_parallel_array_var; 
extern string map_parallel_function_var;
extern int map_i_var;

void generateHostMapParallel(int);
void generateDeviceMapParallel(int);
void generateDeviceMapTail(int); 


