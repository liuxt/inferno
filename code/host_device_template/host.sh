#!/dis/sh -n

load std mpexpr file2chan

host = $*
sharedPath = /n/client/tmp/sharedPool
mode = ''
answer = 0
hostLogPath = /pool/host.log

upper = 150
lower = 10

subfn cannotWrite {
    if {! ~ $mode ''} {
	   result = 1;
       } {
	   result = 0;
       }
}

file2chan /tmp/sharedPool {
    if {~ ${rget offset} 0} {
	   if {~ $mode 'get'} {
		  if {~ ${expr $lower $upper '>'} 1} {
			 while {! ~ ${rget offset} 0} {}
			       echo done | putrdata
		     } {
			 while {! ~ ${rget offset} 0} {}
			       echo $lower | putrdata
			       lower = ${expr $lower 1 '+'}
		     }
		     mode = ''
	      }
       } {
	   rread '';
       }
} {
    if {~ ${cannotWrite} 1} {
       } {
	           (client_pid mode data) = `{fetchwdata}
        if {~ $mode 'put'} {
            answer = ${expr $answer $data '+'}
            echo from $client_pid current answer is $answer >> $hostLogPath
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

fn readyHost {
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/device.sh $sharedPath&
    }
}

checkHost
readyHost
