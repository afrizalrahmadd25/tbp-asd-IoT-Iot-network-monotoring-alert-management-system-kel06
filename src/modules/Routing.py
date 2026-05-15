def dijkstra_latensi(graph: IoTGraph, source: str
) -> Tuple[Dict[str,int], Dict[str,Optional[str]]]:
"""
Shortest path berdasarkan latensi dari source ke semua node.
Big-O: O(V^2 + E) dengan array sederhana.
"""
INF = float('inf')
dist = {v: INF for v in graph.adj}
parent = {v: None for v in graph.adj}
visited = set()
dist[source] = 0
# TODO: implementasikan
return dist, parent