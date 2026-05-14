class AlertStack:
def __init__(self, kapasitas=20):
self.top: Optional[LLNode] = None
self._size = 0
self.kapasitas = kapasitas
def push(self, alert: Alert) -> None:
# TODO: jika penuh, hapus elemen paling bawah (oldest)
pass
def pop(self) -> Optional[Alert]:
# TODO: implementasikan
pass
def to_list(self) -> List[Alert]:
# TODO: kembalikan list alert dari top ke bottom
pass
