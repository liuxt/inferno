#!/dis/sh -n

load std mpexpr

subfn fac {
    ans = 1
    for j in ${expr 1 $1 seq} {
    	ans = ${expr $ans $j '*'}
    }
    result = $ans
    if {~ $1 0} {
       result = 1
    }
}

subfn c {
      n = $1
      r = $2
      n_fac = ${fac $n}
      r_fac = ${fac $r}
      n_r_fac = ${fac ${expr $n $r '-'}}
      ans = ${expr $r_fac $n_r_fac '*'}
      result = ${expr $n_fac $ans '/'}
}

subfn calc {
      n = $1
      num = 0
      for r in ${expr 1 $n seq} {
      	  if {~ ${expr ${c $n $r} 1000000 '>'} 1} {
	     num = ${expr $num 1 '+'}
	  }
      }
      result = $num
}

ans = 0
for i in ${expr 23 100 seq} {
      ans = ${expr $ans ${calc $i} '+'}
}
echo $ans

