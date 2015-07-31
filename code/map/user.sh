#!/dis/sh -n

load std mpexpr

subfn factorial {
    ans = 1
    for i in ${expr 1 $1 seq} {
        ans = ${expr $ans $i '*'}
    }
    result = $ans
    if {~ $1 0} {
        result = 1
    }
}

subfn combination {
    result = ${expr ${factorial $1} ${factorial $2} ${factorial ${expr $1 $2 -}} '*' '/'}
    if {ntest ${expr $1 $2 '<'}} {
        result = 0;
    }
}

subfn calculate {
    result = ${expr $1 1 +}
}

subfn add {
    result = ${expr $1 1 +}
}

array1 = 120 121 122 123 124 125 126 127 128 129 130

@parallel_begin
map array1 calculate
@parallel_end

array2 = 1 2 3 4 5 

@parallel_begin
map array2 add
@parallel_end
