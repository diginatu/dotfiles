import re
import subprocess

from .ddcci_interface import DdcciInterface

class DdcciTwinkleTray(DdcciInterface):

    """TwinkleTray is a windows app Twinkle Tray command implementation of DdcciInterface. """

    @staticmethod
    def _get_mappings_from_display_list(result: bytes) -> dict[str, int]:
        ansi_escape = re.compile(rb'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]|\r')
        ansi = ansi_escape.sub(b'', result).strip()
        monitors = ansi.split(b'\n\n')

        display_mappings = {}

        # Get the monitor name and number
        for monitor in monitors:
            monitor_name = b""
            monitor_num = b""
            for monitor_item in monitor.split(b'\n'):
                monitor_field, monitor_value = monitor_item.split(b": ")
                if monitor_field == b"Name":
                    monitor_name = monitor_value
                elif monitor_field == b"MonitorNum":
                    monitor_num = monitor_value
            if monitor_name and monitor_num:
                display_mappings[monitor_name.decode('utf-8')] = int(monitor_num.decode('utf-8')) + 1
        
        return display_mappings

    def __init__(self):
        result = subprocess.check_output(["Twinkle Tray.exe", "--List"])
        self.display_mappings = self._get_mappings_from_display_list(result)

    def setVcp(self, model: str, code: str, value: str):
        result = subprocess.run(["Twinkle Tray.exe", "--List"])
        if result.returncode != 0:
            raise Exception(f"failed: {result.stderr}")
