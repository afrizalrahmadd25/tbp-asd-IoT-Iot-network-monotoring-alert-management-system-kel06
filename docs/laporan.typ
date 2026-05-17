#set document(
  title: "IoT Monitoring & Alert Management System",
  author: "Kelompok 6",
  date: datetime.today(),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
)

#set text(
  size: 12pt,
  font: "STIX Two Text",
)

#set heading(numbering: (..nums) => {
  let n = nums.pos()
  let level = n.len()
  
  if level == 2 { numbering("I.", n.at(1)) }
  else if level == 3 { numbering("A.", n.at(2)) }
  else if level == 4 { numbering("1.", n.at(3)) }
  else if level == 5 { numbering("a.", n.at(4)) }
  else if level == 6 { numbering("1)", n.at(5)) }
  else if level == 7 { numbering("a)", n.at(6)) }
  else if level == 8 { numbering("(1)", n.at(7)) }
  else if level == 9 { numbering("(a)", n.at(8)) }
})

#show heading: it => {
  set text(size: 12pt, weight: "bold")
  
  if it.level == 1 {
    block(upper(it.body))
  } else if it.level == 2 {
    upper(it)
  } else {
    let indent_size = (it.level - 2) * 1em
    pad(left: indent_size, it)
  }
}

#show par: it => {
  let level = counter(heading).get().len()

  let indent_size = if level >= 3 {
    (level - 2) * 1em
  } else {
    0em
  }

  pad(left: indent_size, it)
}

#let raise_to(num, raise, round: 2) = {
  [$#calc.round(num*(calc.pow(10,raise)), digits:round) times 10^(-#raise)$]

}

#align(center)[
  #text(16pt)[
    *IoT MONITORING & ALERT MANAGEMENT SYSTEM*
  ] \ \ \ \
  #text(14pt)[
    *Algoritma dan Struktur Data* \ Dosen Pengampu: Dr.Eng. Ir.  Aji Ery Burhandenny, ST., M.AIT.
  ] \ \ \ \

  #image("pics/logo_uny-removebg-preview.png",width: 40%)\ \ \

  #text(12pt)[
    Disusun Oleh: \ Aisyah Adielya Zahra (25051030026) \ Afrizal Rahmad Dani (25051030002) \ Muhammad Hanafi Aqillah Gustyawan (25051030004) \ Yafi Dwi Pramuaji (25051030028)
  ] \ \ \ \
  #text(16pt)[
    *PROGRAM STUDI TEKNIK ELEKTRO \ DEPARTEMEN PENDIDIKAN TEKNIK ELEKTRO \ FAKULTAS TEKNIK \ UNIVERSITAS NEGERI YOGYAKARTA \ YOGYAKARTA*
  ] \
  #text(14pt)[
    2026
  ]
]

#pagebreak()
#set page(numbering: "i")
#counter(page).update(1)
#set outline(title: "")
#align(center)[
  = DAFTAR ISI
]
#outline()

#pagebreak()
#counter(page).update(1)
#set page(numbering: "1")
#align(center)[
  = BAB I \ PENDAHULUAN
]

=== Latar Belakang
=== Rumusan Masalah
#par(justify: true)[
  $wide$Berdasarkan latar belakang yang telah diuraikan, permasalahan yang diangkat dalam proyek ini adalah sebagai berikut:
]
#set enum(numbering: "1.", indent: 2em)
+ Bagaimana merepresentasikan topologi jaringan IoT yang terdiri dari 40 device dan 60 edge berbobot menggunakan struktur data graph adjacency list, sehingga memungkinkan operasi penambahan, penghapusan, dan pencarian tetangga secara efisien?
+ Bagaimana mengimplementasikan sistem antrian alert dengan mekanisme priority queue berbasis linked list yang mampu mengurutkan alert berdasarkan tingkat prioritas (CRITICAL, WARNING, INFO) secara otomatis saat proses enqueue?
+ Bagaimana merancang registry perangkat menggunakan struktur data BST yang memungkinkan pencarian, penambahan, dan pembarahan status device berdasarkan device_id dengan kompleksitas waktu yang optimal?
+ Bagaimana mengintegrasikan seluruh modul data structures dan algoritma (graph, BST, priority queue, stack, Dijkstra, selection sort) ke dalam satu interface CLI yang berfungsi sebagai sistem monitoring dan manajemen alert jaringan IoT secara menyeluruh?

