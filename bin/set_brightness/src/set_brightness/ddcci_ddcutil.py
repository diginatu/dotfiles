import subprocess

from .ddcci_interface import DdcciInterface, VcpValue

class DdcciDdcutil(DdcciInterface):

    """Ddcutil is a ddcutil command implementation of DdcciInterface. """

    def __init__(self):
        pass

    def setVcp(self, model: str, vcpValues: list[VcpValue]):
        args = ["ddcutil", "setvcp", "--model", model]

        for vcpValue in vcpValues:
            args.append(vcpValue.code)
            args.append(vcpValue.value)

        result = subprocess.run(args)
        if result.returncode != 0:
            raise Exception(f"failed to set {vcpValues} to {model}")
