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
class BSTNode:
    def __init__(self, device: Device):
        self.device = device
        self.left = None
        self.right = None

class DeviceBST:
    def __init__(self):
        self.root = None

    def insert(self, device: Device):
        self.root = self._insert_recursive(self.root, device)

    def _insert_recursive(self, node, device):
        if node is None: return BSTNode(device)
        if device.device_id < node.device.device_id:
            node.left = self._insert_recursive(node.left, device)
        else:
            node.right = self._insert_recursive(node.right, device)
        return node

    def search(self, device_id: str) -> Optional[Device]:
        curr = self.root
        while curr:
            if curr.device.device_id == device_id: return curr.device
            curr = curr.left if device_id < curr.device.device_id else curr.right
        return None