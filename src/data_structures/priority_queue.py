import numpy as np
import time
import random
from dataclasses import dataclass
from typing import Optional, List
from data_structures import linked_list

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
class AlertPriorityQueue:
    def __init__(self):
        self.head: Optional[linked_list.LLNode] = None
        self._size = 0

    def enqueue(self, alert: Alert):
        """Big-O: O(n) - Sisipkan berdasarkan prioritas ASC [6]."""
        new_node = linked_list.LLNode(alert)
        if not self.head or alert.tipe < self.head.data.tipe:
            new_node.next = self.head
            self.head = new_node
        else:
            curr = self.head
            while curr.next and curr.next.data.tipe <= alert.tipe:
                curr = curr.next
            new_node.next = curr.next
            curr.next = new_node
        self._size += 1

    def dequeue(self):
        """Big-O: O(1) [6]."""
        if not self.head: return None
        target = self.head.data
        self.head = self.head.next
        self._size -= 1
        return target
    def to_list(self):
        """Mengonversi isi antrian (Linked List) menjadi list Python untuk ditampilkan."""
        result = []
        curr = self.head
        while curr:
            result.append(curr.data) # Mengambil objek Alert dari dalam Node
            curr = curr.next
        return result