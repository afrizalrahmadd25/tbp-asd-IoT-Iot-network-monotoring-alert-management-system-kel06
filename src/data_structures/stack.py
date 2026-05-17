import numpy as np
import time
import random
from dataclasses import dataclass
from typing import Optional, List
from linked_list import LLNode

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
class AlertStack:
    def __init__(self, capacity=20):
        self.top = None
        self._size = 0
        self.capacity = capacity

    def push(self, alert: Alert):
        if self._size >= self.capacity:
            # Skenario circular buffer sederhana: hapus bottom jika penuh (opsional)
            pass
        new_node = LLNode(alert)
        new_node.next = self.top
        self.top = new_node
        self._size += 1

    def pop(self):
        if self.top is None: return None
        data = self.top.data
        self.top = self.top.next
        self._size -= 1
        return data