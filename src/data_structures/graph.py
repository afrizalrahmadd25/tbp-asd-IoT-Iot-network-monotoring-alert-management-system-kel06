import numpy as np
import time
import random
from dataclasses import dataclass
from typing import Optional, List

# Pastikan import ini sesuai dengan lokasi file LLNode Anda
from linked_list import LLNode

# Konfigurasi Awal [4]
np.random.seed(23)
random.seed(23)

DEVICE_TYPES = ['SENSOR', 'GATEWAY', 'SERVER']
ALERT_TYPES = {'CRITICAL': 1, 'WARNING': 2, 'INFO': 3}

# Biarkan ini jika diperlukan modul lain, 
# meski di main.py kita juga sudah mendefinisikannya.
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

class Edge:
    def __init__(self, dest: str, latency: int):
        self.dest = dest
        self.latency = latency

class IoTGraph:
    def __init__(self):
        self.adj = {} # Dictionary of Linked Lists [2, 9]

    def add_device(self, device):
        # Mengecek apakah input berupa objek Device atau sekadar string
        dev_id = getattr(device, 'device_id', device)
        if dev_id not in self.adj:
            self.adj[dev_id] = None # Head of Linked List

    def add_link(self, u: str, v: str, latency: int):
        # Tambah u -> v
        new_node = LLNode(Edge(v, latency))
        new_node.next = self.adj.get(u)
        self.adj[u] = new_node
        
        # Tambah v -> u (Undirected Mesh)
        new_node = LLNode(Edge(u, latency))
        new_node.next = self.adj.get(v)
        self.adj[v] = new_node

    def neighbors(self, u: str):
        """Mengembalikan list of tuples (tetangga, latensi) untuk algoritma Dijkstra."""
        result = []
        curr = self.adj.get(u)
        while curr:
            result.append((curr.data.dest, curr.data.latency))
            curr = curr.next
        return result

    def isolated_devices(self, start_node='GATEWAY_0'):
        """Gunakan DFS untuk deteksi isolasi [2]. (Nama disesuaikan dengan main.py)"""
        visited = set()
        stack = [start_node] # List Python sebagai array bantuan
        
        while stack:
            curr = stack.pop()
            if curr not in visited:
                visited.add(curr)
                node = self.adj.get(curr)
                while node:
                    stack.append(node.data.dest)
                    node = node.next
        
        isolated = [d for d in self.adj if d not in visited]
        return isolated