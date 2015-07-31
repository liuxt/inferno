#!/dis/sh -n

load std file2chan

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


host = $*
sharedPath = /n/client/tmp/sharedPool0
mode = ''
hostLogPath = /pool/host.log

ARRAY = $array1
LENGTH = 0
LIST = ''
RESULT_LIST = ''

subfn cannotWrite {
    if {! ~ $mode ''} {
           result = 1;
       } {
           result = 0;
    }
}

file2chan /tmp/sharedPool0{
    if {~ ${rget offset} 0} {
           if {~ $mode 'get'} {
                  if {~ $#ARRAY 0} {
                         while {! ~ ${rget offset} 0} {}
                         echo done | putrdata
                         echo $LENGTH > /pool/length
                         leftwork = `{ls /pool/*.working}
                         if {~ $#leftwork 0} {
                                touch /pool/finish
                         }
                  } { 
                         while {! ~ ${rget offset} 0} {}
                                   (FIRST ARRAY) = $ARRAY 
                                   PUTDATA = ($LENGTH $FIRST)
                               echo $PUTDATA | putrdata
                               touch /pool/$client_pid.working
                               LENGTH = ${expr $LENGTH 1 '+'} 
                  }
                 mode = '' 
           }
   } {
          rread '';
   }
} {
    if {~ ${cannotWrite} 1} {
       } {
            (client_pid mode ANSWER) = `{fetchwdata}
            if {~ $mode 'put'} {
            LIST = ($LIST $ANSWER)
            echo from $client_pid current answer is $LIST >> $hostLogPath
            echo $LIST > /pool/list
            rm /pool/$client_pid.working
                mode = ''
        }
                touch /pool/$client_pid
    }
}
fn checkHost {
    if {~ $#host 0} {
        echo please give me the hostname >> $hostLogPath
        raise args
    }
}
fn readyHost0 {
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/device0.sh $sharedPath&
    }
}

checkHost
readyHost0

while {! ftest -e /pool/finish} {

}

LIST = `{cat /pool/list}
LENGTH = `{cat /pool/length}

while {ftest -e /pool/finish} {
        rm /pool/finish
}

while {ftest -e /pool/list} {
        rm /pool/list
}

while {ftest -e /pool/length} {
        rm /pool/length
}

for COUNT in ${expr 0 ${expr $LENGTH 1 '-'} seq} {
        tag = 1
        flag = 0
        for ITEM in $LIST {
                if {~ $tag 1} {
                        if {~ $ITEM $COUNT} {
                             flag = 1
                        }
                        tag = 0
                        raise continue
                } {~ $tag 0} {
                        if {~ $flag 1} {
                                RESULT_LIST = ($RESULT_LIST $ITEM)
                                flag = 0
                        }
                        tag = 1
                        raise continue
                }
        }
}

array1 = $RESULT_LIST
tmp = 0
(tmp array1) = $array1

array2 = 1 2 3 4 5 


host = $*
sharedPath = /n/client/tmp/sharedPool1
mode = ''
hostLogPath = /pool/host.log

ARRAY = $array2
LENGTH = 0
LIST = ''
RESULT_LIST = ''

subfn cannotWrite {
    if {! ~ $mode ''} {
           result = 1;
       } {
           result = 0;
    }
}

file2chan /tmp/sharedPool1{
    if {~ ${rget offset} 0} {
           if {~ $mode 'get'} {
                  if {~ $#ARRAY 0} {
                         while {! ~ ${rget offset} 0} {}
                         echo done | putrdata
                         echo $LENGTH > /pool/length
                         leftwork = `{ls /pool/*.working}
                         if {~ $#leftwork 0} {
                                touch /pool/finish
                         }
                  } { 
                         while {! ~ ${rget offset} 0} {}
                                   (FIRST ARRAY) = $ARRAY 
                                   PUTDATA = ($LENGTH $FIRST)
                               echo $PUTDATA | putrdata
                               touch /pool/$client_pid.working
                               LENGTH = ${expr $LENGTH 1 '+'} 
                  }
                 mode = '' 
           }
   } {
          rread '';
   }
} {
    if {~ ${cannotWrite} 1} {
       } {
            (client_pid mode ANSWER) = `{fetchwdata}
            if {~ $mode 'put'} {
            LIST = ($LIST $ANSWER)
            echo from $client_pid current answer is $LIST >> $hostLogPath
            echo $LIST > /pool/list
            rm /pool/$client_pid.working
                mode = ''
        }
                touch /pool/$client_pid
    }
}
fn checkHost {
    if {~ $#host 0} {
        echo please give me the hostname >> $hostLogPath
        raise args
    }
}
fn readyHost1 {
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/device1.sh $sharedPath&
    }
}

checkHost
readyHost1

while {! ftest -e /pool/finish} {

}

LIST = `{cat /pool/list}
LENGTH = `{cat /pool/length}

while {ftest -e /pool/finish} {
        rm /pool/finish
}

while {ftest -e /pool/list} {
        rm /pool/list
}

while {ftest -e /pool/length} {
        rm /pool/length
}

for COUNT in ${expr 0 ${expr $LENGTH 1 '-'} seq} {
        tag = 1
        flag = 0
        for ITEM in $LIST {
                if {~ $tag 1} {
                        if {~ $ITEM $COUNT} {
                             flag = 1
                        }
                        tag = 0
                        raise continue
                } {~ $tag 0} {
                        if {~ $flag 1} {
                                RESULT_LIST = ($RESULT_LIST $ITEM)
                                flag = 0
                        }
                        tag = 1
                        raise continue
                }
        }
}

array2 = $RESULT_LIST
tmp = 0
(tmp array2) = $array2
