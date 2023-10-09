import socket
from pynput.mouse import Controller

mouse = Controller()

HOST = '0.0.0.0'
PORT = 12345

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
    server_socket.bind((HOST, PORT))
    server_socket.listen()

    print(f"Server listening on {HOST}:{PORT}")

    conn, addr = server_socket.accept()
    with conn:
        print('Connected by', addr)
        while True:
            data = conn.recv(1024)
            if not data:
                break

            decoded_data = data.decode('utf-8')
            if decoded_data == 'click':
                mouse.click(mouse.position[0], mouse.position[1], 1)