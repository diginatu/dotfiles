import unittest
import datetime

from src.set_brightness.display_brightness_manager import (
    _add_time,
    _delta_time,
    _is_time_between,
)

class TestTimeUtils(unittest.TestCase):
    def test_is_time_between(self):
        self.assertTrue(_is_time_between(datetime.time(12, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertFalse(_is_time_between(datetime.time(10, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertFalse(_is_time_between(datetime.time(14, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertTrue(_is_time_between(datetime.time(1, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertTrue(_is_time_between(datetime.time(23, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertFalse(_is_time_between(datetime.time(4, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertTrue(_is_time_between(datetime.time(3, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertFalse(_is_time_between(datetime.time(3, 1), datetime.time(23, 0), datetime.time(3, 0)))

    def test_delta_time(self):
        self.assertEqual(_delta_time(datetime.time(12, 0), datetime.time(11, 0)), datetime.timedelta(hours=23))
        self.assertEqual(_delta_time(datetime.time(12, 0), datetime.time(13, 0)), datetime.timedelta(hours=1))
        self.assertEqual(_delta_time(datetime.time(12, 0), datetime.time(12, 0)), datetime.timedelta(hours=0))
        self.assertEqual(_delta_time(datetime.time(0, 0), datetime.time(23, 0)), datetime.timedelta(hours=23))
        self.assertEqual(_delta_time(datetime.time(23, 0), datetime.time(3, 0)), datetime.timedelta(hours=4))
        self.assertEqual(_delta_time(datetime.time(23, 0), datetime.time(0, 0)), datetime.timedelta(hours=1))

    def test_add_time(self):
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=1)), datetime.time(13, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=23)), datetime.time(11, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=24)), datetime.time(12, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=0)), datetime.time(12, 0))
        self.assertEqual(_add_time(datetime.time(23, 0), datetime.timedelta(hours=1)), datetime.time(0, 0))
