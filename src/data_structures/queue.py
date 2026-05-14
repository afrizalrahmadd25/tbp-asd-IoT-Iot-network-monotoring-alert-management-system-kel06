class AlertPriorityQueue:
"""Linked List terurut tipe ASC (CRITICAL=1 di depan)."""
def __init__(self):
self.head: Optional[LLNode] = None
self._size: int = 0
def enqueue(self, alert: Alert) -> None:
"""Big-O: O(n) insertion berdasarkan prioritas."""
# TODO: implementasikan
pass
def dequeue(self) -> Optional[Alert]:
"""Big-O: O(1)."""
# TODO: implementasikan
pass
def __len__(self): return self._size