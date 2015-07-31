#include <vector>
#include <string>

using namespace std; 

void generateHostReduceParallel(int);
void generateDeviceReduceParallel(int);
void generateDeviceReduceTail(int);

extern int reduce_i_var; 
extern string reduce_parallel_array_var;
extern int reduce_parallelID_var;
extern string reduce_parallel_output_parallelID_var;
extern string reduce_parallel_function_deviceCount_var;
extern string reduce_parallel_function_parallelID_var; 

