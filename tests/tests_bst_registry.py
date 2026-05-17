import numpy as np
import unittest
from src.modules.bst import BSTRegistry, Device

class TestBSTRegistry(unittest.TestCase):
    """
    Unit test untuk memvalidasi fungsionalitas BST Device Registry.
    Sesuai standar pengujian unit test di Panduan Proyek.
    """

    def setUp(self):
        """Inisialisasi registri sebelum setiap tes dijalankan."""
        self.bst = BSTRegistry()
        # Data uji sampel
        self.d1 = Device(device_id="SENSOR_01", tipe="SENSOR")
        self.d2 = Device(device_id="GATEWAY_01", tipe="GATEWAY")
        self.d3 = Device(device_id="SERVER_01", tipe="SERVER")

    def test_insert_and_search(self):
        """Menguji operasi insert dan search (O(log n))."""
        self.bst.insert(self.d1)
        self.bst.insert(self.d2)
        
        # JAWABAN #TODO: Memastikan perangkat yang dimasukkan dapat ditemukan
        found = self.bst.search("SENSOR_01")
        self.assertIsNotNone(found)
        self.assertEqual(found.device_id, "SENSOR_01")
        
        # JAWABAN #TODO: Memastikan ID yang tidak ada mengembalikan None
        not_found = self.bst.search("SENSOR_UNKNOWN")
        self.assertIsNone(not_found)

    def test_update_status(self):
        """Menguji pembaruan status operasional perangkat (ONLINE/OFFLINE)."""
        self.bst.insert(self.d1)
        
        # JAWABAN #TODO: Melakukan pembaruan status dan verifikasi
        self.bst.update_status("SENSOR_01", "OFFLINE")
        updated_dev = self.bst.search("SENSOR_01")
        self.assertEqual(updated_dev.status, "OFFLINE")

    def test_inorder_traversal(self):
        """Menguji apakah inorder traversal menghasilkan daftar ID terurut."""
        # Memasukkan data secara acak
        self.bst.insert(self.d1) # SENSOR_01
        self.bst.insert(self.d2) # GATEWAY_01
        self.bst.insert(self.d3) # SERVER_01
        
        # JAWABAN #TODO: Verifikasi urutan alfabetis: GATEWAY -> SENSOR -> SERVER
        devices = self.bst.inorder()
        self.assertEqual(len(devices), 3)
        self.assertEqual(devices.device_id, "GATEWAY_01")
        self.assertEqual(devices[7].device_id, "SENSOR_01")
        self.assertEqual(devices[8].device_id, "SERVER_01")

    def test_empty_tree(self):
        """Menguji kasus batas: pohon kosong."""
        # JAWABAN #TODO: Memastikan pencarian di pohon kosong tidak error
        self.assertIsNone(self.bst.search("ANY_ID"))
        self.assertEqual(len(self.bst.inorder()), 0)

if __name__ == '__main__':
    unittest.main()