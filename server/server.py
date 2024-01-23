from flask import Flask, request
from pynput.mouse import Button, Controller
from pynput import keyboard
from modules import *
import socket


mouse = Controller()
sliderModule = SliderModule()
recorded_inputs = []

app = Flask(__name__)
mousePressed = False

def on_press(key):
    global recorded_inputs
    print(key)
    if already_pressed(recorded_inputs, (key, 'down'), (key, 'up')):
        print('already pressed')
        pass
    else:
        print('not already pressed')
        recorded_inputs.append((key, 'down'))

def on_release(key):
    global recorded_inputs
    print(key)
    recorded_inputs.append((key, 'up'))
    if key == keyboard.Key.esc:
        # Stop listener
        print(recorded_inputs)
        return False

listener = keyboard.Listener(
    on_press=on_press,
    on_release=on_release)

@app.route('/')
def about():
    return 'Load success'

@app.route('/start-recording', methods=['POST'])
def start_recording():
    # Collect events until released
    listener.start()

@app.route('/stop-recording', methods=['POST'])
def stop_recording():
    listener.stop()
    print(recorded_inputs)

@app.route('/upload-recording', methods=['POST'])
def upload_recording():
    pass

@app.route('/press-button', methods=['POST'])
def press_button():
    pass

@app.route('/change-slider', methods=['POST'])
def change_slider():
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
    
def already_pressed(l, a, b):
    # Check if b is not in l
    if a not in l:
        return False
    if b not in l:
        # Check if there is only incidence of a in l
        if l.count(a) == len(l):
            return True
        else:
            return False
    else:
        # Check if the most recent incidence of a in l appears after b
        last_index_a = max([i for i, x in enumerate(l) if x == a], default=-1)
        last_index_b = l.index(b) if b in l else -1

        return last_index_a > last_index_b

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