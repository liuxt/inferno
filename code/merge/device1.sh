#!/dis/sh -n

load std mpexpr

subfn funct {
    result = ${expr $1 $2 +}
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
      (TAP DATA1 DATA2) = $current
      ANS = ${funct $DATA1 $DATA2}
      current_ans = ($TAP $ANS)
      echo $current put_ans : $current_ans >> $workerLogPath
      ${writeRequest 'put' $current_ans}
}

echo ${pid} $hostname is finished >> $workerLogPath
