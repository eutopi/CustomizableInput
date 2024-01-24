import subprocess
import platform
from ctypes import cast, POINTER
from comtypes import CLSCTX_ALL
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume

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
                subprocess.run(['osascript', '-e', f'set volume output volume {int(volume*100)}'])
            elif platform.system() == 'Windows':
                self.volume_object.SetMasterVolumeLevelScalar(volume, None)
            elif platform.system() == 'Linux':
                subprocess.run(['amixer', '-D', 'pulse', 'sset', 'Master', f'{volume}%'])
        except Exception as e:
            print(f"Error setting volume: {e}")

my_instance = SliderModule()
result = my_instance.call_function('Volume (default)', 0.6)