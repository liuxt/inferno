#include <string>
#include <vector>

using namespace std;

extern string merge_parallel_array1_var;
extern string merge_parallel_array_var;
extern string merge_parallel_output_var; 
extern int merge_i_var;
extern string merge_parallel_function_var; 

void generateHostMergeParallel(int);
void generateDeviceMergeParallel(int);
void generateDeviceMergeTail(int); 


