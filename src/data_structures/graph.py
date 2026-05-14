class IoTGraph:
def __init__(self):
self.adj: Dict[str, Optional[EdgeNode]] = {}
self.devices: Dict[str, Device] = {}
def add_device(self, device: Device) -> None:
# TODO: implementasikan
pass
def add_link(self, u: str, v: str, latensi: int) -> None:
"""Big-O: O(1)."""
# TODO: implementasikan (undirected)
pass
def neighbors(self, u: str) -> List[Tuple[str, int]]:
"""Big-O: O(deg(u))."""
# TODO: kembalikan list (dest, latensi)
pass
def dfs_reachable(self, source: str) -> set:
"""DFS berbasis Stack Linked List. Big-O: O(V+E)."""
# TODO: gunakan Stack yang diimplementasi sendiri
pass
def isolated_devices(self, gateway: str = 'GATEWAY_0') -> List[str]:
"""Kembalikan device yang tidak terjangkau dari gateway."""
reachable = self.dfs_reachable(gateway)
return [d for d in self.adj if d not in reachable]
