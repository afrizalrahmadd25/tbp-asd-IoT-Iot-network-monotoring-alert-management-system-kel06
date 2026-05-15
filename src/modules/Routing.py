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
def dijkstra_latensi(graph, source: str) -> Tuple[Dict[str, int], Dict[str, Optional[str]]]:
    """
    Mencari rute dengan latensi minimum menggunakan algoritma Dijkstra (Array Based).
    Big-O: O(V^2 + E) sesuai panduan [4].
    """
    INF = float('inf')
    # Inisialisasi jarak dan parent [4]
    dist = {v: INF for v in graph.adj}
    parent = {v: None for v in graph.adj}
    visited = set()
    dist[source] = 0

    for _ in range(len(graph.adj)):
        # Mencari node dengan latensi terkecil yang belum dikunjungi (Greedy) [5]
        u = None
        min_val = INF
        for node in graph.adj:
            if node not in visited and dist[node] < min_val:
                min_val = dist[node]
                u = node
        
        if u is None: break
        visited.add(u)

        # Relaksasi sisi (Edge Relaxation) [6]
        curr = graph.adj[u]
        while curr:
            v, latency = curr.dest, curr.latensi
            if dist[u] + latency < dist[v]:
                dist[v] = dist[u] + latency
                parent[v] = u
            curr = curr.next
            
    return dist, parent

def selection_sort_latency(audit_list: List[Tuple[str, int]]):
    """
    Mengurutkan perangkat berdasarkan latensi ke gateway menggunakan Selection Sort.
    Big-O: O(n^2) operasi pertukaran worst-case [7].
    """
    n = len(audit_list)
    for i in range(n):
        min_idx = i
        for j in range(i + 1, n):
            # Bandingkan nilai latensi pada tuple (device_id, latency) [7]
            if audit_list[j][8] < audit_list[min_idx][8]:
                min_idx = j
        # Pertukaran elemen (swap) [7]
        audit_list[i], audit_list[min_idx] = audit_list[min_idx], audit_list[i]