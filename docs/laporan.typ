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

#let ind(body) = par(justify: true, first-line-indent: (amount: 2em, all: true))[#body]

#show list.item: set par(justify: true)
#set list(indent: 2em, body-indent: 1em, marker: ([•], [◦], [▪], [▫]))

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
#set par(justify: true)
#ind[
  Linked list adalah struktur data linear yang menyimpan data dalam bentuk node yang saling terhubung melalui _pointer_ atau _reference_ (GeeksforGeeks, n.d.). Dalam struktur ini, setiap node biasanya berisi data dan alamat memori dari node berikutnya (GeeksforGeeks, n.d.). Karena node dialokasikan secara dinamis, linked list sangat cocok untuk menangani data yang ukurannya berubah-ubah dan tidak memerlukan akses acak seperti pada array (Scientific Reports, 2025).
]
#ind[
  Beberapa karakteristik utama dari linked list meliputi:
]
#set enum(numbering: "1.", indent: 2em)
+ Kapasitasnya dapat bertambah atau berkurang dengan mudah saat program berjalan (TutorialsPoint, n.d.).
+ Elemen-elemen diakses satu per satu secara berurutan, bukan melalui indeks langsung (GeeksforGeeks, n.d.).
+ Operasi penyisipan (_insert_) dan penghapusan (_delete_) dapat dilakukan secara efisien jika posisi node sudah diketahui, meskipun pencarian tetap memerlukan penelusuran linear (GeeksforGeeks, n.d.).
+ Penggunaan memori lebih besar dibandingkan struktur data sederhana karena setiap node harus menyimpan pointer tambahan (TutorialsPoint, n.d.).
#ind[
  Berdasarkan cara penghubungannya, linked list dibedakan menjadi dua jenis utama. Pertama, Singly Linked List (SLL). Setiap node hanya memiliki data dan satu pointer yang menunjuk ke node berikutnya, sehingga penelusuran (traversal) hanya bisa dilakukan dalam satu arah (GeeksforGeeks, n.d.). Struktur ini lebih hemat memori namun memiliki keterbatasan jika operasi memerlukan akses ke node sebelumnya (GeeksforGeeks, n.d.). Kedua, Doubly Linked List (DLL). Setiap node memiliki dua pointer, yaitu penunjuk ke node berikutnya dan ke node sebelumnya (GeeksforGeeks, n.d.). Hal ini memungkinkan penelusuran dilakukan dua arah, yang memberikan fleksibilitas lebih besar untuk operasi di tengah atau di ujung list, meski membutuhkan memori lebih besar untuk menyimpan pointer tambahan (GeeksforGeeks, n.d.).
]
#ind[
  Secara umum, efisiensi operasi pada linked list adalah sebagai berikut:
]
- Akses atau pencaarian elemen, $O(n)$ karena sistem harus menelusuri node satu per satu dari awal (TutorialsPoint, n.d.).
- Penyisipan (_insert_) di depan, $O(1)$ (GeeksforGeeks, n.d.).- Penyisipan (_insert_) di belakang, $O(1)$ jika menggunakan pointer tail, namun menjadi $O(n)$ jika harus menelusuri dari awal hingga akhir (GeeksforGeeks, n.d.).
- Penghapusan (_delete_) node tertentu, $O(n)$, karena biasanya diperlukan pencarian node target terlebih dahulu (TutorialsPoint, n.d.).
- Penelusuran (_traversal_), $O(n)$ untuk mengunjungi seluruh node (GeeksforGeeks, n.d.).

=== Stack
#ind[
  Stack adalah struktur data linear yang mengikuti prinsip LIFO (_Last In, First Out_), yang berarti elemen yang terakhir masuk akan menjadi elemen pertama yang keluar. Konsep ini juga sering disebut dengan istilah FILO (_First In, Last Out_) (GeeksforGeeks, n.d.). Dalam konteks sistem monitoring IoT, stack sangat berguna untuk mengelola data seperti riwayat alert, di mana informasi terbaru sering kali menjadi prioritas untuk diakses terlebih dahulu.
]
#ind[
  Operasi pada stack sangat efisien karena penambahan dan penghapusan data hanya dilakukan pada satu ujung yang disebut sebagai top (GeeksforGeeks, n.d.). Berikut adalah rincian kompleksitas waktunya:
]
- Push, menambahkan elemen ke puncak tumpukan dengan kompleksitas $O(1)$ (GeeksforGeeks, n.d.).
- Pop, menghapus elemen dari puncak tumpukan dengan kompleksitas $O(1)$ (GeeksforGeeks, n.d.)
- Peek/Top, melihat elemen yang berada di posisi teratas tanpa menghapusnya dengan kompleksitas $O(1)$ (GeeksforGeeks, n.d.)
- Is_empty, emeriksa apakah tumpukan dalam keadaan kosong dengan kompleksitas $O(1)$ (GeeksforGeeks, n.d.).

