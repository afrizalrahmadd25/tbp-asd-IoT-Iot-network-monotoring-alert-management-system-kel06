import numpy as np
import random
import time
from typing import Dict, List, Tuple, Optional

def dijkstra_latensi(graph, source: str) -> Tuple[Dict[str, int], Dict[str, Optional[str]]]:
    """
    Menghitung rute latensi minimum dari GATEWAY_0 ke semua perangkat IoT.
    Implementasi menggunakan array sederhana untuk mencapai kompleksitas O(V^2 + E).
    """
    # 1. Inisialisasi jarak dengan tak hingga (sesuai Goodrich Bab 14)
    INF = float('inf')
    dist = {v: INF for v in graph.adj}
    # parent digunakan untuk menyimpan peta pendahulu rute
    parent = {v: None for v in graph.adj}
    visited = set()
    
    # Jarak ke node sumber (GATEWAY_0) adalah 0
    if source in dist:
        dist[source] = 0
    else:
        return dist, parent

    # 2. Loop Utama: Mencari jalur terpendek untuk setiap vertex
    for _ in range(len(graph.adj)):
        # Mencari vertex 'u' yang belum dikunjungi dengan dist[u] terkecil
        # Ini adalah pencarian manual O(V) sesuai spesifikasi teknis panduan
        u = None
        min_dist = INF
        for v in graph.adj:
            if v not in visited and dist[v] < min_dist:
                min_dist = dist[v]
                u = v
        
        # Berhenti jika tidak ada node yang bisa dijangkau lagi
        if u is None:
            break
            
        visited.add(u)
        
        # 3. Proses Relaksasi (Goodrich Code Fragment 14.12)
        # graph.neighbors(u) mengembalikan list Tuple (dest, latensi)
        for v, latensi in graph.neighbors(u):
            if v not in visited:
                new_dist = dist[u] + latensi
                # Jika ditemukan jalur dengan latensi lebih rendah
                if new_dist < dist[v]:
                    dist[v] = new_dist
                    parent[v] = u
                    
    return dist, parent

def reconstruct_path(parent: Dict[str, Optional[str]], source: str, target: str) -> List[str]:
    """
    Membangun kembali jalur fisik dari GATEWAY ke perangkat tertentu.
    Menggunakan teknik 'walking back' (Goodrich Code Fragment 14.6).
    """
    path = []
    curr = target
    
    # Menelusuri balik menggunakan dictionary parent
    while curr is not None:
        path.append(curr)
        if curr == source:
            break
        curr = parent[curr]
    
    # Jika tidak terhubung ke source, rute tidak valid
    if not path or path[-1] != source:
        return []
        
    path.reverse()
    return path

def get_bottleneck_link(graph, parent: Dict[str, Optional[str]]) -> Tuple[Optional[Tuple[str, str]], int]:
    """
    Mengidentifikasi 'bottleneck link' (edge dengan latensi tertinggi) 
    pada Shortest Path Tree untuk audit jaringan (Spesifikasi Modul 5).
    """
    max_latensi = -1
    bottleneck_edge = None
    
    for v, u in parent.items():
        if u is not None:
            # Cari latensi asli antara node u dan v di dalam graf
            for neighbor, lat in graph.neighbors(u):
                if neighbor == v:
                    if lat > max_latensi:
                        max_latensi = lat
                        bottleneck_edge = (u, v)
                    break
                    
    return bottleneck_edge, max_latensi