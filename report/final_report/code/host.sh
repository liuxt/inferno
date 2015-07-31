#!/dis/sh -n

load std mpexpr file2chan

host = $*
sharedPath = /n/client/tmp/sharedPool
answer = 0
masterLogPath = /pool/master.log

upper = 100
lower = 23
lock = 0

readmodes = get

subfn cannotWrite {
    result = 0
    if {~ $lock 1} {result = 1}
    for readmode in $readmodes {
        if {~ $readmode $mode} {result = 1}
    }
}

file2chan /tmp/sharedPool {
    while {~ $lock 1} {}
    lock = 1
    if {~ $mode 'get'} {
        if {~ ${expr $lower $upper '>'} 1} {
	    echo done | putrdata
	} {
            echo $lower | putrdata
   	    lower = ${expr $lower 1 '+'}
	}
    }
    mode = ''
    lock = 0
} {
    if {~ ${cannotWrite} 1} {} {
        lock = 1
        (client_pid mode writeData) = `{fetchwdata}`
        if {~ $mode 'put'} {
            answer = ${expr $answer $writeData '+'}
            echo from $client_pid current answer is $answer >> $masterLogPath
        }
	touch /pool/$client_pid
        lock = 0
    }
}

fn checkHost {
    if {~ $#host 0} {
        echo please give me the hostname >> $masterLogPath
        raise args
    }
}

fn readyHost {
    for hostname in $host {
        cpu $hostname sh /n/client/parallel/worker.sh $sharedPath&
    }
}

checkHost
readyHost