#ind[
  Stack digunakan dalam berbagai skenario komputasi di mana sistem perlu memproses data dengan urutan kebalikan dari urutan masuk (GeeksforGeeks, n.d.). Beberapa aplikasi utamanya meliputi:
]
- Manajemen pemanggilan fungsi \ Digunakan untuk mengelola function call dan proses rekursi pada program (GeeksforGeeks, n.d.).
- Evaluasi ekspresi \ Membantu dalam evaluasi ekspresi matematika serta konversi antara format infix, postfix, dan prefix (GeeksforGeeks, n.d.).
- Pemeriksaan simbol \ Digunakan untuk memverifikasi keseimbangan tanda kurung atau simbol dalam kode (GeeksforGeeks, n.d.).
- Fitur _undo_ \ Menjadi dasar fungsionalitas pembatalan perintah (undo) pada berbagai aplikasi editor (GeeksforGeeks, n.d.).
- Algoritma graf\ Menjadi komponen penting dalam mekanisme backtracking dan algoritma penelusuran Depth-First Search (DFS) (GeeksforGeeks, n.d.).

=== Queue (Antrean)
#ind[
  Queue adalah struktur data linear yang beroperasi berdasarkan prinsip FIFO (First In, First Out), yang berarti elemen yang pertama kali dimasukkan ke dalam sistem akan menjadi elemen pertama yang dikeluarkan atau diproses (Queue-it, n.d.). Struktur ini sangat efektif untuk mengelola urutan proses yang harus berjalan secara adil sesuai waktu kedatangannya, mirip dengan sistem antrean pada layanan publik (Medium, n.d.). Antrean ini memiliki dua titik akses utama yang membedakannya dari struktur data lainnya (Medium, n.d.):
]
- Front \ Ujung depan tempat elemen diambil atau dihapus dari antrean (operasi _dequeue_).
- Rear \ Ujung belakang tempat elemen baru ditambahkan ke dalam antrean (operasi _enqueue_).

#ind[Dalam sistem monitoring modern, dikembangkan variasi yang disebut Priority Queue. Struktur ini tidak hanya mempertimbangkan urutan masuk, tetapi juga memberikan bobot pada urgensi setiap data. Dalam implementasi sistem alert IoT, elemen dengan prioritas tinggi (seperti peringatan bahaya kritis) akan diproses lebih dahulu oleh sistem meskipun elemen tersebut masuk lebih lambat dibandingkan data sensor rutin lainnya (Ghazal & Hamouda, n.d.).]

#ind[Efisiensi waktu merupakan aspek krusial dalam pengelolaan antrean real-time. Berdasarkan analisis kompleksitas, operasi utama pada queue adalah sebagai berikut (TutorialsPoint, n.d.):]

- Enqueue: $O(1)$, proses menambahkan elemen di posisi paling belakang.
- Dequeue: $O(1)$, proses menghapus elemen dari posisi paling depan.
- Peek/Front: $O(1)$, operasi untuk melihat data terdepan tanpa menghapusnya.
- Is_empty: $O(1)$, pengecekan status ketersediaan data dalam antrean.

#ind[Khusus untuk Priority Queue yang menggunakan linked list terurut, operasi enqueue dapat meningkat menjadi O(n) karena sistem harus mencari posisi yang tepat untuk menjaga urutan prioritas (GeeksforGeeks, n.d.).]

#ind[Queue digunakan secara luas dalam sistem komputasi terdistribusi untuk menangani komunikasi antar perangkat (Ghazal & Hamouda, n.d.). Pada jaringan IoT, struktur ini berfungsi sebagai penyangga (_buffer_) untuk mengatur aliran data dari sensor menuju server agar tidak terjadi kehilangan data saat trafik sedang tinggi, serta memastikan distribusi notifikasi dikirimkan secara sistematis.]

=== Binary Search Tree
#ind[Binary Search Tree (BST) adalah jenis pohon biner yang memiliki aturan penempatan nilai yang spesifik: nilai pada subtree kiri selalu lebih kecil dari node induk (root), sedangkan nilai pada subtree kanan selalu lebih besar (Medium, 2022). Properti utama ini memastikan bahwa urutan nilai tetap konsisten di setiap node, sehingga memungkinkan penyimpanan data secara hierarkis tanpa harus menggunakan array terurut (UCSB, 2019). Karakteristik penting dari BST meliputi:]

- Data disusun dalam level-level node yang saling terhubung (Wikipedia, n.d.).
- Karena strukturnya yang terorganisir, BST sangat memudahkan proses pencarian data secara terstruktur (Medium, 2022).
- Performa BST sangat bergantung pada bentuk pohonnya. BST yang seimbang akan sangat efisien, namun jika data dimasukkan secara berurutan, pohon dapat menjadi "miring" (_skewed_) dan menyerupai linked list, yang menyebabkan penurunan performa (StackOverflow, 2014).

