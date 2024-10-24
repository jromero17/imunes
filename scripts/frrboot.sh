#!/bin/sh

zebra -dP0

for f in rip ripng ospf ospf6; do
    grep -q "router $f\$" $1 && ${f}d -dP0
done

for f in bgp isis; do
    grep -q "router $f .*\$" $1 && ${f}d -dP0
done

sed -i '' '/Disabling MPLS support/d' /terr.log

vtysh << __END__
conf term
allow-reserved-ranges
`cat $1`
__END__

/sbin/ifconfig lo0 127.0.0.1
