import sys, time, random
sys.path.insert(0, 'src')
import time
import random
import matplotlib.pyplot as plt
from data_structures.stack import AlertStack
from data_structures.bst_registry import DeviceBST
from data_structures.priority_queue import AlertPriorityQueue

class FakeDevice:
    def __init__(self, did):
        self.device_id = did
        self.tipe = 'SENSOR'
        self.status = 'ONLINE'
        self.last_reading = 0.0

class FakeAlert:
    def __init__(self, aid, tipe):
        self.alert_id = aid
        self.device_id = 'SENSOR_1'
        self.tipe = tipe
        self.pesan = 'test'
        self.timestamp = 0.0

sizes = [20, 40, 100]
bst_insert, bst_search = [], []
pq_enqueue, pq_dequeue = [], []
stack_push, stack_pop = [], []

print(f"{'N':>6} | {'BST Insert':>12} | {'BST Search':>12} | {'PQ Enqueue':>12} | {'Stack Push':>12}")
print("-" * 65)

for n in sizes:
    # BST benchmark
    devices = [FakeDevice(f'DEV_{i:04d}') for i in range(n)]
    random.shuffle(devices)
    bst = DeviceBST()
    t0 = time.perf_counter()
    for d in devices: bst.insert(d)
    bst_insert.append((time.perf_counter()-t0)*1000)

    t0 = time.perf_counter()
    bst.search(f'DEV_{n//2:04d}')
    bst_search.append((time.perf_counter()-t0)*1000)

    # Priority Queue benchmark
    pq = AlertPriorityQueue()
    alerts = [FakeAlert(i, (i % 3) + 1) for i in range(n)]
    t0 = time.perf_counter()
    for a in alerts: pq.enqueue(a)
    pq_enqueue.append((time.perf_counter()-t0)*1000)

    t0 = time.perf_counter()
    pq.dequeue()
    pq_dequeue.append((time.perf_counter()-t0)*1000)

    # Stack benchmark
    s = AlertStack(capacity=n+1)
    t0 = time.perf_counter()
    for i in range(n): s.push(f"alert_{i}")
    stack_push.append((time.perf_counter()-t0)*1000)

    t0 = time.perf_counter()
    s.pop()
    stack_pop.append((time.perf_counter()-t0)*1000)

    print(f"{n:>6} | {bst_insert[-1]:>12.4f} | {bst_search[-1]:>12.4f} | {pq_enqueue[-1]:>12.4f} | {stack_push[-1]:>12.4f}")

# Buat grafik
plt.figure(figsize=(10, 6))
plt.plot(sizes, bst_insert, 'o-', label='BST Insert', color='teal', linewidth=2)
plt.plot(sizes, bst_search, 's--', label='BST Search', color='steelblue', linewidth=2)
plt.plot(sizes, pq_enqueue, '^-', label='PQ Enqueue', color='orange', linewidth=2)
plt.plot(sizes, stack_push, 'D--', label='Stack Push', color='purple', linewidth=2)
plt.xlabel('Jumlah Perangkat (N)', fontsize=12)
plt.ylabel('Runtime (ms)', fontsize=12)
plt.title('Benchmark Runtime — IoT Network Monitoring Kel-06', fontsize=13)
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig('hasil_benchmark.png', dpi=150)
print("\n✅ Grafik disimpan sebagai hasil_benchmark.png")