#ind[Dalam pengelolaannya, terdapat beberapa operasi utama yang dapat dilakukan pada struktur BST (Medium, 2022; UCSB, 2019):]

- Search\ Mencari node dengan membandingkan nilai kunci secara bertahap mulai dari root hingga ke bawah.
- Insert\ Menambahkan node baru pada posisi yang tepat sesuai dengan aturan nilai lebih kecil di kiri dan lebih besar di kanan.
- Delete\ Menghapus node tertentu dengan penanganan khusus tergantung apakah node tersebut adalah node daun, memiliki satu anak, atau dua anak.
- Min/Max\ Menemukan nilai terkecil dengan menelusuri sisi kiri paling ujung atau nilai terbesar di sisi kanan paling ujung.
- Traversal\ Proses mengunjungi seluruh node menggunakan metode _inorder_, _preorder_, atau _postorder_.

=== Graph
#ind[Kompleksitas waktu pada BST sangat bergantung pada tinggi pohon ($h$) dan jumlah node ($n$). Berikut adalah rincian efisiensinya berdasarkan analisis teknis:]
- Search/Insert/Delete
  - Rata-rata (Pohon Seimbang): $O(log n)$, di mana operasi dilakukan dengan membagi ruang pencarian menjadi dua di setiap langkah (Big-O Cheat Sheet, n.d.).
  - Kasus Terburuk (Pohon Miring): $O(n)$, terjadi ketika pohon berbentuk linear sehingga menyerupai _linked list_ (StackOverflow, 2014).
- Min/Max: $O(h)$, bergantung pada tinggi pohon dari root ke node terdalam di sisi kiri atau kanan (Medium, n.d.).
- Traversal: $O(n)$, karena setiap node dalam pohon harus dikunjungi tepat satu kali (Wikipedia, n.d.).

#ind[BST sangat cocok digunakan untuk sistem yang memerlukan operasi pencarian, penambahan, dan penghapusan data secara frekuen, selama pohon tetap terjaga keseimbangannya. Dalam konteks sistem monitoring, BST dapat diimplementasikan sebagai registry perangkat untuk mengelola identitas sensor yang banyak dengan akses yang cepat dan terorganisir (Sensors, 2022).]

=== Dijkstra Algorithm
#ind[Algoritma Dijkstra adalah metode pencarian jalur terpendek (_shortest path_) pada sebuah graf berbobot di mana semua bobot pada sisinya (_edge_) harus bernilai non-negatif. Algoritma ini bekerja dengan mencari jarak minimum dari satu titik sumber (_source node_) ke seluruh titik lainnya dalam jaringan. Prinsip utamanya adalah secara iteratif memilih titik dengan jarak sementara terkecil, lalu memperbarui (_update_) perkiraan jarak ke semua titik tetangganya (GeeksforGeeks, n.d.).]

#ind[Pada graf berbobot, setiap sisi memiliki nilai numerik yang merepresentasikan jarak fisik, biaya, atau dalam konteks pemantauan jaringan, merepresentasikan latensi (BPIKA UMA, 2025).Algoritma ini sangat efektif untuk menentukan rute tercepat dalam sistem navigasi maupun sistem monitoring yang memerlukan jalur minimum dari satu titik agresi ke titik lainnya. Efisiensi algoritma ini sangat bergantung pada struktur data yang digunakan dalam implementasinya:]

- Array sederhana\ Pemilihan titik dengan jarak terkecil dilakukan melalui pencarian linear, yang menghasilkan kompleksitas waktu $O(V^2)$, di mana V adalah jumlah titik. Pendekatan ini lebih mudah diimplementasikan untuk graf yang relatif kecil atau padat (BPIKA UMA, 2025).
- Min-Heap (Priority Queeue)\ Menggunakan struktur data antrean prioritas untuk mengekstrak titik minimum, sehingga meningkatkan efisiensi menjadi $O((V plus E)log V)$ atau $O(E log V)$ untuk graf yang saling terhubung. Versi ini lebih cocok untuk sistem dengan performa tinggi dan jumlah sisi ($E$) yang besar (Reddit, 2021).

#ind[Dalam arsitektur sistem monitoring, algoritma Dijkstra memainkan peran kunci dalam manajemen rute (_routing_) untuk meminimalkan keterlambatan pengiriman data. Dengan menghitung total latensi dari pusat data (_gateway_) menuju setiap perangkat sensor, sistem dapat menentukan jalur komunikasi paling efisien (Munir, 2007) . Setelah rute terpendek ditentukan, data tersebut dapat digunakan untuk mengurutkan daftar perangkat guna menghasilkan laporan audit yang sistematis berdasarkan tingkat kedekatan akses.]

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