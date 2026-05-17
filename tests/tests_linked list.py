import numpy as np
import unittest
from src.data_structures.linked_list import SinglyLinkedList

class TestSinglyLinkedList(unittest.TestCase):
    """Unit test untuk memvalidasi struktur data dasar Singly Linked List."""

    def setUp(self):
        """Inisialisasi list dan penetapan seed sebelum pengujian."""
        # Seed 23 wajib sesuai panduan Topik 4 untuk konsistensi
        np.random.seed(23)
        self.ll = SinglyLinkedList()

    def test_penambahan_head(self):
        """Menguji efisiensi penyisipan elemen di bagian depan list."""
        self.ll.add_first("GATEWAY_0")
        self.assertEqual(self.ll.head.data, "GATEWAY_0")
        
        self.ll.add_first("SENSOR_01")
        # Berdasarkan prinsip LIFO, elemen terbaru harus menjadi head
        self.assertEqual(self.ll.head.data, "SENSOR_01")
        self.assertEqual(self.ll.head.next.data, "GATEWAY_0")

    def test_status_dan_ukuran(self):
        """Menguji keakuratan penghitung jumlah elemen (size)."""
        self.assertTrue(self.ll.is_empty())
        self.assertEqual(len(self.ll), 0)
        
        self.ll.add_first("TEST_DEVICE")
        self.assertFalse(self.ll.is_empty())
        self.assertEqual(len(self.ll), 1)

    def test_pencarian_data(self):
        """Menguji mekanisme traversal hopping node untuk mencari data."""
        perangkat = ["SENSOR_A", "SENSOR_B", "SERVER_01"]
        for p in perangkat:
            self.ll.add_first(p)
            
        # Proses pencarian linear dengan melompat antar node
        curr = self.ll.head
        ditemukan = False
        while curr is not None:
            if curr.data == "SENSOR_B":
                ditemukan = True
                break
            curr = curr.next
            
        self.assertTrue(ditemukan)

    def test_penghapusan_elemen(self):
        """Menguji fungsi remove_first untuk mengambil data dari head."""
        self.ll.add_first("DATA_LAMA")
        self.ll.add_first("DATA_BARU")
        
        # Menghapus head dan menggeser pointer ke node berikutnya
        removed_val = self.ll.remove_first()
        self.assertEqual(removed_val, "DATA_BARU")
        self.assertEqual(self.ll.head.data, "DATA_LAMA")
        self.assertEqual(len(self.ll), 1)

if __name__ == '__main__':
    unittest.main()