import unittest
import datetime

from src.set_brightness.display_brightness_manager import (
    _add_time,
    _is_time_between,
    _rate_time_between,
)

class TestTimeUtils(unittest.TestCase):
    def test_is_time_between(self):
        self.assertTrue(_is_time_between(datetime.time(12, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertFalse(_is_time_between(datetime.time(10, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertFalse(_is_time_between(datetime.time(14, 0), datetime.time(11, 0), datetime.time(13, 0)))
        self.assertTrue(_is_time_between(datetime.time(1, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertTrue(_is_time_between(datetime.time(0, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertTrue(_is_time_between(datetime.time(23, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertFalse(_is_time_between(datetime.time(4, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertTrue(_is_time_between(datetime.time(3, 0), datetime.time(23, 0), datetime.time(3, 0)))
        self.assertFalse(_is_time_between(datetime.time(3, 1), datetime.time(23, 0), datetime.time(3, 0)))

    def test_add_time(self):
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=1)), datetime.time(13, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=23)), datetime.time(11, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=24)), datetime.time(12, 0))
        self.assertEqual(_add_time(datetime.time(12, 0), datetime.timedelta(hours=0)), datetime.time(12, 0))
        self.assertEqual(_add_time(datetime.time(23, 0), datetime.timedelta(hours=1)), datetime.time(0, 0))

    def test_rate_time_between(self):
        self.assertEqual(_rate_time_between(datetime.time(12, 0), datetime.time(11, 0), datetime.time(13, 0)), 0.5)
        self.assertEqual(_rate_time_between(datetime.time(12, 0), datetime.time(12, 0), datetime.time(13, 0)), 0.0)
        self.assertEqual(_rate_time_between(datetime.time(13, 0), datetime.time(12, 0), datetime.time(13, 0)), 1.0)

        # When now is out of range, the rate should be out from 0.0 to 1.0
        self.assertEqual(_rate_time_between(datetime.time(9, 0), datetime.time(10, 0), datetime.time(11, 0)), -1.0)
        self.assertEqual(_rate_time_between(datetime.time(13, 0), datetime.time(10, 0), datetime.time(11, 0)), 3.0)

        # When base time it over midnight
        self.assertEqual(_rate_time_between(datetime.time(19, 0), datetime.time(23, 0), datetime.time(1, 0)), 10.0) # or -2.0
        self.assertEqual(_rate_time_between(datetime.time(0, 0), datetime.time(23, 0), datetime.time(1, 0)), 0.5)
        self.assertEqual(_rate_time_between(datetime.time(1, 0), datetime.time(23, 0), datetime.time(1, 0)), 1.0)
        self.assertEqual(_rate_time_between(datetime.time(2, 0), datetime.time(23, 0), datetime.time(1, 0)), 1.5)
