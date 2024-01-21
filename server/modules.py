import subprocess
import platform

class SliderModule:

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
        try:
            # Check the platform to determine the appropriate command
            if platform.system() == 'Darwin':  # macOS
                subprocess.run(['osascript', '-e', f'set volume output volume {volume}'])
            elif platform.system() == 'Windows':
                subprocess.run(['nircmd.exe', 'setsysvolume', str(volume)])
            elif platform.system() == 'Linux':
                subprocess.run(['amixer', '-D', 'pulse', 'sset', 'Master', f'{volume}%'])
        except Exception as e:
            print(f"Error setting volume: {e}")

my_instance = SliderModule()
result = my_instance.call_function('Volume (default)', 50)
