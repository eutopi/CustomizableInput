from flask import Flask, request
from pynput.mouse import Button, Controller
from modules import *
import socket


mouse = Controller()
sliderModule = SliderModule()

app = Flask(__name__)

mousePressed = False

@app.route('/')
def about():
    return 'Load success'

@app.route('/change-slider', methods=['POST'])
def receive_slider_change():
    data = request.get_data(as_text=True)
    data = data.split("###")
    sliderModule.call_function(data[0], int(float(data[1])*100))
    print(f"Received slider change with data: {data[0]} {data[1]}")
    return f"{data[0]} {data[1]}"
    # function = 
    # sliderModule.call_function('Volume (default)', 50)

@app.route('/touch', methods=['POST'])
def receive_touch():
    data = request.get_data(as_text=True)
    print(f"Received touch event with data: {data}")
    # Process the touch event here
    if data == "left down":
        mouse.press(Button.left)
        return 'Left down'
    elif data == "left up":
        mouse.release(Button.left)
        return 'Left up'
    elif data == "right down":
        mouse.press(Button.right)
        return 'Right down'
    elif data == "right up":
        mouse.release(Button.right)
        return 'Right up'
    elif data.startswith("move:"):
        move_instructions = data.split(": ")[1].split(", ")
        x = int(float((move_instructions[0])))
        y = int(float(move_instructions[1]))
        mouse.move(x, y)
        return 'Moved'
    elif data.startswith("scroll:"):
        scroll_instructions = data.split(": ")[1]
        y = int(float(scroll_instructions))
        mouse.scroll(0, y)
        return 'Scrolled'

if __name__ == '__main__':
    ip_address = socket.gethostbyname(socket.gethostname())
    print(f"Flask app running at http://{ip_address}:5000/")
    # mac
    app.run(host='192.168.86.29', port=5000, debug=True, threaded=False)

    # app.run(host='192.168.86.106', port=5000, debug=True, threaded=False)
    # mac at brown
    # app.run(host='10.39.14.93', port=5000, debug=True, threaded=False)
    # windows machine
    # app.run(host='192.168.86.111', port=5000, debug=True, threaded=False)