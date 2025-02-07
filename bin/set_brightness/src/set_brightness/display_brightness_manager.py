import datetime
import json
import time
from typing import TextIO

from .color import Color
from .ddcci_interface import DdcciInterface
from .display import Display

def _map_range(x: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
    """Map a value from one range to another.
    """
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

def _clamp(x: int, min_v: int, max_v: int):
    """Clamp a value between two values.
    """
    return max(min(x, max_v), min_v)

def _is_time_between(now: datetime.time, start: datetime.time, end: datetime.time) -> bool:
    """Check if the current time is between two times.
    """
    if start < end:
        return start <= now <= end
    else:
        return start <= now or now <= end

def _delta_time(start: datetime.time, end: datetime.time) -> datetime.timedelta:
    """Calculate the positive difference between two times.
    """
    d = datetime.datetime.combine(datetime.date.today(), end) - datetime.datetime.combine(datetime.date.today(), start)
    return d if d >= datetime.timedelta() else d + datetime.timedelta(days=1)

def _add_time(time: datetime.time, duration: datetime.timedelta) -> datetime.time:
    """Add a duration to a time.
    """
    return (datetime.datetime.combine(datetime.date.today(), time) + duration).time()

class DisplayBrightnessManager:
# darkest time
# time1
# brightest time
# time2
# darkest time
    def __init__(self, time1_start: datetime.time, time1_end: datetime.time,
                 time2_start: datetime.time, time2_end: datetime.time,
                 night_color_start: datetime.time, night_color_end: datetime.time,
                 night_color: Color,
                 displays: list[Display], ddcci: DdcciInterface,
                 state_io: TextIO):
        self.time1_start = time1_start
        self.time1_end = time1_end
        self.time2_start = time2_start
        self.time2_end = time2_end
        self.night_color_start = night_color_start
        self.night_color_end = night_color_end
        self.night_color = night_color
        self.displays = displays
        self.ddcci = ddcci
        self.state_io = state_io

    def __memorized_ddcutil(self, model: str, code: str, value_int: int):
        """Set a value using ddcutil, but only if it has changed.
        """
        value = str(value_int)

        key = f"{model}:{code}"
        memorized_values = {}

        # Read all
        self.state_io.seek(0)
        buf = self.state_io.read()
        if buf:
            memorized_values = json.loads(buf)

        if key in memorized_values and memorized_values[key] == value:
            print(f"already {key}={value}")
            return

        self.ddcci.setVcp(model, code, value)
        memorized_values[key] = value

        print(f"update {key}={value}")
        self.state_io.seek(0)
        json.dump(memorized_values, self.state_io)


    def __set_display_brightness(self, display: Display, bright_rate: float, night_rate: float):
        """Set the brightness of the screen.
        """
        bright = _clamp(int(_map_range(bright_rate, 0.2, 0.8, 0, 100)), 0, 100)

        contrast = 0
        if bright_rate < 0.2:
            contrast = int(_map_range(bright_rate, 0.0, 0.2, display.contrast_min, 50))
        elif bright_rate < 0.8:
            contrast = 50
        else:
            contrast = int(_map_range(bright_rate, 0.8, 1.0, 50, display.contrast_max))

        # Night color
        red_gain = int(_map_range(night_rate, 0.0, 1.0, 50, self.night_color.red))
        green_gain = int(_map_range(night_rate, 0.0, 1.0, 50, self.night_color.green))
        blue_gain = int(_map_range(night_rate, 0.0, 1.0, 50, self.night_color.blue))

        print(f"{display.name}: brightness {bright}, contrast {contrast}, red {red_gain}, green {green_gain}, blue {blue_gain}")
        self.__memorized_ddcutil(display.name, "0x12", contrast)
        self.__memorized_ddcutil(display.name, "0x16", red_gain)
        self.__memorized_ddcutil(display.name, "0x18", green_gain)
        self.__memorized_ddcutil(display.name, "0x1a", blue_gain)
        self.__memorized_ddcutil(display.name, "0x10", bright)

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
        bright_rate = 0.0
        if t1_st <= now < t1_ed:
            bright_rate = (now - t1_st) / t1_du
        elif t1_ed <= now < t2_st:
            bright_rate = 1.0
        elif t2_st <= now < t2_ed:
            bright_rate = 1 - (now - t2_st) / t2_du

        # Calculate the rate of night color
        # For 1 hour gradually change to night color
        night_rate = 0.0
        switch_du = datetime.timedelta(hours=1)
        if _is_time_between(now.time(), self.night_color_start, _add_time(self.night_color_start, switch_du)):
            night_rate = _delta_time(self.night_color_start, now.time()) / switch_du
        elif _is_time_between(now.time(), _add_time(self.night_color_start, switch_du), _add_time(self.night_color_end, -switch_du)):
            night_rate = 1.0
        elif _is_time_between(now.time(), _add_time(self.night_color_end, -switch_du), self.night_color_end):
            night_rate = 1 - _delta_time(now.time(), self.night_color_end) / switch_du

        last_exception = None
        # Retry
        for _ in range(5):
            try:
                # Loop through displays and set brightness
                for _, display in enumerate(self.displays):
                    self.__set_display_brightness(display, bright_rate, night_rate)
                break
            except Exception as e:
                print(e)
                last_exception = e
                time.sleep(1)

        if last_exception is not None:
            raise last_exception
