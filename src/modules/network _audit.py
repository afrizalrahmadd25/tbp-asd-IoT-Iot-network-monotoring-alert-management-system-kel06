class BSTNode:
def __init__(self, device: Device):
self.device = device
self.left = self.right = None
class BSTRegistry:
def __init__(self): self.root = None
def insert(self, device: Device): pass # TODO
def search(self, device_id: str): pass # TODO
def update_status(self, device_id: str, status: str): pass # TODO
def inorder(self): pass # TODO
# ── Generator data awal ───────────────────────────────────────────
def generate_iot_network(n_devices=40, n_extra_edges=20, seed=23):
rng = np.random.default_rng(seed)
devices = []
# 1 gateway, beberapa server, sisanya sensor
devices.append(Device('GATEWAY_0', 'GATEWAY'))
for i in range(1, 5):
devices.append(Device(f'SERVER_{i}', 'SERVER'))
for i in range(5, n_devices):
devices.append(Device(f'SENSOR_{i}', 'SENSOR',
last_reading=float(rng.uniform(0, 100))))
# Spanning tree: pastikan terhubung
perm = rng.permutation(n_devices)
edges = []
for i in range(1, n_devices):
u = devices[perm[i-1]].device_id
v = devices[perm[i]].device_id
lat = int(rng.integers(5, 200)) # 5–200 ms
edges.append((u, v, lat))
for _ in range(n_extra_edges):
i, j = rng.choice(n_devices, 2, replace=False)
lat = int(rng.integers(5, 200))
edges.append((devices[i].device_id, devices[j].device_id, lat))
return devices, edges
def main():
graph = IoTGraph()
bst_reg = BSTRegistry()
alert_queue = AlertPriorityQueue()
device_stacks: Dict[str, AlertStack] = {}
alert_counter = 0
devices, edges = generate_iot_network(40, 20, seed=23)
for d in devices:
graph.add_device(d)
bst_reg.insert(d)
device_stacks[d.device_id] = AlertStack(kapasitas=20)
for u, v, lat in edges:
graph.add_link(u, v, lat)
print('IoT Monitoring System Ketik BANTUAN untuk daftar perintah')
# TODO: implementasikan loop CLI
if __name__ == '__main__':
main()