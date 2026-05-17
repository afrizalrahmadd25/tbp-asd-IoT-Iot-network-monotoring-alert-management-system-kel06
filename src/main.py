import sys
import time
import numpy as np
import random
from dataclasses import dataclass
from typing import Optional, List

sys.path.insert(0, '.')
from data_structures.stack import AlertStack
from data_structures.priority_queue import AlertPriorityQueue
from data_structures.bst_registry import DeviceBST
from graph_network import IoTGraph

np.random.seed(23)
random.seed(23)

# ── Model Data ──────────────────────────────────────────────────────
@dataclass
class Device:
    device_id: str
    tipe: str
    status: str = 'ONLINE'
    last_reading: float = 0.0

@dataclass
class Alert:
    alert_id: int
    device_id: str
    tipe: int          # 1=CRITICAL, 2=WARNING, 3=INFO
    pesan: str
    timestamp: float

TIPE_LABEL = {1: 'CRITICAL', 2: 'WARNING', 3: 'INFO'}

# ── Generate jaringan awal ──────────────────────────────────────────
def generate_network(graph, bst, device_stacks):
    rng = np.random.default_rng(23)
    devices = []
    devices.append(Device('GATEWAY_0', 'GATEWAY'))
    for i in range(1, 5):
        devices.append(Device(f'SERVER_{i}', 'SERVER'))
    for i in range(5, 40):
        devices.append(Device(f'SENSOR_{i}', 'SENSOR',
                               last_reading=float(rng.uniform(0, 100))))
    for d in devices:
        graph.add_device(d)
        bst.insert(d)
        device_stacks[d.device_id] = AlertStack(capacity=20)

    perm = rng.permutation(len(devices))
    for i in range(1, len(devices)):
        u = devices[perm[i-1]].device_id
        v = devices[perm[i]].device_id
        lat = int(rng.integers(5, 200))
        graph.add_link(u, v, lat)

