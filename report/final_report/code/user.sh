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

subfn catalan {
    result = ${combination $1 ${expr $1 2 ‘/’}}
}

subfn funct {
    result = ${expr $1 $2 +} 
}
subfn mul {
    result = ${expr $1 $2 '*'}
}

array1 = 120 121 122 123 124 125 126 127 128 129 130

@parallel_begin
map array1 calculate
@parallel_end

echo $array1

array2 = 1 2 3 4 5 6 7 8 9 10 11

@parallel_begin
map array2 catalan
@parallel_end

echo $array2

@parallel_begin
merge array1 array2 funct array3
@parallel_end

echo $array3

@parallel_begin
reduce array3 mul acc
@parallel_end

echo $acc
