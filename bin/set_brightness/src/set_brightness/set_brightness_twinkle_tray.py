#!/usr/bin/env python3
import datetime

from . import DdcciTwinkleTray, DiscordThemeManager, Display, DisplayBrightnessManager

now = datetime.datetime.now()

display_brightness_manager = DisplayBrightnessManager(
    time1_start=datetime.time(4, 0), time1_end=datetime.time(11, 0),
    time2_start=datetime.time(16, 0), time2_end=datetime.time(23, 59),
    displays=[Display("LG HDR 4K", 20, 80), Display("PHL 246E7", 0, 100)],
    ddcci=DdcciTwinkleTray())
display_brightness_manager.set_displays_brightness(now)

discord_theme_manager = DiscordThemeManager(
        time_light_theme_start=datetime.time(7, 0),
        time_light_theme_end=datetime.time(20, 0))
discord_theme_manager.set_theme(now.time())
