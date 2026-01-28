import socket

UDP_IP = "192.168.1.165"
UDP_PORT = 2390

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.settimeout(2)

# Send a message
message = "Hello from Mac!"
sock.sendto(message.encode(), (UDP_IP, UDP_PORT))

# Listen for response
try:
    data, _ = sock.recvfrom(1024)
    print("Arduino replied:", data.decode())
except socket.timeout:
    print("No response received.")
