#!/usr/bin/python3

from pynput import keyboard

running = True

def on_press(key):
    try:
        print('alphanumeric key {0} pressed'.format(
            key.char))
    except AttributeError:
        print('special key {0} pressed'.format(
            key))

def on_release(key):
    print('{0} released'.format(
        key))
    if key == keyboard.Key.esc:
        running = False
        return False

listener = keyboard.Listener(
    on_press=on_press, on_release=on_release)
listener.start()

print("\nPress arrows to adjust, enter or esc to quit\n")

def main():
    while running:
        pass


main()