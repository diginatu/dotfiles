import re
import subprocess

from .ddcci_interface import DdcciInterface

class DdcciTwinkleTray(DdcciInterface):

    _display_mappings = {}

    """TwinkleTray is a windows app Twinkle Tray command implementation of DdcciInterface. """

    @staticmethod
    def _get_mappings_from_display_list(list_stdout: bytes) -> dict[str, int]:
        ansi_escape = re.compile(rb'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]|\r')
        ansi = ansi_escape.sub(b'', list_stdout).strip()
        if not ansi:
            return {}
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

    def __init__(self, executable_path: str = "Twinkle Tray.exe"):
        self.executable_path = executable_path
        list_out = subprocess.check_output([self.executable_path, "list"])
        self._display_mappings = self._get_mappings_from_display_list(list_out)

    def setVcp(self, model: str, code: str, value: str):
        result = subprocess.run([self.executable_path, "--VCP=" + code + ":" + value, "--MonitorNum=" + str(self._display_mappings[model])])
        if result.returncode != 0:
            raise Exception(f"failed: {result.stderr}")
