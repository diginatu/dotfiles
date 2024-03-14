import subprocess
import unittest
from unittest import mock

from src.set_brightness.ddcci_twinkle_tray import DdcciTwinkleTray

class TestTwinkcleTray(unittest.TestCase):
    @mock.patch('subprocess.check_output')
    def test_init_should_parse_display_list_and_create_a_mappings(self, mock_check_output):
        mock_check_output.return_value = b'\r\n\n\x1b[36mMonitorNum:\x1b[0m 2\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID8388688\n\x1b[36mName:\x1b[0m Display 3\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m wmi\n\n\x1b[36mMonitorNum:\x1b[0m 0\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID8261\n\x1b[36mName:\x1b[0m PHL 246E7\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n\n\x1b[36mMonitorNum:\x1b[0m 1\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID28742\n\x1b[36mName:\x1b[0m LG HDR 4K\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n\n\x1b[36mMonitorNum:\x1b[0m 1\n\x1b[36mMonitorID:\x1b[0m 4&21d568e6&0&UID12613\n\x1b[36mName:\x1b[0m LG HDR 4K\n\x1b[36mBrightness:\x1b[0m 0\n\x1b[36mType:\x1b[0m ddcci\n'
        ddcci = DdcciTwinkleTray()
        mock_check_output.assert_called_once_with(["Twinkle Tray.exe", "list"])
        self.assertEqual(ddcci._display_mappings, {
            "PHL 246E7": 1,
            "LG HDR 4K": 2,
            "Display 3": 3
        })

    @mock.patch('subprocess.check_output')
    def test_init_should_parse_empty_display_list_and_create_empty_mappings(self, mock_check_output):
        mock_check_output.return_value = b''
        ddcci = DdcciTwinkleTray()
        mock_check_output.assert_called_once_with(["Twinkle Tray.exe", "list"])
        self.assertEqual(ddcci._display_mappings, {})

    @mock.patch('subprocess.run')
    @mock.patch('subprocess.check_output')
    def test_setVcp_should_call_twinkle_tray_with_correct_args(self, mock_check_output, mock_run):
        mock_check_output.return_value = b''
        mock_run.return_value.returncode = 0
        ddcci = DdcciTwinkleTray()

        ddcci._display_mappings = {"LG HDR 4K": 1}
        ddcci.setVcp("LG HDR 4K", "10", "100")
        subprocess.run.assert_called_once_with(["Twinkle Tray.exe", "--VCP=10:100", "--MonitorNum=1"])
