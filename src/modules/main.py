import numpy as np
import time
import random
from typing import Optional, Dict, List, Tuple

from modules.graph import IoTGraph, Device, Alert
from modules.priority_queue import AlertPriorityQueue
from modules.bst_registry import BSTRegistry
from modules.stack import AlertStack
from modules.dijkstra import dijkstra_latensi, reconstruct_path, get_bottleneck_link

def main():
    # Inisialisasi komponen sistem sesuai spesifikasi arsitektur [1]
    graph = IoTGraph()
    bst_reg = BSTRegistry()
    alert_queue = AlertPriorityQueue()
    device_stacks = {} 
    alert_counter = 0

    # Generator data awal menggunakan seed 23 untuk reproducibility [2, 3]
    from modules.generator import generate_iot_network
    devices, edges = generate_iot_network(40, 20, seed=23)

    # Memasukkan data awal ke dalam struktur data [1]
    for d in devices:
        graph.add_device(d)
        bst_reg.insert(d)
        device_stacks[d.device_id] = AlertStack(kapasitas=20)
    
    for u, v, lat in edges:
        graph.add_link(u, v, lat)

    print("==============================================")
    print("   IoT NETWORK MONITORING & ALERT SYSTEM      ")
    print("==============================================")
    print("Ketik 'BANTUAN' untuk melihat daftar perintah.")

    # Implementasi loop CLI interaktif [4, 5]
    while True:
        try:
            # Mengambil input dan memecahnya menjadi argumen [6]
            inp = input("\n[MONITORING]> ").strip().split()
            if not inp:
                continue
            
            cmd = inp.upper()
            args = inp[1:]

            if cmd == "KELUAR":
                print("Mematikan sistem monitoring...")
                break

            elif cmd == "BANTUAN":
                # Daftar perintah sesuai spesifikasi Modul 6 [2]
                print("Perintah Tersedia:")
                print("- ADD_DEVICE <id> <tipe>")
                print("- ADD_LINK <u> <v> <latensi>")
                print("- ALERT_IN <dev_id> <tipe> <pesan>")
                print("- PROCESS_ALERT")
                print("- HISTORY <dev_id>")
                print("- ISOLASI")
                print("- ROUTING <dev_id>")
                print("- AUDIT_LATENSI")
                print("- LAPORAN_JARINGAN")

            elif cmd == "ADD_DEVICE":
                # Menambah perangkat baru ke Graph dan BST [3, 7]
                dev_id, tipe = args, args[4]
                new_dev = Device(dev_id, tipe)
                graph.add_device(new_dev)
                bst_reg.insert(new_dev)
                device_stacks[dev_id] = AlertStack(kapasitas=20)
                print(f"[O(log n)] - Perangkat {dev_id} terdaftar.")

            elif cmd == "ADD_LINK":
                # Menambah koneksi antar perangkat [8]
                u, v, lat = args, args[4], int(args[9])
                graph.add_link(u, v, lat)
                print(f"[O(1)] - Link {u} <-> {v} ({lat}ms) ditambahkan.")

            elif cmd == "ALERT_IN":
                # Input alert baru dengan pemetaan prioritas [2, 10]
                dev_id = args
                a_type_str = args[4].upper()
                msg = " ".join(args[2:])
                
                # Mapping: 1=CRITICAL, 2=WARNING, 3=INFO [2]
                prio_map = {'CRITICAL': 1, 'WARNING': 2, 'INFO': 3}
                prio = prio_map.get(a_type_str, 3)
                
                alert_counter += 1
                new_alert = Alert(alert_counter, dev_id, prio, msg, time.time())
                
                # Masukkan ke Priority Queue global dan Stack riwayat per device [7, 11]
                alert_queue.enqueue(new_alert)
                device_stacks[dev_id].push(new_alert)
                print(f"[O(n)] - Alert {a_type_str} dari {dev_id} diterima.")

            elif cmd == "PROCESS_ALERT":
                # Memproses alert dengan prioritas tertinggi (CRITICAL dulu) [7]
                if not alert_queue.is_empty():
                    proc = alert_queue.dequeue()
                    p_name = {1:'CRITICAL', 2:'WARNING', 3:'INFO'}[proc.tipe]
                    print(f"[O(1)] - MEMPROSES [{p_name}] ID:{proc.alert_id} | Dari: {proc.device_id}")
                    print(f"Pesan: {proc.pesan}")
                else:
                    print("Antrean alert kosong.")

            elif cmd == "HISTORY":
                # Melihat riwayat alert terakhir menggunakan Stack [11]
                dev_id = args
                if dev_id in device_stacks:
                    history = device_stacks[dev_id].to_list()
                    print(f"[O(1)] - Riwayat 20 Alert Terakhir {dev_id}:")
                    for a in history:
                        p_name = {1:'CRITICAL', 2:'WARNING', 3:'INFO'}[a.tipe]
                        print(f"  - [{p_name}] {a.pesan}")
                else:
                    print("ID Perangkat tidak ditemukan.")

            elif cmd == "ISOLASI":
                # Mendeteksi perangkat yang tidak terjangkau dari GATEWAY_0 via DFS [7, 12]
                isolated = graph.isolated_devices('GATEWAY_0')
                print(f"[O(V+E)] - Perangkat Terisolasi:")
                if isolated:
                    print(", ".join(isolated))
                else:
                    print("Semua perangkat terhubung ke GATEWAY_0.")

            elif cmd == "ROUTING":
                # Mencari jalur tercepat menggunakan algoritma Dijkstra [13]
                target = args
                dist, parent = dijkstra_latensi(graph, 'GATEWAY_0')
                if target in dist and dist[target] != float('inf'):
                    path = reconstruct_path(parent, 'GATEWAY_0', target)
                    print(f"[O(V^2 + E)] - Rute Tercepat ke {target}:")
                    print(f"Jalur: {' -> '.join(path)}")
                    print(f"Total Latensi: {dist[target]} ms")
                else:
                    print(f"Perangkat {target} tidak dapat dijangkau secara fisik.")

            elif cmd == "AUDIT_LATENSI":
                # Mengidentifikasi bottleneck link pada shortest path tree [2]
                _, parent = dijkstra_latensi(graph, 'GATEWAY_0')
                edge, lat = get_bottleneck_link(graph, parent)
                if edge:
                    print(f"[O(V^2 + E)] - Audit: Bottleneck pada link {edge} - {edge[4]} ({lat}ms).")
                else:
                    print("Audit gagal: Tidak ada rute aktif.")

            elif cmd == "LAPORAN_JARINGAN":
                # Menampilkan daftar inventaris semua perangkat dari BST [3]
                devices_list = bst_reg.inorder()
                print(f"[O(n)] - Daftar Inventaris Perangkat (Urut ID):")
                for d in devices_list:
                    print(f"ID: {d.device_id:12} | Tipe: {d.tipe:10} | Status: {d.status}")

            else:
                print("Perintah tidak dikenal. Ketik BANTUAN.")

        except Exception as e:
            # Penanganan error standar sesuai pola Goodrich [14, 15]
            print(f"Kesalahan: {e}")

if __name__ == "__main__":
    main()