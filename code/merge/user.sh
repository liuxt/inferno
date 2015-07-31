#!/dis/sh -n
load std mpexpr

subfn funct {
    result = ${expr $1 $2 +}
}

input_list1 = ${expr 1 99 seq}
input_list2 = ${expr 99 1 seq}

@parallel_begin
merge input_list1 input_list2 funct output_list
@parallel_end

echo $output_list

@parallel_begin
merge output_list output_list funct output_list
@parallel_end

echo $output_list
