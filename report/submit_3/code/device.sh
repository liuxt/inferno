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

subfn writeRequest {
while {! ftest -e '/n/client/pool/'^${pid}} {
      	    echo ${pid} $* > $sharedPath
      }
      rm /n/client/pool/${pid}
}

subfn getTask {
      ${writeRequest 'get'}
      result = {sed 1q < $sharedPath}
}

answer = 0
sharedPath = $1
hostname = `{os hostname}`
workerLogPath = /n/client/pool/$hostname.log

echo $hostname is pending >> $workerLogPath

while {} {
      current = ${getTask}
      if {~ $current 'done'} {raise break}
      echo $hostname fetched $current >> $workerLogPath
      current_ans = ${calc $current}
      ${writeRequest 'put' $current_ans}
}

echo $hostname is finished >> $workerLogPath



