#!/dis/sh -n

load std file2chan
load std mpexpr

subfn funct {
    result = ${expr $1 $2 +}
}

input_list = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32


ORIGINAL_LIST = $input_list
ORIGINAL_LIST_LENGTH = $#ORIGINAL_LIST
DEVICE_IP = `{cat device_ip}
LIST_NUMBER = $#DEVICE_IP
TEMP_Q = ${expr $ORIGINAL_LIST_LENGTH $LIST_NUMBER '/'}
TEMP_R = ${expr $ORIGINAL_LIST_LENGTH $LIST_NUMBER '%'}
if {~ ${expr $TEMP_R} 0} {
        for i in ${expr 1 $LIST_NUMBER seq} {
                LIST_LENGTH = ($LIST_LENGTH $TEMP_Q)
        }
} {
        for i in ${expr 1 $TEMP_R seq} {
                LIST_LENGTH = ($LIST_LENGTH ${expr $TEMP_Q 1 '+'})
        }
        for i in ${expr ${expr $TEMP_R 1 '+'} $LIST_NUMBER seq} {
                LIST_LENGTH = ($LIST_LENGTH $TEMP_Q)
        }
}

(LENGTH0 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH0 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST0_0 = ($LIST0_0 $FIRST)
}

(LENGTH1 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH1 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST0_1 = ($LIST0_1 $FIRST)
}

(LENGTH2 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH2 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST0_2 = ($LIST0_2 $FIRST)
}

host = `{cat device_ip}
mode0_0 = ''
mode0_1 = ''
mode0_2 = ''
hostLogPath = /pool/host.log

subfn cannotWrite0_0 {
    if {! ~ $mode0_0 ''} {
        result = 1;
     } {
        result = 0;
    }
}
subfn cannotWrite0_1 {
    if {! ~ $mode0_1 ''} {
        result = 1;
     } {
        result = 0;
    }
}
subfn cannotWrite0_2 {
    if {! ~ $mode0_2 ''} {
        result = 1;
     } {
        result = 0;
    }
}

