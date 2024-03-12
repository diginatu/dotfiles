import datetime
import json
import os

import requests

class DiscordThemeManager:
    def __init__(self, time_light_theme_start: datetime.time, time_light_theme_end: datetime.time):
        self.time_light_theme_start = time_light_theme_start
        self.time_light_theme_end = time_light_theme_end
        discord_token = os.environ.get("DISCORD_TOKEN")
        if discord_token is None:
            raise Exception("DISCORD_TOKEN is not set")
        self.theme_state_file = "/tmp/set-brightness-theme"

    def set_discord_theme(self, theme: str, payload: str):
        """Set the theme of Discord.
        """
        state = ""
        if os.path.isfile(self.theme_state_file):
            with open(self.theme_state_file, 'r') as file:
                try:
                    state = file.read()
                except json.JSONDecodeError:
                    pass

        if theme in state:
            print(f"already {theme} theme")
            return

        discord_token = os.environ.get("DISCORD_TOKEN")
        if discord_token is None:
            raise Exception("DISCORD_TOKEN is not set")

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

        with open(self.theme_state_file, 'w') as file:
            file.write(theme)

    def set_theme(self, now: datetime.time):
        if self.time_light_theme_start <= now < self.time_light_theme_end:
            self.set_discord_theme("light", '{"settings":"agYIAhABGgA="}')
        else:
            self.set_discord_theme("dark", '{"settings":"agYIARABGgA="}')
