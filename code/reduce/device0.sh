#!/dis/sh -n

load std mpexpr
flag = 0
ANS = 0

subfn funct {
    result = ${expr $1 $2 +}
}

subfn mul {
	result = ${expr $1 $2 '*'}
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
      DATA = $current
      if {~ $flag 0} {
          ANS = $DATA
          flag = 1
      } {
          ANS = ${funct $ANS $DATA}
      }
      echo $current put_ans : $ANS >> $workerLogPath
      ${writeRequest 'put' $ANS}
}
echo ${pid} $hostname is finished >> $workerLogPath