file2chan /tmp/sharedPool0_0 {
    if {~ ${rget offset} 0} {
         if {~ $mode0_0 'get'} {
              if {~ $#LIST0_0 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork0 = `{ls /pool/*.working0}
                     if {~ $#leftwork0 0} {
                            touch /pool/finish0
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST0 LIST0_0) = $LIST0_0
                           echo $FIRST0 | putrdata
                           touch /pool/$client_pid0.working0
              }
             mode0_0 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite0_0} 1} {
    } {
        (client_pid0 mode0_0 ANSWER0) = `{fetchwdata}
        if {~ $mode0_0 'put'} {
             echo from $client_pid0 current answer is $ANSWER0 >> $hostLogPath
             echo $ANSWER0 > /pool/RESULT_FILE0_0
             rm /pool/$client_pid0.working0
             mode0_0 = ''
        }
        touch /pool/$client_pid0
    }
}

file2chan /tmp/sharedPool0_1 {
    if {~ ${rget offset} 0} {
         if {~ $mode0_1 'get'} {
              if {~ $#LIST0_1 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork1 = `{ls /pool/*.working1}
                     if {~ $#leftwork1 0} {
                            touch /pool/finish1
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST1 LIST0_1) = $LIST0_1
                           echo $FIRST1 | putrdata
                           touch /pool/$client_pid1.working1
              }
             mode0_1 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite0_1} 1} {
    } {
        (client_pid1 mode0_1 ANSWER1) = `{fetchwdata}
        if {~ $mode0_1 'put'} {
             echo from $client_pid1 current answer is $ANSWER1 >> $hostLogPath
             echo $ANSWER1 > /pool/RESULT_FILE0_1
             rm /pool/$client_pid1.working1
             mode0_1 = ''
        }
        touch /pool/$client_pid1
    }
}

file2chan /tmp/sharedPool0_2 {
    if {~ ${rget offset} 0} {
         if {~ $mode0_2 'get'} {
              if {~ $#LIST0_2 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork2 = `{ls /pool/*.working2}
                     if {~ $#leftwork2 0} {
                            touch /pool/finish2
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST2 LIST0_2) = $LIST0_2
                           echo $FIRST2 | putrdata
                           touch /pool/$client_pid2.working2
              }
             mode0_2 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite0_2} 1} {
    } {
        (client_pid2 mode0_2 ANSWER2) = `{fetchwdata}
        if {~ $mode0_2 'put'} {
             echo from $client_pid2 current answer is $ANSWER2 >> $hostLogPath
             echo $ANSWER2 > /pool/RESULT_FILE0_2
             rm /pool/$client_pid2.working2
             mode0_2 = ''
        }
        touch /pool/$client_pid2
    }
}

fn checkHost {
    if {~ $#host 0} {
        echo please give me the hostname >> $hostLogPath
        raise args
    }
}
fn readyHost{
    count = 0
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/device0.sh /n/client/tmp/sharedPool0_^$count&
        count = ${expr $count 1 '+'}
    }
}

checkHost
readyHost

while {! ftest -e /pool/finish0}{
}

while {! ftest -e /pool/finish1}{
}

while {! ftest -e /pool/finish2}{
}

while {ftest -e /pool/finish0} {
    rm /pool/finish0
}

while {ftest -e /pool/finish1} {
    rm /pool/finish1
}

while {ftest -e /pool/finish2} {
    rm /pool/finish2
}


ACC = `{cat /pool/RESULT_FILE0_0}

RESULT_NUMBER = ${expr $LIST_NUMBER 1 '-'}

if {~ $RESULT_NUMBER 0} {} {
    for i in ${expr 1 $RESULT_NUMBER seq} {
	    ADDER = `{cat /pool/RESULT_FILE0_$i}
	    ACC = ${funct $ACC $ADDER}
    }
}

acc1 = $ACC

subfn mul {
	result = ${expr $1 $2 '*'}
}


ORIGINAL_LIST = $input_list
ORIGINAL_LIST_LENGTH = $#ORIGINAL_LIST
DEVICE_IP = `{cat device_ip}
LIST_NUMBER = $#DEVICE_IP
TEMP_Q = ${expr $ORIGINAL_LIST_LENGTH $LIST_NUMBER '/'}
TEMP_R = ${expr $ORIGINAL_LIST_LENGTH $LIST_NUMBER '%'}
if {~ ${expr $TEMP_R} 0} {
        for i in ${expr 1 $LIST_NUMBER seq} {
                LIST_LENGTH = ($LIST_LENGTH $TEMP_Q)
        }
} {
        for i in ${expr 1 $TEMP_R seq} {
                LIST_LENGTH = ($LIST_LENGTH ${expr $TEMP_Q 1 '+'})
        }
        for i in ${expr ${expr $TEMP_R 1 '+'} $LIST_NUMBER seq} {
                LIST_LENGTH = ($LIST_LENGTH $TEMP_Q)
        }
}

(LENGTH0 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH0 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST1_0 = ($LIST1_0 $FIRST)
}

(LENGTH1 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH1 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST1_1 = ($LIST1_1 $FIRST)
}

(LENGTH2 LIST_LENGTH) = $LIST_LENGTH
for i in ${expr 1 $LENGTH2 seq} {
        (FIRST ORIGINAL_LIST) = $ORIGINAL_LIST
        LIST1_2 = ($LIST1_2 $FIRST)
}

host = `{cat device_ip}
mode1_0 = ''
mode1_1 = ''
mode1_2 = ''
hostLogPath = /pool/host.log

subfn cannotWrite1_0 {
    if {! ~ $mode1_0 ''} {
        result = 1;
     } {
        result = 0;
    }
}
subfn cannotWrite1_1 {
    if {! ~ $mode1_1 ''} {
        result = 1;
     } {
        result = 0;
    }
}
subfn cannotWrite1_2 {
    if {! ~ $mode1_2 ''} {
        result = 1;
     } {
        result = 0;
    }
}

file2chan /tmp/sharedPool1_0 {
    if {~ ${rget offset} 0} {
         if {~ $mode1_0 'get'} {
              if {~ $#LIST1_0 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork0 = `{ls /pool/*.working0}
                     if {~ $#leftwork0 0} {
                            touch /pool/finish0
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST0 LIST1_0) = $LIST1_0
                           echo $FIRST0 | putrdata
                           touch /pool/$client_pid0.working0
              }
             mode1_0 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite1_0} 1} {
    } {
        (client_pid0 mode1_0 ANSWER0) = `{fetchwdata}
        if {~ $mode1_0 'put'} {
             echo from $client_pid0 current answer is $ANSWER0 >> $hostLogPath
             echo $ANSWER0 > /pool/RESULT_FILE1_0
             rm /pool/$client_pid0.working0
             mode1_0 = ''
        }
        touch /pool/$client_pid0
    }
}

file2chan /tmp/sharedPool1_1 {
    if {~ ${rget offset} 0} {
         if {~ $mode1_1 'get'} {
              if {~ $#LIST1_1 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork1 = `{ls /pool/*.working1}
                     if {~ $#leftwork1 0} {
                            touch /pool/finish1
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST1 LIST1_1) = $LIST1_1
                           echo $FIRST1 | putrdata
                           touch /pool/$client_pid1.working1
              }
             mode1_1 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite1_1} 1} {
    } {
        (client_pid1 mode1_1 ANSWER1) = `{fetchwdata}
        if {~ $mode1_1 'put'} {
             echo from $client_pid1 current answer is $ANSWER1 >> $hostLogPath
             echo $ANSWER1 > /pool/RESULT_FILE1_1
             rm /pool/$client_pid1.working1
             mode1_1 = ''
        }
        touch /pool/$client_pid1
    }
}

file2chan /tmp/sharedPool1_2 {
    if {~ ${rget offset} 0} {
         if {~ $mode1_2 'get'} {
              if {~ $#LIST1_2 0} {
                     while {! ~ ${rget offset} 0} {}
                     echo done | putrdata
                     leftwork2 = `{ls /pool/*.working2}
                     if {~ $#leftwork2 0} {
                            touch /pool/finish2
                     }
              } { 
                     while {! ~ ${rget offset} 0} {}
                           (FIRST2 LIST1_2) = $LIST1_2
                           echo $FIRST2 | putrdata
                           touch /pool/$client_pid2.working2
              }
             mode1_2 = '' 
         }
    } {
      rread '';
    }
} {
    if {~ ${cannotWrite1_2} 1} {
    } {
        (client_pid2 mode1_2 ANSWER2) = `{fetchwdata}
        if {~ $mode1_2 'put'} {
             echo from $client_pid2 current answer is $ANSWER2 >> $hostLogPath
             echo $ANSWER2 > /pool/RESULT_FILE1_2
             rm /pool/$client_pid2.working2
             mode1_2 = ''
        }
        touch /pool/$client_pid2
    }
}

fn checkHost {
    if {~ $#host 0} {
        echo please give me the hostname >> $hostLogPath
        raise args
    }
}
fn readyHost{
    count = 0
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/device1.sh /n/client/tmp/sharedPool1_^$count&
        count = ${expr $count 1 '+'}
    }
}

checkHost
readyHost

while {! ftest -e /pool/finish0}{
}

while {! ftest -e /pool/finish1}{
}

while {! ftest -e /pool/finish2}{
}

while {ftest -e /pool/finish0} {
    rm /pool/finish0
}

while {ftest -e /pool/finish1} {
    rm /pool/finish1
}

while {ftest -e /pool/finish2} {
    rm /pool/finish2
}


ACC = `{cat /pool/RESULT_FILE1_0}

RESULT_NUMBER = ${expr $LIST_NUMBER 1 '-'}

if {~ $RESULT_NUMBER 0} {} {
    for i in ${expr 1 $RESULT_NUMBER seq} {
	    ADDER = `{cat /pool/RESULT_FILE1_$i}
	    ACC = ${mul $ACC $ADDER}
    }
}

acc2 = $ACC
