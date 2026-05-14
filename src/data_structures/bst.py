class BSTNode:
def __init__(self, device: Device):
self.device = device
self.left = self.right = None
class BSTRegistry:
def __init__(self): self.root = None
def insert(self, device: Device): pass # TODO
def search(self, device_id: str): pass # TODO
def update_status(self, device_id: str, status: str): pass # TODO
def inorder(self): pass # TODO