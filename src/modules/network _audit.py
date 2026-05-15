import numpy as np
import time
import random
from dataclasses import dataclass
from typing import Optional, List

# Konfigurasi Awal [4]
np.random.seed(23)
random.seed(23)

DEVICE_TYPES = ['SENSOR', 'GATEWAY', 'SERVER']
ALERT_TYPES = {'CRITICAL': 1, 'WARNING': 2, 'INFO': 3}

@dataclass
class Device:
    device_id: str
    tipe: str           # SENSOR / GATEWAY / SERVER
    status: str = 'ONLINE'
    last_reading: float = 0.0

@dataclass
class Alert:
    alert_id: int
    device_id: str
    tipe: int           # 1=CRITICAL, 2=WARNING, 3=INFO
    pesan: str
    timestamp: float
    def detect_isolated_devices(graph, gateway: str = 'GATEWAY_0') -> List[str]:
    """
    Mendeteksi perangkat yang terisolasi dari gateway menggunakan DFS.
    Big-O: O(V + E) [9].
    """
    # Gunakan Stack berbasis Linked List sesuai aturan proyek [10]
    stack = [gateway] # List Python digunakan sebagai array bantuan penyimpan node
    discovered = {gateway}
    
    while stack:
        u = stack.pop()
        # Eksplorasi tetangga node saat ini [12]
        curr = graph.adj.get(u)
        while curr:
            v = curr.dest
            if v not in discovered:
                discovered.add(v)
                stack.append(v)
            curr = curr.next