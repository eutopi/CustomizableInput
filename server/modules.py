import subprocess
import platform
from ctypes import cast, POINTER
from comtypes import CLSCTX_ALL
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
import pynput

keyboard_controller = pynput.keyboard.Controller()


class SliderModule:
    devices = AudioUtilities.GetSpeakers()
    interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
    volume_object = cast(interface, POINTER(IAudioEndpointVolume))

    def __init__(self):
        self.function_dict = {
            "Volume (default)": self.set_volume,
        }

    def register_function(self, name, func):
        self.function_dict[name] = func

    def call_function(self, name, *args, **kwargs):
        # Call a registered function by name with optional arguments
        if name in self.function_dict:
            return self.function_dict[name](*args, **kwargs)
        else:
            print(f"Function '{name}' not found.")

    def set_volume(self, volume):
        print(volume)
        try:
            # Check the platform to determine the appropriate command
            if platform.system() == 'Darwin':  # macOS
                subprocess.run(
                    ['osascript', '-e', f'set volume output volume {int(volume*100)}'])
            elif platform.system() == 'Windows':
                self.volume_object.SetMasterVolumeLevelScalar(volume, None)
            elif platform.system() == 'Linux':
                subprocess.run(
                    ['amixer', '-D', 'pulse', 'sset', 'Master', f'{volume}%'])
        except Exception as e:
            print(f"Error setting volume: {e}")


class ButtonModule:

    def __init__(self):
        self.function_dict = {
            "Copy": self.press_copy,
            "Paste": self.press_paste,
            "Auto-indent (VSCode)": self.press_auto_indent_vscode
        }

    def register_function(self, name, func):
        self.function_dict[name] = func

    def call_function(self, name, *args, **kwargs):
        # Call a registered function by name with optional arguments
        if name in self.function_dict:
            return self.function_dict[name](*args, **kwargs)
        else:
            print(f"Function '{name}' not found.")

    def press_copy(self):
        keyboard_controller.press(pynput.keyboard.Key.ctrl_l)
        keyboard_controller.press('c')
        keyboard_controller.release('c')
        keyboard_controller.release(pynput.keyboard.Key.ctrl_l)

    def press_paste(self):
        keyboard_controller.press(pynput.keyboard.Key.ctrl_l)
        keyboard_controller.press('v')
        keyboard_controller.release('v')
        keyboard_controller.release(pynput.keyboard.Key.ctrl_l)

    def press_auto_indent_vscode(self):
        if platform.system() == 'Darwin' or platform.system() == 'Windows':  # macOS or Windows
            keyboard_controller.press(pynput.keyboard.Key.shift)
            keyboard_controller.press(pynput.keyboard.Key.option)
            keyboard_controller.press('f')
            keyboard_controller.release('f')
            keyboard_controller.release(pynput.keyboard.Key.alt_l)
            keyboard_controller.release(pynput.keyboard.Key.shift)
        elif platform.system() == 'Linux':
            keyboard_controller.press(pynput.keyboard.Key.ctrl)
            keyboard_controller.press(pynput.keyboard.Key.shift)
            keyboard_controller.press('i')
            keyboard_controller.release('i')
            keyboard_controller.release(pynput.keyboard.Key.shift)
            keyboard_controller.release(pynput.keyboard.Key.ctrl)

    def generate_keypress_function(self, pressed_list):
        def keypress_function():
            for key_event in pressed_list:
                key, action = key_event
                if action == 'down':
                    keyboard_controller.press(key)
                elif action == 'up':
                    keyboard_controller.release(key)

        return keypress_function


# my_instance = SliderModule()
# result = my_instance.call_function('Volume (default)', 0.6)

# my_instance = ButtonModule()
# my_instance.generate_keypress_function([(Key.ctrl_l, 'down'), ('c', 'down'), ('c', 'up'), (Key.ctrl_l, 'up')])
