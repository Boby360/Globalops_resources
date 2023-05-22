#!/usr/bin/env python

import socket
import threading
import time

gamename = "globalops"
port = 28672
target_port = 27900

target_addresses = [
    "master.333networks.com",
    "master.newbiesplayground.net",
    "master.errorist.eu",
    "master-uk.unrealarchive.org",
    "master-de.unrealarchive.org",
    "gsm.qtracker.com",
    "master.qtracker.com",
    "master2.qtracker.com",
    "master.openspy.net"
]

# create UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setblocking(0)

# send heartbeat to each target address
def send_heartbeat(address):
    message = "\\heartbeat\\{}\\gamename\\{}".format(port, gamename)
    try:
        sock.sendto(message.encode(), (address, target_port))
    except socket.error:
        pass

# loop for sending heartbeats
while True:
    for address in target_addresses:
        send_heartbeat(address)
        time.sleep(5)
    time.sleep(50)
