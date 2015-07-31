#!/dis/sh -n

load std file2chan
load std mpexpr

subfn funct {
    result = ${expr $1 $2 +}
}

input_list1 = ${expr 1 99 seq}
input_list2 = ${expr 99 1 seq}


host = `{cat device_ip}
sharedPath = /n/client/tmp/sharedPool0_0
mode = ''
hostLogPath = /pool/host.log

ARRAY1 = $input_list1
ARRAY2 = $input_list2
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

file2chan /tmp/sharedPool0_0{
    if {~ ${rget offset} 0} {
           if {~ $mode 'get'} {
                  if {~ $#ARRAY1 0} {
                         while {! ~ ${rget offset} 0} {}
                         echo done | putrdata
                         echo $LENGTH > /pool/length
                         leftwork = `{ls /pool/*.working}
                         if {~ $#leftwork 0} {
                                touch /pool/finish
                         }
                  } { 
                         while {! ~ ${rget offset} 0} {}
                                   (FIRST1 ARRAY1) = $ARRAY1
                                   (FIRST2 ARRAY2) = $ARRAY2
                                   PUTDATA = ($LENGTH $FIRST1 $FIRST2)
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

output_list = $RESULT_LIST
tmp = 0
(tmp output_list) = $output_list

echo $output_list

host = `{cat device_ip}
sharedPath = /n/client/tmp/sharedPool1_0
mode = ''
hostLogPath = /pool/host.log

ARRAY1 = $output_list
ARRAY2 = $output_list
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

file2chan /tmp/sharedPool1_0{
    if {~ ${rget offset} 0} {
           if {~ $mode 'get'} {
                  if {~ $#ARRAY1 0} {
                         while {! ~ ${rget offset} 0} {}
                         echo done | putrdata
                         echo $LENGTH > /pool/length
                         leftwork = `{ls /pool/*.working}
                         if {~ $#leftwork 0} {
                                touch /pool/finish
                         }
                  } { 
                         while {! ~ ${rget offset} 0} {}
                                   (FIRST1 ARRAY1) = $ARRAY1 
                                   (FIRST2 ARRAY2) = $ARRAY2
                                   PUTDATA = ($LENGTH $FIRST1 $FIRST2)
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

output_list = $RESULT_LIST
tmp = 0
(tmp output_list) = $output_list

echo $output_list
