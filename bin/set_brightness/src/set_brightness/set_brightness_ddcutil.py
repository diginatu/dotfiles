#!/usr/bin/env python3
import datetime

from . import (
    Color,
    DdcciDdcutil,
    DiscordThemeManager,
    Display,
    DisplayBrightnessManager,
)

now = datetime.datetime.now()

with open("/tmp/set-brightness-ddcutil-mem.json", 'a+t') as f:
    display_brightness_manager = DisplayBrightnessManager(
        time1_start=datetime.time(5, 0), time1_end=datetime.time(9, 0),
        time2_start=datetime.time(16, 0), time2_end=datetime.time(0, 0),
        night_color_start=datetime.time(22, 0), night_color_end=datetime.time(5, 0),
        displays=[
            Display("LG HDR 4K", contrast_min=7, contrast_max=70, night_color=Color(100, 30, 0)),
            Display("PHL 246E7", contrast_min=0, contrast_max=90, night_color=Color(50, 1, 0)),
            Display("Display", contrast_min=0, contrast_max=50, night_color=Color(29, 18, 11)),
        ],
         ddcci=DdcciDdcutil(), state_io=f)
    try:
        display_brightness_manager.set_displays_brightness(now)
    except Exception as e:
        # Do not raise exception for display brightness
        print(e)

discord_theme_manager = DiscordThemeManager(
        time_light_theme_start=datetime.time(7, 0),
        time_light_theme_end=datetime.time(20, 0))
discord_theme_manager.set_theme(now.time())
