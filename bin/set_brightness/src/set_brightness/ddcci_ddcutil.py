import subprocess

from .ddcci_interface import DdcciInterface

class DdcciDdcutil(DdcciInterface):

    """Ddcutil is a ddcutil command implementation of DdcciInterface. """

    def __init__(self):
        pass

    def setVcp(self, model: str, code: str, value: str):
        result = subprocess.run(["ddcutil", "setvcp", "--model", model, code, value])
        if result.returncode != 0:
            raise Exception(f"failed to set {code}={value} to {model}")
