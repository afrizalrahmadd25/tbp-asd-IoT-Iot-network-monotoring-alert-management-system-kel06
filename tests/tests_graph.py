import numpy as np
import random
import unittest
from src.modules.graph import IoTGraph, Device

class TestIoTGraph(unittest.TestCase):
    """Unit test untuk memvalidasi struktur data Graph Jaringan IoT."""

    def setUp(self):
        """Inisialisasi graf dan data sampel sebelum pengujian."""
        # Seed 23 digunakan agar hasil pengujian konsisten
        np.random.seed(23)
        random.seed(23)
        
        self.graph = IoTGraph()
        self.dev0 = Device('GATEWAY_0', 'GATEWAY')
        self.dev1 = Device('SENSOR_05', 'SENSOR')
        self.dev2 = Device('SENSOR_06', 'SENSOR')
        self.dev3 = Device('SERVER_01', 'SERVER')

    def test_add_device(self):
        """Menguji apakah perangkat berhasil terdaftar di dalam graf."""
        self.graph.add_device(self.dev0)
        self.graph.add_device(self.dev1)
        
        # Verifikasi keberadaan ID perangkat di adjacency list
        self.assertIn('GATEWAY_0', self.graph.adj)
        self.assertIn('SENSOR_05', self.graph.adj)

    def test_add_link_undirected(self):
        """Menguji penambahan link latensi dan sifat dua arah jaringan."""
        self.graph.add_device(self.dev0)
        self.graph.add_device(self.dev1)
        
        # Menambahkan link antar perangkat (50ms)
        self.graph.add_link('GATEWAY_0', 'SENSOR_05', 50)
        
        # Cek arah A -> B
        neighbors_0 = self.graph.neighbors('GATEWAY_0')
        self.assertTrue(any(dest == 'SENSOR_05' and lat == 50 for dest, lat in neighbors_0))
        
        # Cek arah B -> A (Sifat Undirected)
        neighbors_1 = self.graph.neighbors('SENSOR_05')
        self.assertTrue(any(dest == 'GATEWAY_0' and lat == 50 for dest, lat in neighbors_1))

    def test_neighbors_degree(self):
        """Menguji jumlah tetangga yang terhubung pada satu node."""
        self.graph.add_device(self.dev0)
        self.graph.add_device(self.dev1)
        self.graph.add_device(self.dev2)
        
        self.graph.add_link('GATEWAY_0', 'SENSOR_05', 10)
        self.graph.add_link('GATEWAY_0', 'SENSOR_06', 20)
        
        neighbors = self.graph.neighbors('GATEWAY_0')
        # Total link terhubung harus sama dengan 2
        self.assertEqual(len(neighbors), 2)

    def test_isolation_detection(self):
        """Menguji deteksi perangkat yang kehilangan koneksi ke Gateway."""
        self.graph.add_device(self.dev0)
        self.graph.add_device(self.dev1)
        self.graph.add_link('GATEWAY_0', 'SENSOR_05', 15)
        
        # Perangkat yang tidak memiliki jalur ke GATEWAY_0
        self.graph.add_device(self.dev3) 
        
        isolated = self.graph.isolated_devices('GATEWAY_0')
        
        # SERVER_01 harus terdeteksi terisolasi karena tidak ada link
        self.assertIn('SERVER_01', isolated)
        self.assertNotIn('SENSOR_05', isolated)

if __name__ == '__main__':
    unittest.main()