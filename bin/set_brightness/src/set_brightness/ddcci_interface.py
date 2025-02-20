from dataclasses import dataclass

@dataclass
class VcpValue:
    code: str
    value: str

class DdcciInterface:
    def __init__(self):
        pass

    def setVcp(self, model: str, vcpValues: list[VcpValue]):
        print(f"setVcp {model} {vcpValues}")
        pass
