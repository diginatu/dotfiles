#!/usr/bin/env python3
import subprocess, os, json, datetime, requests

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
time1_start = 4 * 60
time1_end = 11 * 60
# brightest time
time2_start = 16 * 60
time2_end = 23 * 60 + 59
# darkest time

time_light_theme_start = 7 * 60
time_light_theme_end = 20 * 60

discord_token = "YOUR_DISCORD_TOKEN"
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
            try:
                memorized_values = json.load(file)
            except json.JSONDecodeError:
                pass

        if key in memorized_values and memorized_values[key] == value:
            print(f"already {key}={value}")
            return

    result = subprocess.run(["ddcutil", "setvcp", "--model", model, code, value])
    if result.returncode != 0:
        print(f"failed to set {key}={value}")
        return

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

def set_displays_brightness(current_time: datetime.datetime):
    """Set the brightness of screens.
    """

    now = current_time.hour * 60 + current_time.minute

    time1_range = time1_end - time1_start
    time2_range = time2_end - time2_start

    # Calculate the rate of brightness change
    rate = 0.0
    if time1_start <= now < time1_end:
        rate = (now - time1_start) / time1_range
    elif time1_end <= now < time2_start:
        rate = 1.0
    elif time2_start <= now < time2_end:
        rate = 1 - (now - time2_start) / time2_range
    else:
        rate = 0.0

    # Loop through displays and set brightness
    for _, display in enumerate(displays):
        set_display_brightness(display, rate)

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
    requests.patch(
        'https://discord.com/api/v9/users/@me/settings-proto/1',
        headers=discord_headers, data=payload)

    with open(theme_state_file, 'w') as file:
        file.write(theme)

def set_theme(current_time: datetime.datetime):
    now = current_time.hour

    if time_light_theme_start <= now < time_light_theme_end:
        set_discord_theme("light", '{"settings":"agoIAhABGgQSAggC"}')
    else:
        set_discord_theme("dark", '{"settings":"agoIARABGgQSAggJ"}')

current_time = datetime.datetime.now()
set_displays_brightness(current_time)
set_theme(current_time)
