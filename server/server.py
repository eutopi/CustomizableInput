from flask import Flask, request
from pynput.mouse import Button, Controller

mouse = Controller()

app = Flask(__name__)

mousePressed = False

@app.route('/')
def about():
    return 'Load success'

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
    # mac
    app.run(host='192.168.86.106', port=5000, debug=True, threaded=False)
    # mac at brown
    # app.run(host='10.39.14.93', port=5000, debug=True, threaded=False)
    # windows machine
    # app.run(host='192.168.86.111', port=5000, debug=True, threaded=False)