import numpy as np
import time
import random
from typing import Optional, List
from dataclasses import dataclass

# Struktur Node untuk Linked List sesuai standar panduan [3]
class LLNode:
    def __init__(self, data=None):
        self.data = data
        self.next: Optional['LLNode'] = None

# Struktur Alert sesuai starter code Topik 4 [3]
@dataclass
class Alert:
    alert_id: int
    device_id: str
    tipe: int           # 1=CRITICAL, 2=WARNING, 3=INFO
    pesan: str
    timestamp: float

class AlertStack:
    """
    Implementasi Stack berbasis Linked List (LIFO) untuk riwayat alert.
    Mendukung kapasitas tetap (20 alert) sesuai spesifikasi Modul 4. [1]
    """
    def __init__(self, kapasitas=20):
        self.top: Optional[LLNode] = None
        self._size = 0
        self.kapasitas = kapasitas

    def push(self, alert: Alert) -> None:
        """
        Menambahkan alert baru ke posisi teratas (head). [4]
        Jika kapasitas penuh, elemen tertua di dasar stack dihapus. [1, 2]
        Big-O: O(1).
        """
        # Sesuai prinsip Goodrich: bagian 'top' stack berada di head Linked List [4]
        new_node = LLNode(alert)
        new_node.next = self.top
        self.top = new_node
        self._size += 1

        # Cek apakah melebihi kapasitas (20 alert terakhir)
        if self._size > self.kapasitas:
            self._prune_bottom()

    def _prune_bottom(self):
        """
        Helper untuk mencari dan menghapus node paling akhir (elemen tertua).
        Karena kapasitas konstan (20), operasi ini tetap dianggap O(1) praktis.
        """
        if self.top is None:
            return
        
        curr = self.top
        # Berhenti di node kedua terakhir untuk memutus link ke node terakhir
        while curr.next and curr.next.next:
            curr = curr.next
        
        curr.next = None
        self._size -= 1

    def pop(self) -> Optional[Alert]:
        """
        Mengambil dan menghapus alert terbaru dari posisi head. [5]
        Big-O: O(1).
        """
        if self.is_empty():
            return None
        
        answer = self.top.data
        self.top = self.top.next
        self._size -= 1
        return answer

    def to_list(self) -> List[Alert]:
        """
        Mengonversi isi stack ke dalam list untuk kebutuhan display CLI. [2]
        Urutan: dari yang terbaru (top) ke yang terlama (bottom).
        Big-O: O(n).
        """
        result = []
        curr = self.top
        while curr:
            result.append(curr.data)
            curr = curr.next
        return result

    def is_empty(self) -> bool:
        """Mengecek apakah riwayat alert kosong."""
        return self._size == 0

    def __len__(self):
        """Mengembalikan jumlah alert yang tersimpan saat ini."""
        return self._size