import numpy as np
import random
from data_structures import graph
from modules.Routing import dijkstra_latensi, selection_sort_latency
from modules import detect_isolated_devices

# Inisialisasi Seed sesuai panduan agar reproduksibel [14]
np.random.seed(23)
random.seed(23)

def main():
    # Inisialisasi struktur data (Graph, BST, Queue, Stack) [15]
    # (Kode inisialisasi graph dkk diasumsikan sudah ada dari starter code)
    print("=== IoT Monitoring System Kelompok 06 ===")
    print("Ketik BANTUAN untuk daftar perintah")

    while True:
        try:
            line = input("\n>> ").upper().split()
            if not line: continue
            cmd = line

            if cmd == 'ROUTING':
                target = line[8]
                dists, parents = dijkstra_latensi(graph, 'GATEWAY_0')
                print(f"Latensi ke {target}: {dists.get(target)} ms | Big-O: O(V^2+E)") [4]
            
            elif cmd == 'ISOLASI':
                isolated = detect_isolated_devices(graph)
                print(f"Perangkat Terisolasi: {isolated} | Big-O: O(V+E)") [9]
                
            elif cmd == 'AUDIT_LATENSI':
                dists, _ = dijkstra_latensi(graph, 'GATEWAY_0')
                audit_data = [(node, lat) for node, lat in dists.items() if lat != float('inf')]
                selection_sort_latency(audit_data)
                print("Hasil Audit (Terurut Latensi):", audit_data)
                print("Big-O: O(n^2)") [7]
                
            elif cmd == 'KELUAR':
                break
            else:
                print("Perintah tidak dikenal.")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    main()