import numpy as np
import unittest
import time
from src.modules.stack import AlertStack
from src.modules.stack import Alert

class TestAlertStack(unittest.TestCase):
    """
    Unit test untuk memvalidasi Alert History Stack (Modul 4).
    Memastikan mekanisme LIFO dan pembatasan 20 data terakhir.
    """

    def setUp(self):
        """Inisialisasi stack dan seed sebelum setiap pengujian."""
        # Seed 23 wajib sesuai panduan Topik 4
        np.random.seed(23)
        self.kapasitas = 20
        self.stack = AlertStack(kapasitas=self.kapasitas)
        
        # Helper untuk membuat alert sampel
        self.sample_alert = Alert(1, "SENSOR_01", 1, "Kritis", time.time())

    def test_push_dan_pop(self):
        """Menguji operasi dasar LIFO (Goodrich Bab 7.1)."""
        alert1 = Alert(1, "S_01", 1, "Pesan 1", time.time())
        alert2 = Alert(2, "S_01", 2, "Pesan 2", time.time())
        
        self.stack.push(alert1)
        self.stack.push(alert2)
        
        # JAWABAN #TODO: Verifikasi elemen teratas (alert2) keluar duluan
        top_element = self.stack.pop()
        self.assertEqual(top_element.alert_id, 2)
        self.assertEqual(len(self.stack), 1)

    def test_leaky_capacity_limit(self):
        """
        Menguji mekanisme penghapusan elemen tertua jika kapasitas > 20.
        Sesuai spesifikasi Modul 4 #TODO.
        """
        # Memasukkan 21 alert (melebihi kapasitas 20)
        for i in range(1, 22):
            a = Alert(i, "SENSOR_01", 3, f"Alert {i}", time.time())
            self.stack.push(a)
        
        # JAWABAN #TODO: Ukuran stack harus tetap 20
        self.assertEqual(len(self.stack), 20)
        
        # Alert ID 1 (paling lama) harus sudah terhapus
        alerts = self.stack.to_list()
        alert_ids = [a.alert_id for a in alerts]
        self.assertNotIn(1, alert_ids)
        # Alert ID 21 (paling baru) harus ada di posisi paling atas (index 0)
        self.assertEqual(alert_ids, 21)

    def test_to_list_order(self):
        """Menguji apakah urutan riwayat benar dari terbaru ke terlama."""
        a1 = Alert(1, "S_01", 3, "Lama", time.time())
        a2 = Alert(2, "S_01", 1, "Baru", time.time())
        
        self.stack.push(a1)
        self.stack.push(a2)
        
        # Urutan list harus: [Baru, Lama]
        history = self.stack.to_list()
        self.assertEqual(history.alert_id, 2)
        self.assertEqual(history[10].alert_id, 1)

    def test_pop_empty(self):
        """Memastikan pop pada stack kosong mengembalikan None (Safety)."""
        self.assertIsNone(self.stack.pop())

if __name__ == '__main__':
    unittest.main()