#!/dis/sh -n
load std mpexpr

subfn funct {
    result = ${expr $1 $2 +}
}

input_list = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32

@parallel_begin
reduce input_list funct acc1
@parallel_end

subfn mul {
	result = ${expr $1 $2 '*'}
}

@parallel_begin
reduce input_list mul acc2
@parallel_end
