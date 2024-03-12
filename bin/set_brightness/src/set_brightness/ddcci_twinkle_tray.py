import re
import subprocess

from .ddcci_interface import DdcciInterface

class DdcciTwinkleTray(DdcciInterface):

    """TwinkleTray is a windows app Twinkle Tray command implementation of DdcciInterface. """

    def _get_mappings_from_display_list(self, result: bytes) -> dict[str, int]:
        ansi_escape = re.compile(rb'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]')
        ansi_escape.sub(b'', result)
        return {}

    def __init__(self):
        result = subprocess.check_output(["Twinkle Tray.exe", "--List"])
        self.display_mappings = self._get_mappings_from_display_list(result)

    def setVcp(self, model: str, code: str, value: str):
        result = subprocess.run(["Twinkle Tray.exe", "--List"])
        if result.returncode != 0:
            raise Exception(f"failed: {result.stderr}")
