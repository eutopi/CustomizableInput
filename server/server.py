from flask import Flask, request
from pynput.mouse import Button, Controller

mouse = Controller()

app = Flask(__name__)

@app.route('/')
def about():
    return 'Load success'

@app.route('/click', methods=['POST'])
def receive_click():
    data = request.get_data(as_text=True)
    print(f"Received click with data: {data}")
    # Process the click here
    if data == "left click":
        mouse.click(Button.left, 1)
    elif data == "right click":
        mouse.click(Button.right, 1)
    elif data.startswith("move:"):
        move_instructions = data.split(": ")[1].split(", ")
        x = float(move_instructions[0])
        y = float(move_instructions[1])
        mouse.move(x, y)

    return 'Click received successfully'

if __name__ == '__main__':
    app.run(host='192.168.86.111', port=5000, debug=True, threaded=False)