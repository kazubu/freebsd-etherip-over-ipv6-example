#!/bin/sh

# IP network side 
ifconfig em1 up
ifconfig em1 inet6 2001:db8::1/64
ifconfig em1 -rxcsum -txcsum -lro -rxcsum6 -txcsum6 up 

# Ethernet side
ifconfig em2 -rxcsum -txcsum -lro -rxcsum6 -txcsum6 -vlanhwtag -vlanhwcsum -vlanhwfilter -vlantso up

## Create VLAN logical interface
ifconfig em2.10 plumb
ifconfig em2.10 mtu 1500
ifconfig em2.10 up

# Create tunnel interface
ifconfig gif0 create
ifconfig gif0 inet6 tunnel 2001:db8::1 2001:db8::2
ifconfig gif0 mtu 1500
ifconfig gif0 link0
ifconfig gif0 up

# Create bridge between VLAN logical interface and tunnel interface
ifconfig bridge0 create
ifconfig bridge0 mtu 1500
ifconfig bridge0 addm gif0
ifconfig bridge0 addm em2.10
ifconfig bridge0 up