# ── Main CLI ────────────────────────────────────────────────────────
def main():
    graph = IoTGraph()
    bst = DeviceBST()
    alert_queue = AlertPriorityQueue()
    device_stacks = {}
    alert_counter = 0

    generate_network(graph, bst, device_stacks)

    print("=" * 60)
    print("  IoT Network Monitoring & Alert Management System")
    print("  ELT60213 - Kelompok 06 - Teknik Elektro UNY")
    print("=" * 60)
    print("Ketik BANTUAN untuk melihat daftar perintah.\n")

    while True:
        try:
            raw = input(">> ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\n[SISTEM] Program dihentikan.")
            break

        if not raw:
            continue

        parts = raw.upper().split()
        cmd = parts[0]

        # ── BANTUAN ──────────────────────────────────────────────
        if cmd == 'BANTUAN':
            print("""
Daftar Perintah:
  ADD_DEVICE <id> <tipe>         - Tambah perangkat (SENSOR/GATEWAY/SERVER)
  ADD_LINK <u> <v> <latensi>     - Tambah koneksi antar perangkat (ms)
  ALERT_IN <id> <tipe> <pesan>   - Kirim alert (CRITICAL/WARNING/INFO)
  PROCESS_ALERT                  - Proses alert prioritas tertinggi
  PENDING_ALERTS                 - Lihat semua alert dalam antrian
  HISTORY <id>                   - Riwayat alert perangkat
  ROLLBACK_STATUS <id>           - Batalkan alert terakhir perangkat
  CARI_DEVICE <id>               - Cari perangkat di BST
  UPDATE_STATUS <id> <status>    - Update status ONLINE/OFFLINE
  ROUTING <id>                   - Cari rute latensi minimum ke perangkat
  ISOLASI                        - Deteksi perangkat terisolasi
  AUDIT_LATENSI                  - Laporan semua perangkat urut latensi
  LAPORAN_JARINGAN               - Ringkasan kondisi jaringan
  KELUAR                         - Keluar dari program
""")

        # ── ADD_DEVICE ───────────────────────────────────────────
        elif cmd == 'ADD_DEVICE' and len(parts) >= 3:
            dev_id = parts[1]
            tipe = parts[2]
            device = Device(dev_id, tipe)
            graph.add_device(device)
            bst.insert(device)
            device_stacks[dev_id] = AlertStack(capacity=20)
            print(f"[OK] {dev_id} ({tipe}) ditambahkan ke jaringan.")
            print(f"     Big-O: add_device O(1) | BST insert O(log n)")

        # ── ADD_LINK ─────────────────────────────────────────────
        elif cmd == 'ADD_LINK' and len(parts) >= 4:
            u, v = parts[1], parts[2]
            lat = int(parts[3])
            graph.add_link(u, v, lat)
            print(f"[OK] Link {u} <-> {v} ditambahkan | latensi={lat}ms")
            print(f"     Big-O: add_link O(1)")

        # ── ALERT_IN ─────────────────────────────────────────────
        elif cmd == 'ALERT_IN' and len(parts) >= 4:
            dev_id = parts[1]
            tipe_str = parts[2]
            pesan = ' '.join(raw.split()[3:])
            tipe_map = {'CRITICAL': 1, 'WARNING': 2, 'INFO': 3}
            tipe = tipe_map.get(tipe_str, 3)
            alert_counter += 1
            alert = Alert(alert_counter, dev_id, tipe, pesan, time.time())
            alert_queue.enqueue(alert)
            if dev_id in device_stacks:
                device_stacks[dev_id].push(alert)
            print(f"[ALERT] {TIPE_LABEL[tipe]} dari {dev_id}: {pesan}")
            print(f"        Posisi antrian: {alert_queue._size} | Big-O: enqueue O(n)")

        # ── PROCESS_ALERT ────────────────────────────────────────
        elif cmd == 'PROCESS_ALERT':
            alert = alert_queue.dequeue()
            if alert:
                print(f"[PROSES] {TIPE_LABEL[alert.tipe]} dari {alert.device_id}")
                print(f"         Pesan: {alert.pesan}")
                print(f"         Big-O: dequeue O(1)")
                bst.update_status(alert.device_id, 'HANDLED')
            else:
                print("[INFO] Tidak ada alert dalam antrian.")

        # ── PENDING_ALERTS ───────────────────────────────────────
        elif cmd == 'PENDING_ALERTS':
            alerts = alert_queue.to_list()
            if not alerts:
                print("[INFO] Antrian kosong.")
            else:
                print(f"[ANTRIAN] {len(alerts)} alert pending:")
                for i, a in enumerate(alerts, 1):
                    print(f"  {i}. [{TIPE_LABEL[a.tipe]}] {a.device_id} - {a.pesan}")

        # ── HISTORY ──────────────────────────────────────────────
        elif cmd == 'HISTORY' and len(parts) >= 2:
            dev_id = parts[1]
            if dev_id in device_stacks:
                history = device_stacks[dev_id].to_list()
                if history:
                    print(f"[RIWAYAT] {dev_id} ({len(history)} alert):")
                    for a in history:
                        print(f"  [{TIPE_LABEL[a.tipe]}] {a.pesan}")
                else:
                    print(f"[INFO] {dev_id} belum memiliki riwayat alert.")
                print(f"  Big-O: to_list O(n)")
            else:
                print(f"[ERROR] Perangkat {dev_id} tidak ditemukan.")

        # ── ROLLBACK_STATUS ──────────────────────────────────────
        elif cmd == 'ROLLBACK_STATUS' and len(parts) >= 2:
            dev_id = parts[1]
            if dev_id in device_stacks:
                alert = device_stacks[dev_id].pop()
                if alert:
                    bst.update_status(dev_id, 'ONLINE')
                    print(f"[ROLLBACK] Alert terakhir {dev_id} dibatalkan.")
                    print(f"           Status dikembalikan ke ONLINE.")
                    print(f"           Big-O: pop O(1)")
                else:
                    print(f"[INFO] Tidak ada alert untuk di-rollback.")

        # ── CARI_DEVICE ──────────────────────────────────────────
        elif cmd == 'CARI_DEVICE' and len(parts) >= 2:
            dev_id = parts[1]
            device = bst.search(dev_id)
            if device:
                print(f"[DITEMUKAN] {device.device_id} | Tipe: {device.tipe} | Status: {device.status}")
                print(f"            Big-O: BST search O(log n)")
            else:
                print(f"[NOT FOUND] {dev_id} tidak ada di registry.")

        # ── UPDATE_STATUS ────────────────────────────────────────
        elif cmd == 'UPDATE_STATUS' and len(parts) >= 3:
            dev_id, status = parts[1], parts[2]
            if bst.update_status(dev_id, status):
                print(f"[OK] Status {dev_id} diperbarui menjadi {status}.")
                print(f"     Big-O: BST search + update O(log n)")
            else:
                print(f"[ERROR] {dev_id} tidak ditemukan.")

        # ── ROUTING ──────────────────────────────────────────────
        elif cmd == 'ROUTING' and len(parts) >= 2:
            target = parts[1]
            INF = float('inf')
            dist = {v: INF for v in graph.adj}
            parent = {v: None for v in graph.adj}
            visited = set()
            dist['GATEWAY_0'] = 0
            for _ in range(len(graph.adj)):
                u = min((v for v in graph.adj if v not in visited), key=lambda v: dist[v], default=None)
                if u is None or dist[u] == INF:
                    break
                visited.add(u)
                for nb, lat in graph.neighbors(u):
                    if dist[u] + lat < dist[nb]:
                        dist[nb] = dist[u] + lat
                        parent[nb] = u
            if dist.get(target, INF) == INF:
                print(f"[ERROR] {target} tidak terjangkau dari GATEWAY_0.")
            else:
                path, cur = [], target
                while cur:
                    path.append(cur)
                    cur = parent[cur]
                path.reverse()
                print(f"[RUTE] {'  ->  '.join(path)}")
                print(f"       Total latensi: {dist[target]} ms")
                print(f"       Big-O: Dijkstra O(V²+E)")

        # ── ISOLASI ──────────────────────────────────────────────
        elif cmd == 'ISOLASI':
            isolated = graph.isolated_devices('GATEWAY_0')
            if isolated:
                print(f"[PERINGATAN] {len(isolated)} perangkat TERISOLASI:")
                for d in isolated:
                    print(f"  - {d}")
            else:
                print("[OK] Semua perangkat terjangkau dari GATEWAY_0.")
            print(f"     Big-O: DFS O(V+E)")

        # ── AUDIT_LATENSI ────────────────────────────────────────
        elif cmd == 'AUDIT_LATENSI':
            INF = float('inf')
            dist = {v: INF for v in graph.adj}
            visited = set()
            dist['GATEWAY_0'] = 0
            for _ in range(len(graph.adj)):
                u = min((v for v in graph.adj if v not in visited), key=lambda v: dist[v], default=None)
                if u is None or dist[u] == INF:
                    break
                visited.add(u)
                for nb, lat in graph.neighbors(u):
                    if dist[u] + lat < dist[nb]:
                        dist[nb] = dist[u] + lat
            # Selection Sort pada list
            items = [(d, dist[d]) for d in dist if dist[d] < INF]
            for i in range(len(items)):
                min_idx = i
                for j in range(i+1, len(items)):
                    if items[j][1] < items[min_idx][1]:
                        min_idx = j
                items[i], items[min_idx] = items[min_idx], items[i]
            print(f"[AUDIT] Perangkat urut latensi dari GATEWAY_0:")
            for d, lat in items[:10]:
                print(f"  {d:20s} : {lat} ms")
            print(f"  ... (total {len(items)} perangkat)")
            print(f"  Big-O: Dijkstra O(V²+E) + Selection Sort O(n²)")

        # ── LAPORAN_JARINGAN ─────────────────────────────────────
        elif cmd == 'LAPORAN_JARINGAN':
            all_devices = bst.inorder()
            online = sum(1 for d in all_devices if d.status == 'ONLINE')
            offline = sum(1 for d in all_devices if d.status == 'OFFLINE')
            sensors = sum(1 for d in all_devices if d.tipe == 'SENSOR')
            gateways = sum(1 for d in all_devices if d.tipe == 'GATEWAY')
            servers = sum(1 for d in all_devices if d.tipe == 'SERVER')
            print(f"""
[LAPORAN JARINGAN]
  Total perangkat : {len(all_devices)}
  Sensor          : {sensors}
  Gateway         : {gateways}
  Server          : {servers}
  Status Online   : {online}
  Status Offline  : {offline}
  Alert pending   : {alert_queue._size}
  Big-O: BST inorder O(n)
""")

        # ── KELUAR ───────────────────────────────────────────────
        elif cmd == 'KELUAR':
            print("[SISTEM] Terima kasih. Program selesai.")
            break

        else:
            print(f"[ERROR] Perintah '{raw}' tidak dikenal. Ketik BANTUAN.")

if __name__ == '__main__':
    main()