import datetime
from io import StringIO
import unittest
from unittest.mock import MagicMock

from src.set_brightness.color import Color
from src.set_brightness.ddcci_interface import DdcciInterface
from src.set_brightness.display import Display
from src.set_brightness.display_brightness_manager import DisplayBrightnessManager

class TestDisplayBrightnessManager(unittest.TestCase):

    def setUp(self):
        self.time1_start = datetime.time(6, 0)
        self.time1_end = datetime.time(8, 0)
        self.time2_start = datetime.time(18, 0)
        self.time2_end = datetime.time(20, 0)
        self.night_color_start = datetime.time(21, 0)
        self.night_color_end = datetime.time(23, 0)
        self.night_color = Color(10, 20, 30)
        self.display = Display("Test Display", 0, 100)
        self.state_io = StringIO()
        self.ddcci = MagicMock(spec=DdcciInterface)
        self.manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            self.time2_start, self.time2_end,
            self.night_color_start, self.night_color_end,
            self.night_color,
            [self.display], self.ddcci,
            self.state_io
        )

    def test_set_displays_brightness_should_call_vcp(self):
        now = datetime.datetime(2021, 1, 1, 7, 0)
        self.manager.set_displays_brightness(now)
        self.state_io.write("{}")

        self.ddcci.setVcp.assert_any_call("Test Display", "0x12", "50") # Contrast
        self.ddcci.setVcp.assert_any_call("Test Display", "0x16", "10") # Red Gain
        self.ddcci.setVcp.assert_any_call("Test Display", "0x18", "20") # Green Gain
        self.ddcci.setVcp.assert_any_call("Test Display", "0x1a", "30") # Blue Gain
        self.ddcci.setVcp.assert_any_call("Test Display", "0x10", "49") # Brightness

    def test_set_displays_brightness_should_call_vcp_when_cache_file_is_empty(self):
        now = datetime.datetime(2021, 1, 1, 7, 0)
        self.manager.set_displays_brightness(now)

        self.ddcci.setVcp.assert_any_call("Test Display", "0x12", "50")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x16", "10")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x18", "20")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x1a", "30")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x10", "49")

    def test_set_displays_brightness_should_call_vcp_when_different_values_cached(self):
        self.state_io.write("""{
            "Test Display:0x12": "49",
            "Test Display:0x16": "9",
            "Test Display:0x18": "19",
            "Test Display:0x1a": "29",
            "Test Display:0x10": "48"
        }""")

        now = datetime.datetime(2021, 1, 1, 7, 0)
        self.manager.set_displays_brightness(now)

        self.ddcci.setVcp.assert_any_call("Test Display", "0x12", "50")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x16", "10")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x18", "20")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x1a", "30")
        self.ddcci.setVcp.assert_any_call("Test Display", "0x10", "49")

    def test_set_displays_brightness_should_not_call_vcp_when_same_values_cached(self):
        self.state_io.write("""{
            "Test Display:0x12": "50",
            "Test Display:0x16": "10",
            "Test Display:0x18": "20",
            "Test Display:0x1a": "30",
            "Test Display:0x10": "49"
        }""")

        now = datetime.datetime(2021, 1, 1, 7, 0)
        self.manager.set_displays_brightness(now)

        self.ddcci.setVcp.assert_not_called()
