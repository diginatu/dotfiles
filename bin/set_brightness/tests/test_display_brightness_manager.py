from dataclasses import dataclass
import datetime
from io import StringIO
import unittest
from unittest.mock import MagicMock

from src.set_brightness.color import Color
from src.set_brightness.ddcci_interface import DdcciInterface, VcpValue
from src.set_brightness.display import Display
from src.set_brightness.display_brightness_manager import DisplayBrightnessManager

class TestDisplayBrightnessManager(unittest.TestCase):

    def setUp(self):
        self.time1_start = datetime.time(6, 0)
        self.time1_end = datetime.time(12, 0)
        self.time2_start = datetime.time(14, 0)
        self.time2_end = datetime.time(20, 0)
        self.night_color_start = datetime.time(23, 0)
        self.night_color_end = datetime.time(4, 0)
        self.display = Display("Test Display",
                               contrast_min=0, contrast_max=100,
                               night_color=Color(1, 2, 3))
        self.display2 = Display("Test Display2",
                                contrast_min=5, contrast_max=95,
                                night_color=Color(4, 5, 6))

    def test_set_displays_brightness_should_call_vcp(self):
        @dataclass
        class TestCase:
            name: str
            now: datetime.datetime
            expectedDisplay1Contrast: str
            expectedDisplay1RedGain: str
            expectedDisplay1GreenGain: str
            expectedDisplay1BlueGain: str
            expectedDisplay1Brightness: str
            expectedDisplay2Contrast: str
            expectedDisplay2RedGain: str
            expectedDisplay2GreenGain: str
            expectedDisplay2BlueGain: str
            expectedDisplay2Brightness: str

        testCases = [
            TestCase("middle of night and time1",
                datetime.datetime(2021, 1, 1, 5, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
            TestCase("start of time1",
                datetime.datetime(2021, 1, 1, 6, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
            TestCase("middle of time1",
                datetime.datetime(2021, 1, 1, 7, 0),
                "41", "50", "50", "50", "0",
                "42", "50", "50", "50", "0"),
            TestCase("end of time1",
                datetime.datetime(2021, 1, 1, 12, 0),
                "100", "50", "50", "50", "100",
                "95", "50", "50", "50", "100"),
            TestCase("middle of time1 and time2",
                datetime.datetime(2021, 1, 1, 13, 0),
                "100", "50", "50", "50", "100",
                "95", "50", "50", "50", "100"),
            TestCase("start of time2",
                datetime.datetime(2021, 1, 1, 14, 0),
                "100", "50", "50", "50", "100",
                "95", "50", "50", "50", "100"),
            TestCase("middle of time2",
                datetime.datetime(2021, 1, 1, 15, 0),
                "58", "50", "50", "50", "100",
                "57", "50", "50", "50", "100"),
            TestCase("end of time2",
                datetime.datetime(2021, 1, 1, 20, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
            TestCase("middle of time2 and night",
                datetime.datetime(2021, 1, 1, 21, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
            TestCase("start of night",
                datetime.datetime(2021, 1, 1, 23, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
            TestCase("middle of night",
                datetime.datetime(2021, 1, 2, 1, 0),
                "0", "1", "2", "3", "0",
                "5", "4", "5", "6", "0"),
            TestCase("half our before end of night",
                datetime.datetime(2021, 1, 2, 3, 30),
                "0", "25", "26", "26", "0",
                "5", "27", "27", "28", "0"),
            TestCase("end of night",
                datetime.datetime(2021, 1, 2, 4, 0),
                "0", "50", "50", "50", "0",
                "5", "50", "50", "50", "0"),
        ]

        for testSet in testCases:
            with self.subTest(testSet.name):
                print("\nSubtest:", testSet.name)
                ddcci = MagicMock(spec=DdcciInterface)
                manager = DisplayBrightnessManager(
                    self.time1_start, self.time1_end,
                    self.time2_start, self.time2_end,
                    self.night_color_start, self.night_color_end,
                    [self.display, self.display2], ddcci,
                    StringIO("{}")
                )

                manager.set_displays_brightness(testSet.now)

                ddcci.setVcp.assert_any_call("Test Display", 
                                             [
                                             VcpValue("0x12", testSet.expectedDisplay1Contrast),
                                             VcpValue("0x16", testSet.expectedDisplay1RedGain),
                                             VcpValue("0x18", testSet.expectedDisplay1GreenGain),
                                             VcpValue("0x1a", testSet.expectedDisplay1BlueGain),
                                             VcpValue("0x10", testSet.expectedDisplay1Brightness),
                                             ])

                ddcci.setVcp.assert_any_call("Test Display2", 
                                             [
                                             VcpValue("0x12", testSet.expectedDisplay2Contrast),
                                             VcpValue("0x16", testSet.expectedDisplay2RedGain),
                                             VcpValue("0x18", testSet.expectedDisplay2GreenGain),
                                             VcpValue("0x1a", testSet.expectedDisplay2BlueGain),
                                             VcpValue("0x10", testSet.expectedDisplay2Brightness),
                                             ])

    def test_set_displays_brightness_should_call_vcp_when_cache_file_is_empty(self):
        ddcci = MagicMock(spec=DdcciInterface)
        manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            self.time2_start, self.time2_end,
            self.night_color_start, self.night_color_end,
            [self.display], ddcci,
            StringIO("{}")
        )

        manager.set_displays_brightness(datetime.datetime(2021, 1, 1, 0, 0))

        ddcci.setVcp.assert_any_call("Test Display", [
            VcpValue("0x12", "0"),
            VcpValue("0x16", "1"),
            VcpValue("0x18", "2"),
            VcpValue("0x1a", "3"),
            VcpValue("0x10", "0"),
        ])

    def test_set_displays_brightness_should_call_vcp_when_different_values_cached(self):
        ddcci = MagicMock(spec=DdcciInterface)
        manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            self.time2_start, self.time2_end,
            self.night_color_start, self.night_color_end,
            [self.display], ddcci,
            StringIO("""{
                "Test Display:0x12": "49",
                "Test Display:0x16": "9",
                "Test Display:0x18": "19",
                "Test Display:0x1a": "29",
                "Test Display:0x10": "48"
            }""")
        )

        manager.set_displays_brightness(datetime.datetime(2021, 1, 1, 0, 0))

        ddcci.setVcp.assert_any_call("Test Display", [
            VcpValue("0x12", "0"),
            VcpValue("0x16", "1"),
            VcpValue("0x18", "2"),
            VcpValue("0x1a", "3"),
            VcpValue("0x10", "0"),
        ])

    def test_set_displays_brightness_should_not_call_vcp_when_same_values_cached(self):
        ddcci = MagicMock(spec=DdcciInterface)
        manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            self.time2_start, self.time2_end,
            self.night_color_start, self.night_color_end,
            [self.display], ddcci,
            StringIO("""{
                "Test Display:0x12": "0",
                "Test Display:0x16": "1",
                "Test Display:0x18": "2",
                "Test Display:0x1a": "3",
                "Test Display:0x10": "0"
            }""")
        )

        manager.set_displays_brightness(datetime.datetime(2021, 1, 1, 0, 0))

        ddcci.setVcp.assert_not_called()

    def test_set_displays_brightness_should_call_partial_vcp_when_same_values_partially_cached(self):
        ddcci = MagicMock(spec=DdcciInterface)
        manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            self.time2_start, self.time2_end,
            self.night_color_start, self.night_color_end,
            [self.display], ddcci,
            StringIO("""{
                "Test Display:0x12": "0",
                "Test Display:0x16": "1",
                "Test Display:0x18": "2",
                "Test Display:0x1a": "100",
                "Test Display:0x10": "100"
            }""")
        )

        manager.set_displays_brightness(datetime.datetime(2021, 1, 1, 0, 0))

        ddcci.setVcp.assert_any_call("Test Display", [
            VcpValue("0x1a", "3"),
            VcpValue("0x10", "0"),
        ])

    def test_set_displays_brightness_should_call_vcp_when_time_range_is_over_midnight(self):
        ddcci = MagicMock(spec=DdcciInterface)
        manager = DisplayBrightnessManager(
            self.time1_start, self.time1_end,
            datetime.time(23, 0), datetime.time(1, 0), # over midnight
            datetime.time(3, 0), datetime.time(6, 0), # not night time
            [self.display], ddcci,
            StringIO("{}")
        )

        manager.set_displays_brightness(datetime.datetime(2021, 1, 1, 0, 0))

        ddcci.setVcp.assert_any_call("Test Display", [
            VcpValue("0x12", "50"),
            VcpValue("0x16", "50"),
            VcpValue("0x18", "50"),
            VcpValue("0x1a", "50"),
            VcpValue("0x10", "49"),
        ])
