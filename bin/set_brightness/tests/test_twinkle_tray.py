import unittest

from src.set_brightness.ddcci_twinkle_tray import DdcciTwinkleTray

class TestTwinkcleTray(unittest.TestCase):
    def test_init_should_parse_display_list_and_create_a_mappings(self):
        list_stdout = b'\r\n\n\x1b[36mMonitorNum:\x1b[0m 2\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID8388688\n\x1b[36mName:\x1b[0m Display 3\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m wmi\n\n\x1b[36mMonitorNum:\x1b[0m 0\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID8261\n\x1b[36mName:\x1b[0m PHL 246E7\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n\n\x1b[36mMonitorNum:\x1b[0m 1\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID28742\n\x1b[36mName:\x1b[0m LG HDR 4K\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n\n\x1b[36mMonitorNum:\x1b[0m 1\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID12613\n\x1b[36mName:\x1b[0m LG HDR 4K\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n'

        self.assertEqual(DdcciTwinkleTray._get_mappings_from_display_list(list_stdout), {
            "PHL 246E7": 1,
            "LG HDR 4K": 2,
            "Display 3": 3
        })