=== Tujuan
#par(justify: true)[
  $wide$Berdasarkan rumusan masalah, disimpulkan tujuan dari penelitian ini adalah sebagai berikut:
]
#set enum(numbering: "1.", indent: 2em)
+ Mengetahui bagaimana merepresentasikan topologi jaringan IoT yang terdiri dari 40 device dan 60 edge berbobot menggunakan struktur data graph adjacency list, sehingga memungkinkan operasi penambahan, penghapusan, dan pencarian tetangga secara efisien.
+ Mengetahui bagaimana mengimplementasikan sistem antrian alert dengan mekanisme priority queue berbasis linked list yang mampu mengurutkan alert berdasarkan tingkat prioritas (CRITICAL, WARNING, INFO) secara otomatis saat proses enqueue.
+ Mengetahui bagaimana merancang registry perangkat menggunakan struktur data BST yang memungkinkan pencarian, penambahan, dan pembarahan status device berdasarkan device_id dengan kompleksitas waktu yang optimal.
+ Mengetahui bagaimana mengintegrasikan seluruh modul data structures dan algoritma (graph, BST, priority queue, stack, Dijkstra, selection sort) ke dalam satu interface CLI yang berfungsi sebagai sistem monitoring dan manajemen alert jaringan IoT secara menyeluruh.

=== Batasan Masalah
#set enum(numbering: "1.", indent: 2em)
+ Jumlah device dalam simulasi dibatasi maksimal 40 node dengan komposisi tetap: 1 unit gateway, 4 unit server, dan 35 unit sensor, dengan 60 edge berbobot yang menghubungkan antar device dengan rentang latensi 5-200 ms.
+ Implementasi seluruh struktur data (linked list, stack, queue, priority queue, BST, graph) wajib dibangun dari nol tanpa menggunakan library bawaan Python seperti collections.deque, queue.PriorityQueue, atau struktur data built-in lainnya; numpy hanya diperbolehkan untuk random seed.
+ Sistem hanya menyediakan interface berbasis command line (CLI) tanpa graphical user interface (GUI), dengan seed random tetap (np.random.seed(23) dan random.seed(23)) untuk memastikan reproducibility data uji.
+ Riwayat alert per device dibatasi maksimal 20 entri terakhir menggunakan struktur data stack, dengan mekanisme rollback status device berdasarkan alert history yang tersimpan.

#pagebreak()
#align(center)[
  = BAB II \ LANDASAN TEORI
]

=== Linked List
#set par(justify: true, first-line-indent: 2em)
$wide$Linked list adalah struktur data linear yang menyimpan data dalam bentuk node yang saling terhubung melalui _pointer_ atau _reference_ (GeeksforGeeks, n.d.). Dalam struktur ini, setiap node biasanya berisi data dan alamat memori dari node berikutnya (GeeksforGeeks, n.d.)
=== Stack
=== Queue
=== Binary Search Tree
=== Graph
=== Dijkstra Algorithm

#pagebreak()
#align(center)[
  = BAB III \ DESAIN DAN IMPLEMENTASI
]


=== Arsitektur Sistem
=== Desain Modul
=== Pseudocode

#pagebreak()
#align(center)[
  = BAB IV \ HASIL DAN PEMBAHASAN
]


=== Hasil
=== Pembahasan

#pagebreak()
#align(center)[
  = BAB V \ KESIMPULAN DAN SARAN
]


=== Kesimpulan
=== Saran

#pagebreak()
#align(center)[
  = DAFTAR PUSTAKA
]

\
#set par(justify: true, hanging-indent: 2em)
GeeksforGeeks. (n.d.). _Difference between singly linked list and doubly linked list_. https://www.geeksforgeeks.org/dsa/difference-between-singly-linked-list-and-doubly-linked-list/

GeeksforGeeks. (n.d.). _Stack data structure_. https://www.geeksforgeeks.org/dsa/stack-data-structure/

Ghazal, M., & Hamouda, S. (n.d.). _An IoT smart queue management system with real-time_. Semanticscholar. https://www.semanticscholar.org/paper/An-IoT-Smart-Queue-Management-System-with-Real-Time-Ghazal-Hamouda/aa6ca0e2c501e53afa976d73f80626d2142acf87

Leveraging priority queueing in IoT-edge-fog-cloud computing systems. (2025). _IEEE_. https://ieeexplore.ieee.org/iel8/6287639/10820123/10979951.pdf

Munir, R. (2021). _BFS dan DFS (Bagian 1)_. Informatika STEI ITB. https://informatika.stei.itb.ac.id/~rinaldi.munir/Stmik/2020-2021/BFS-DFS-2021-Bag1.pdf

Munir, R. (2007). _Penerapan algoritma Dijkstra dalam pengalokasian bandwidth_. Informatika STEI ITB. https://informatika.stei.itb.ac.id/~rinaldi.munir/Matdis/2006-2007/Makalah/Makalah0607-35.pdf

Recent advances in Internet of Things solutions for early warning systems: A review. (2022). _Sensors_, 22(6). https://pmc.ncbi.nlm.nih.gov/articles/PMC8954208/

Scientific Reports. (2025). _Developing real-time IoT-based public safety alert and emergency response systems_. Nature. https://www.nature.com/articles/s41598-025-13465-7

Scientific Reports. (2025). _Dijkstra's shortest path algorithm_. Nature. https://www.nature.com/articles/s41598-025-13983-4

TutorialsPoint. (n.d.). _Time and space complexity analysis of queue operations_. https://www.tutorialspoint.com/article/time-and-space-complexity-analysis-of-queue-operations