import numpy as np
import random
#

def generate_iot_network(n_devices=40, n_extra_edges=20, seed=23):
    """
    Menghasilkan data awal untuk jaringan IoT (Generator).
    Big-O: O(N + M) di mana N adalah jumlah perangkat dan M adalah jumlah extra edges.
    """
    # Import lokal di dalam fungsi untuk menghindari circular import jika perlu
    from main import Device 
    
    # Inisialisasi generator angka acak sesuai seed panduan [4]
    rng = np.random.default_rng(seed)
    devices = []

    # 1. Menghasilkan Perangkat: 1 Gateway, 4 Server, dan sisanya Sensor [5]
    devices.append(Device('GATEWAY_0', 'GATEWAY'))
    
    for i in range(1, 5):
        devices.append(Device(f'SERVER_{i}', 'SERVER'))
    
    for i in range(5, n_devices):
        # Sensor diberikan nilai pembacaan awal acak antara 0-100 [5]
        val = float(rng.uniform(0, 100))
        devices.append(Device(f'SENSOR_{i}', 'SENSOR', last_reading=val))

    # 2. Menghasilkan Koneksi (Edges): Spanning Tree agar semua terhubung [5]
    perm = rng.permutation(n_devices)
    edges = []
    for i in range(1, n_devices):
        u = devices[perm[i-1]].device_id
        v = devices[perm[i]].device_id
        # Latensi acak antara 5ms hingga 200ms [5]
        lat = int(rng.integers(5, 200))
        edges.append((u, v, lat))

    # 3. Menambahkan Edge Ekstra untuk menciptakan topologi Mesh [5, 6]
    for _ in range(n_extra_edges):
        i, j = rng.choice(n_devices, 2, replace=False)
        lat = int(rng.integers(5, 200))
        edges.append((devices[i].device_id, devices[j].device_id, lat))
        
    return devices, edges