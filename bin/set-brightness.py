#!/usr/bin/env python3
import datetime
import json
import os
import subprocess

import requests

class Display:
    def __init__(self, name, gain_min, gain_max):
        self.name = name
        self.gain_min = gain_min
        self.gain_max = gain_max

displays = [
    Display("LG HDR 4K", 20, 80),
    Display("PHL 246E7", 0, 100)
]

# darkest time
time1_start = datetime.time(4, 0)
time1_end = datetime.time(11, 0)
# brightest time
time2_start = datetime.time(16, 0)
time2_end = datetime.time(23, 59)
# darkest time

time_light_theme_start = datetime.time(7, 0)
time_light_theme_end = datetime.time(20, 0)

discord_token = os.environ.get("DISCORD_TOKEN")
theme_state_file = "/tmp/set-brightness-theme"

def map_range(x: float, in_min: float, in_max: float, out_min: float, out_max: float):
    """Map a value from one range to another.
    """
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

def clamp(x: int, min_v: int, max_v: int):
    """Clamp a value between two values.
    """
    return max(min(x, max_v), min_v)


def memorized_ddcutil(model: str, code: str, value_int: int):
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

    result = subprocess.run(["ddcutil", "setvcp", "--model", model, code, value])
    if result.returncode != 0:
        raise Exception(f"failed to set {key}={value}")

    memorized_values[key] = value

    print(f"update {key}={value}")
    with open(state_file, 'w') as file:
        json.dump(memorized_values, file)

def set_display_brightness(display: Display, rate: float):
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
    memorized_ddcutil(display.name, "0x16", gain)
    memorized_ddcutil(display.name, "0x18", gain)
    memorized_ddcutil(display.name, "0x1a", gain)
    memorized_ddcutil(display.name, "0x10", bright)

def set_displays_brightness(now: datetime.datetime):
    """Set the brightness of screens.
    """

    today = now.date()

    t1_st = datetime.datetime.combine(today, time1_start)
    t1_ed = datetime.datetime.combine(today, time1_end)
    t1_du = t1_ed - t1_st

    t2_st = datetime.datetime.combine(today, time2_start)
    t2_ed = datetime.datetime.combine(today, time2_end)
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
            for _, display in enumerate(displays):
                set_display_brightness(display, rate)
            break
        except Exception as e:
            print(e)
            last_exception = e

    if last_exception is not None:
        raise last_exception

def set_discord_theme(theme: str, payload: str):
    """Set the theme of Discord.
    """

    state = ""
    if os.path.isfile(theme_state_file):
        with open(theme_state_file, 'r') as file:
            try:
                state = file.read()
            except json.JSONDecodeError:
                pass

    if theme in state:
        print(f"already {theme} theme")
        return

    discord_headers = {
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.7,ja;q=0.3',
        'Accept-Encoding': 'gzip, deflate, br',
        'Content-Type': 'application/json',
        'Authorization': discord_token,
        'X-Discord-Locale': 'en-US',
        'X-Discord-Timezone': 'Asia/Tokyo'
    }
    result = requests.patch(
        'https://discord.com/api/v9/users/@me/settings-proto/1',
        headers=discord_headers, data=payload)
    if result.status_code != 200:
        raise Exception(f"failed to set Discord {theme} theme: {result.text}")

    with open(theme_state_file, 'w') as file:
        file.write(theme)

def set_theme(now: datetime.time):
    if time_light_theme_start <= now < time_light_theme_end:
        set_discord_theme("light", '{"settings":"agYIAhABGgA="}')
    else:
        set_discord_theme("dark", '{"settings":"agYIARABGgA="}')

now = datetime.datetime.now()
set_displays_brightness(now)
set_theme(now.time())
