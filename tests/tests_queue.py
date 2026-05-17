import numpy as np
import unittest
import time
from src.modules.priority_queue import AlertPriorityQueue
from src.modules.priority_queue import Alert

class TestAlertPriorityQueue(unittest.TestCase):
    """
    Unit test untuk memvalidasi Priority Queue pada sistem monitoring IoT.
    Memastikan alert kritis diproses lebih dahulu sesuai spesifikasi Modul 2.
    """

    def setUp(self):
        """Inisialisasi antrian dan penetapan seed sebelum pengujian."""
        # Seed 23 wajib sesuai panduan Topik 4
        np.random.seed(23)
        self.pq = AlertPriorityQueue()
        
        # Sampel data alert (ID, Device_ID, Tipe, Pesan, Timestamp)
        # Tipe: 1=CRITICAL, 2=WARNING, 3=INFO
        self.a_info = Alert(1, "SENSOR_01", 3, "Suhu normal", time.time())
        self.a_warn = Alert(2, "SENSOR_02", 2, "Tegangan naik", time.time())
        self.a_crit = Alert(3, "GATEWAY_0", 1, "Koneksi terputus!", time.time())

    def test_enqueue_priority_sorting(self):
        """
        Menguji apakah elemen disisipkan pada posisi yang benar berdasarkan prioritas.
        Big-O: O(n) untuk penyisipan terurut.
        """
        # Memasukkan alert dengan urutan acak
        self.pq.enqueue(self.a_info) # Prioritas 3
        self.pq.enqueue(self.a_crit) # Prioritas 1 (Harus ke depan)
        self.pq.enqueue(self.a_warn) # Prioritas 2 (Harus di tengah)

        # Verifikasi: Head harus merupakan alert CRITICAL (1)
        # Sesuai prinsip Goodrich: elemen dengan kunci terkecil (1) berada di depan
        self.assertEqual(self.pq.head.data.tipe, 1)
        self.assertEqual(self.pq.head.next.data.tipe, 2)
        self.assertEqual(len(self.pq), 3)

    def test_dequeue_order(self):
        """
        Menguji pengambilan alert (dequeue) dari depan antrian.
        Big-O: O(1) untuk pengambilan head.
        """
        self.pq.enqueue(self.a_info)
        self.pq.enqueue(self.a_crit)

        # Dequeue pertama harus mendapatkan alert CRITICAL
        processed = self.pq.dequeue()
        self.assertEqual(processed.tipe, 1)
        self.assertEqual(processed.device_id, "GATEWAY_0")
        
        # Sisa antrian harus 1 (INFO)
        self.assertEqual(len(self.pq), 1)
        self.assertEqual(self.pq.head.data.tipe, 3)

    def test_empty_queue_behavior(self):
        """Menguji keamanan operasi pada antrian kosong."""
        self.assertTrue(self.pq.is_empty())
        self.assertIsNone(self.pq.dequeue())

    def test_tie_break_fifo(self):
        """
        Menguji aturan tie-break: jika prioritas sama, gunakan urutan kedatangan (FIFO).
        """
        crit_1 = Alert(4, "SENSOR_A", 1, "Kritis A", time.time())
        time.sleep(0.01) # Jeda singkat untuk membedakan waktu
        crit_2 = Alert(5, "SENSOR_B", 1, "Kritis B", time.time())

        self.pq.enqueue(crit_1)
        self.pq.enqueue(crit_2)

        # Kritis A yang masuk duluan harus keluar duluan
        first = self.pq.dequeue()
        self.assertEqual(first.alert_id, 4)

if __name__ == '__main__':
    unittest.main()