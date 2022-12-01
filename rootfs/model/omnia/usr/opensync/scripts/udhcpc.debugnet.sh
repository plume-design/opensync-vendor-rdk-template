#!/bin/sh
[ -z "$1" ] && echo "Error: should be run by udhcpc" && exit 1

subnet2prefix()
{
    prefix=0
    for x in $(echo "$1" | tr '.' ' ')
    do
        case "$x" in
            255)
                c=8
                ;;
            254)
                c=7
                ;;
            252)
                c=6
                ;;
            248)
                c=5
                ;;
            240)
                c=4
                ;;
            224)
                c=3
                ;;
            192)
               c=2
               ;;
           128)
               c=1
               ;;
            0)
               c=0
               ;;
            *)
               echo "$interface: Error, Invalid subnet: $1"
               exit 1
        esac
        prefix=$((prefix+c))
    done
    echo "$prefix"
}

log_event()
{
    _event=$1
    shift
    logger -t "udhcpc" "$interface: $_event: $*"
}

setup_interface()
{
    # Calculate the prefix from the subnet, for example 255.255.255.0 -> 24
    _prefix=$(subnet2prefix "${subnet:-255.255.255.0}")
    _addr="$ip/$_prefix"

    log_event "$1" "adding/replacing ipv4 addr $_addr"
    ip addr replace dev "$interface" "$_addr" broadcast "${broadcast:-+}"
}

case "$1" in
        deconfig)
            log_event "$1" "flushing all ipv4 addr"
            ip -4 addr flush dev "$interface"
        ;;
        renew)
            setup_interface "$1"
        ;;
        bound)
            setup_interface "$1"
        ;;
esac

exit 0
