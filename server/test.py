#!/usr/bin/python3

from pynput import keyboard

recorded_inputs = []

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

# Collect events until released
with keyboard.Listener(
        on_press=on_press,
        on_release=on_release, suppress=True) as listener:
    listener.join()

listener.stop()