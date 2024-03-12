import datetime
import json
import os
import time

from .ddcci_interface import DdcciInterface
from .display import Display

def map_range(x: float, in_min: float, in_max: float, out_min: float, out_max: float):
    """Map a value from one range to another.
    """
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

def clamp(x: int, min_v: int, max_v: int):
    """Clamp a value between two values.
    """
    return max(min(x, max_v), min_v)

class DisplayBrightnessManager:
# darkest time
# time1
# brightest time
# time2
# darkest time
    def __init__(self, time1_start: datetime.time, time1_end: datetime.time,
                 time2_start: datetime.time, time2_end: datetime.time,
                 displays: list[Display], ddcci: DdcciInterface):
        self.time1_start = time1_start
        self.time1_end = time1_end
        self.time2_start = time2_start
        self.time2_end = time2_end
        self.displays = displays
        self.ddcci = ddcci

    def memorized_ddcutil(self, model: str, code: str, value_int: int):
        """Set a value using ddcutil, but only if it has changed.
        """
        value = str(value_int)

        state_file = "/tmp/set-brightness-ddcutil-mem.json"
        key = f"{model}:{code}"
        memorized_values = {}

        if os.path.isfile(state_file):
            with open(state_file, 'r') as file:
                memorized_values = json.load(file)

            if key in memorized_values and memorized_values[key] == value:
                print(f"already {key}={value}")
                return

        self.ddcci.setVcp(model, code, value)
        memorized_values[key] = value

        print(f"update {key}={value}")
        with open(state_file, 'w') as file:
            json.dump(memorized_values, file)


    def set_display_brightness(self, display: Display, rate: float):
        """Set the brightness of the screen.
        """
        bright = clamp(int(map_range(rate, 0.2, 0.8, 0, 100)), 0, 100)

        gain = 0
        if rate < 0.2:
            gain = int(map_range(rate, 0.0, 0.2, display.gain_min, 50))
        elif rate < 0.8:
            gain = 50
        else:
            gain = int(map_range(rate, 0.8, 1.0, 50, display.gain_max))

        print(f"{display.name}: brightness {bright}, gain {gain}")
        self.memorized_ddcutil(display.name, "0x16", gain)
        self.memorized_ddcutil(display.name, "0x18", gain)
        self.memorized_ddcutil(display.name, "0x1a", gain)
        self.memorized_ddcutil(display.name, "0x10", bright)

    def set_displays_brightness(self, now: datetime.datetime):
        """Set the brightness of screens.
        """

        today = now.date()

        t1_st = datetime.datetime.combine(today, self.time1_start)
        t1_ed = datetime.datetime.combine(today, self.time1_end)
        t1_du = t1_ed - t1_st

        t2_st = datetime.datetime.combine(today, self.time2_start)
        t2_ed = datetime.datetime.combine(today, self.time2_end)
        t2_du = t2_ed - t2_st

        # Calculate the rate of brightness change
        rate = 0.0
        if t1_st <= now < t1_ed:
            rate = (now - t1_st) / t1_du
        elif t1_ed <= now < t2_st:
            rate = 1.0
        elif t2_st <= now < t2_ed:
            rate = 1 - (now - t2_st) / t2_du
        else:
            rate = 0.0

        last_exception = None
        # Retry
        for _ in range(3):
            try:
                # Loop through displays and set brightness
                for _, display in enumerate(self.displays):
                    self.set_display_brightness(display, rate)
                break
            except Exception as e:
                print(e)
                last_exception = e
                time.sleep(1)

        if last_exception is not None:
            raise last_exception
