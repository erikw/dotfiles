#!/bin/sh
# Copyright Timo Lindfors 2004
function usage() {
    echo usage: $0 pid
    exit 1
}
TCGETS=0x5401
TCSETS=0x5402
SIZEOF_STRUCT_TERMIOS=60
O_RDWR=2
((FLAGS=O_RDWR))

PID=$1
if [ x`which gdb` == x ]; then
    echo gdb not found in PATH. Please apt-get install gdb
    exit
fi
if [ x$PID == x ]; then
    usage;
fi
if [ x$2 != x ]; then
    usage;
fi
MYPID=$$
MYFD0=`readlink /proc/$MYPID/fd/0`
MYFD1=`readlink /proc/$MYPID/fd/1`
MYFD2=`readlink /proc/$MYPID/fd/2`
EXE=`readlink /proc/$PID/exe`
if [ x$EXE == x ]; then
    echo $0: $PID: no such pid
    exit 1
fi

BATCHFILE=`mktemp /tmp/gdb.XXXXXXXXXXXX`
cat >$BATCHFILE <<EOF
file $EXE
attach $PID
call malloc($SIZEOF_STRUCT_TERMIOS)
call malloc($SIZEOF_STRUCT_TERMIOS)
call malloc($SIZEOF_STRUCT_TERMIOS)
call ioctl(0, $TCGETS, \$1)
call ioctl(1, $TCGETS, \$2)
call ioctl(2, $TCGETS, \$3)
call close(0)
call close(1)
call close(2)
call open("$MYFD0", $FLAGS)
call open("$MYFD1", $FLAGS)
call open("$MYFD2", $FLAGS)
call ioctl(0, $TCSETS, \$1)
call ioctl(1, $TCSETS, \$2)
call ioctl(2, $TCSETS, \$3)
call free(\$1)
call free(\$2)
call free(\$3)
detach
EOF
gdb -batch -x $BATCHFILE >/dev/null 2>&1 </dev/null
rm $BATCHFILE

cat <<EOF
Process $PID should now be talking to this pty. Refresh the screen
(e.g. CTRL+L) and have fun!
EOF

exec tail -f --pid=$PID /proc/$PID/stat
