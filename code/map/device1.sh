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

subfn writeRequest {
      while {! ftest -e '/n/client/pool/'^${pid}} {
            echo ${pid} $* > $sharedPath
      }
      rm /n/client/pool/${pid}
}

subfn getTask {
      ${writeRequest 'get'}
      result = `{sed 1q < $sharedPath}
}

sharedPath = $1
hostname = `{os hostname}
workerLogPath = /n/client/pool/$hostname.log

echo $hostname is pending >> $workerLogPath

while {} {
      current = ${getTask}
      if {~ $current 'done'} {raise break}
         echo $hostname fetched $current >> $workerLogPath
      (TAP DATA) = $current
      ANS = ${add $DATA}
      current_ans = ($TAP $ANS)
      echo $current put_ans : $current_ans >> $workerLogPath
      ${writeRequest 'put' $current_ans}
}

echo ${pid} $hostname is finished >> $workerLogPath
