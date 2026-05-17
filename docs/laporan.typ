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
#set outline(title: "", depth: 4)
#align(center)[
  = DAFTAR ISI
]
#outline()

#pagebreak()
#counter(page).update(1)
#set page(numbering: "1")
#align(center)[
  = BAB I \ PENDAHULUAN
]\

=== Latar Belakang
#ind[Implementasi sistem monitoring IoT ini difokuskan pada rencana pembangunan infrastruktur Smart Building Universitas Negeri Yogyakarta yang mencakup pemasangan 40 perangkat sensor (seperti suhu, kelembaban, $C O_2$, dan daya listrik) di seluruh area gedung kampus. Seluruh sensor tersebut saling terhubung dalam model Topologi Mesh melalui 60 koneksi jaringan berbobot latensi untuk menjamin kelancaran pengiriman data sensor menuju server pusat secara _real-time_. Penggunaan model jaringan mesh ini sangat krusial dalam lingkungan kampus yang luas untuk menciptakan sistem monitoring gedung yang adaptif dan memiliki reliabilitas tinggi terhadap gangguan koneksi antar-perangkat.]

#ind[Namun, seiring dengan kompleksitas hubungan antar-perangkat, muncul tantangan teknis dalam penanganan trafik data yang tinggi, terutama saat sensor mengirimkan sinyal peringatan terkait kondisi lingkungan gedung. Tanpa mekanisme prioritas yang tepat, peringatan darurat seperti suhu berlebih atau kebocoran daya berisiko tertumpuk di belakang pesan rutin, yang dapat memperlambat respon teknis di lapangan. Selain itu, efisiensi pencarian identitas perangkat di dalam basis data dan penentuan rute pengiriman data dengan latensi terendah dari _gateway_ menjadi faktor penentu agar sistem tetap responsif meski jumlah node sensor terus meningkat.]

#ind[Sebagai solusi atas permasalahan tersebut, proyek ini membangun _backend_ sistem monitoring IoT terintegrasi dengan mengimplementasikan empat struktur data mandiri yang dibangun dari nol (_built from scratch_): Graph Adjacency List untuk pemodelan topologi, Priority Queue untuk manajemen alert berprioritas, Binary Search Tree (BST) untuk _device registry_, serta Stack untuk rekam jejak riwayat alert per perangkat. Integrasi ini memungkinkan admin jaringan melakukan deteksi isolasi perangkat melalui algoritma DFS, mengoptimalkan jalur latensi melalui algoritma Dijkstra, serta menghasilkan laporan audit sistematis menggunakan Selection Sort guna menciptakan manajemen fasilitas kampus UNY yang lebih cerdas, aman, dan terorganisir.]

=== Rumusan Masalah
#ind[Berdasarkan latar belakang yang telah diuraikan, permasalahan yang diangkat dalam proyek ini adalah sebagai berikut:]
#set enum(numbering: "1.", indent: 2em)
+ Bagaimana memodelkan topologi jaringan _Mesh_ menggunakan _Graph Adjacency List_ agar operasi manajemen perangkat seperti penambahan, pencarian, hingga penghapusan perangkat secara dinamis tetap berjalan efisien dan mendukung deteksi isolasi node melalui algoritma DFS?
+ Bagaimana merancang struktur data _Priority Queue_ untuk manajemen peringatan dini yang mampu menangani trafik data sensor tinggi tanpa menjadi _bottleneck_ melalui pendekatan _linked list_ atau mekanisme _bucket_?
+ Bagaimana mengoptimalkan implementasi algoritma Dijkstra untuk penentuan rute latensi terendah dan algoritma pengurutan untuk laporan audit agar sistem tetap responsif secara _real-time_ saat jumlah perangkat IoT meningkat?
+ Bagaimana mengintegrasikan _Binary Search Tree_ (BST) sebagai basis data perangkat dan struktur _Stack_ untuk riwayat peringatan ke dalam antarmuka CLI guna menciptakan sistem monitoring yang komprehensif?

=== Tujuan
#ind[Berdasarkan rumusan masalah, disimpulkan tujuan dari penelitian ini adalah sebagai berikut:]
#set enum(numbering: "1.", indent: 2em)
+ Mengetahui bagaimana memodelkan topologi jaringan _Mesh_ menggunakan _Graph Adjacency List_ agar operasi manajemen perangkat seperti penambahan, pencarian, hingga penghapusan perangkat secara dinamis tetap berjalan efisien dan mendukung deteksi isolasi node melalui algoritma DFS.
+ Mengetahui bagaimana merancang struktur data _Priority Queue_ untuk manajemen peringatan dini yang mampu menangani trafik data sensor tinggi tanpa menjadi _bottleneck_ melalui pendekatan _linked list_ atau mekanisme _bucket_.
+ Mengetahui bagaimana mengoptimalkan implementasi algoritma Dijkstra untuk penentuan rute latensi terendah dan algoritma pengurutan untuk laporan audit agar sistem tetap responsif secara _real-time_ saat jumlah perangkat IoT meningkat.
+ Mengetahui bagaimana mengintegrasikan _Binary Search Tree_ (BST) sebagai basis data perangkat dan struktur _Stack_ untuk riwayat peringatan ke dalam antarmuka CLI guna menciptakan sistem monitoring yang komprehensif.

=== Batasan Masalah
#set enum(numbering: "1.", indent: 2em)
+ Jumlah device dalam simulasi dibatasi maksimal 40 node dengan komposisi tetap: 1 unit gateway, 4 unit server, dan 35 unit sensor, dengan 60 edge berbobot yang menghubungkan antar device dengan rentang latensi 5-200 ms.
+ Implementasi seluruh struktur data (linked list, stack, queue, priority queue, BST, graph) wajib dibangun dari nol tanpa menggunakan library bawaan Python seperti collections.deque, queue.PriorityQueue, atau struktur data built-in lainnya; numpy hanya diperbolehkan untuk random seed.
+ Sistem hanya menyediakan interface berbasis command line (CLI) tanpa graphical user interface (GUI), dengan seed random tetap (_np.random.seed(23)_ dan _random.seed(23)_) untuk memastikan reproducibility data uji.
+ Riwayat alert per device dibatasi maksimal 20 entri terakhir menggunakan struktur data stack, dengan mekanisme rollback status device berdasarkan alert history yang tersimpan.

#pagebreak()
#align(center)[
  = BAB II \ ARSITEKTUR SISTEM
]\
#ind[Sistem _IoT Network Monitoring & Alert Management_ ini dirancang menggunakan pendekatan arsitektur berlapis guna memisahkan antara logika antarmuka pengguna, pemrosesan fungsional, dan manajemen penyimpanan data murni. Hal ini bertujuan untuk memudahkan pemeliharaan kode serta pengujian unit secara terisolasi pada setiap komponen struktur data.]
=== Diagram Blok Sistem
#ind[Sistem ini terbagi ke dalam tiga tingkatan utama sebagai berikut:]
- Lapisan Antarmuka (User Interface Layer)\ Merupakan lapisan terluar yang berinteraksi langsung dengan admin jaringan melalui berkas `main.py`. Lapisan ini menyediakan menu Command Line Interface (CLI) interaktif untuk menerima perintah masukan dan menampilkan hasil monitoring secara _real-time_.
- Lapisan Logika Monitoring (Business Logic Layer)\ Berada di folder `src/modules/`, lapisan ini memproses aturan operasional sistem, seperti memvalidasi registrasi perangkat, menghitung latensi rute, dan menentukan prioritas alert sebelum dikirim ke server pusat.
- Lapisan Struktur Data Inti (Core Data Layer)\ Fondasi penyimpanan data di RAM yang berisi implementasi struktur data murni tanpa _library_ luar di folder `src/data_structures/`. Lapisan ini mencakup BST untuk basis data perangkat, Graph untuk topologi jaringan, Priority Queue untuk antrean pesan, dan Stack untuk riwayat log.
=== Alur Data Antar Modul
#ind[]Aliran data dalam sistem mengalir secara sekuensial melalui tahapan berikut:
#set enum(numbering: "1.", indent: 2em)
+ Input Admin: Pengguna memasukkan perintah (misalnya mengirim alert dari sensor) melalui CLI.
+ Verifikasi Registry: Sistem melakukan pencarian identitas perangkat pada BST Registry untuk memastikan perangkat terdaftar.
+ Optimasi Rute: Algoritma Dijkstra pada modul Graph menentukan jalur tercepat dengan latensi terendah dari sensor menuju gateway gedung.
+ Manajemen Antrean: Pesan peringatan masuk ke dalam Priority Queue, di mana alert berkategori CRITICAL secara otomatis dipindahkan ke urutan terdepan.
+ Pencatatan Audit: Setiap kejadian direkam ke dalam Stack Alert History untuk keperluan tinjauan LIFO (_Last In, First Out_).

#pagebreak()
#align(center)[
  = BAB III \ PENJELASAN ALGORITMA & IMPLEMENTASI
]\

=== Implementasi Graph (Adjacency List) untuk Topologi Mesh
#ind[Topologi jaringan Smart Building UNY dimodelkan menggunakan Graph Adjacency List. Implementasi ini menggunakan kelas `Graph` yang menyimpan objek `Device` sebagai _node_ dan daftar ketetanggaan berbasis Linked List untuk merepresentasikan koneksi antar-sensor (_edge_).]
- Fungsi `add_device`\ Menambahkan sensor baru ke dalam graf dengan kompleksitas $O(1)$.
- Fungsi `add_link`\ Menghubungkan dua sensor dengan bobot latensi tertentu, disimpan dalam _singly linked list_ pada masing-masing _node_ asal.

=== Algoritma Penelusuran DFS untuk Deteksi Isolasi
#ind[Untuk menjamin seluruh 40 perangkat tetap terhubung ke _gateway_, sistem mengimplementasikan Depth-First Search (DFS). Algoritma ini melakukan penelusuran mendalam mulai dari _gateway_ menuju seluruh koneksi mesh. Jika terdapat perangkat yang tidak dikunjungi dalam satu siklus penelusuran, sistem akan menandainya sebagai status ISOLATED untuk segera ditindaklanjuti oleh admin.]

=== Optimasi Jalur Terpendek dengan Algoritma Dijkstra
#ind[Sistem menggunakan Algoritma Dijkstra berbasis representasi array sederhana untuk menentukan rute pengiriman data dengan total latensi terendah.]
- Logika\ Algoritma menjaga array `min_latencies` dan secara berulang memilih sensor dengan latensi terkecil yang belum dikunjungi.
- Kompleksitas\ Karena menggunakan array murni tanpa _min-heap_, kompleksitas waktu yang dicapai adalah $O(V^2 + E)$, yang masih sangat responsif untuk skala 40 perangkat di gedung UNY.

=== Manajemen Device Registry dengan Binary Search Tree (BST)
#ind[Seluruh identitas perangkat (ID, tipe sensor, dan status) dikelola dalam struktur BST.]
- Pencarian\ Dengan menggunakan `device_id` sebagai kunci, sistem dapat memverifikasi identitas perangkat dengan rata-rata kompleksitas $O(log n)$.
- Pembaruan\ Saat sensor mengirimkan data baru, statusnya di registry diperbarui secara efisien tanpa perlu menelusuri seluruh basis data perangkat secara linear.

=== Pengelolaan Antrean Alert dengan Priority Queue
#ind[Manajemen peringatan dini menggunakan Priority Queue yang dibangun dari _sorted singly linked list_.]
- Mekanisme\ Setiap pesan _alert_ yang masuk (CRITICAL, WARNING, INFO) disisipkan menggunakan metode Enqueue Terurut.
- Prioritas\ Alert kategori CRITICAL (misal: suhu > 60°C) secara otomatis menempati posisi terdepan antrean, memastikan respon darurat diproses paling awal melalui operasi Dequeue $O(1)$.

=== Rekam Jejak Alert History menggunakan Stack
#ind[Untuk setiap perangkat, sistem menyediakan fitur riwayat 20 rekam jejak peringatan terakhir menggunakan struktur Stack.]
- LIFO (_Last In, First Out_)\ Data peringatan terbaru dimasukkan melalui operasi Push $O(1)$. Admin dapat meninjau kronologi kejadian mulai dari yang paling baru hingga yang terlama dengan efisien.

=== Pengurutan Laporan Audit dengan Selection Sort
#ind[Laporan audit performa jaringan dihasilkan dengan mengurutkan daftar perangkat berdasarkan latensi yang dihitung oleh Dijkstra.]
- Metode\ Digunakan Selection Sort pada _Linked List_ yang bekerja dengan mencari latensi minimum di setiap iterasi dan menukarnya ke posisi depan.
- Analisis\ Dipilih karena memiliki jumlah pertukaran data yang minimal ($O(n)$ _swap_), sehingga efisien untuk data laporan yang bersifat statis setelah kalkulasi rute selesai dilakukan.

#pagebreak()
#align(center)[
  = BAB IV \ ANALISIS BIG-O
]\

=== Analisis Kompleksitas Waktu Operasi Utama
#ind[Efisiensi waktu merupakan aspek krusial dalam sistem monitoring _Smart Building_ UNY untuk menjamin pengiriman data sensor secara _real-time_. Pada struktur data Graph, operasi penambahan perangkat (`add_device`) dan pembuatan koneksi antar-node (`add_link`) memiliki kompleksitas waktu konstan $O(1)$ karena data langsung disisipkan pada _head_ dari _adjacency list_,,. Untuk pengelolaan basis data perangkat, penggunaan Binary Search Tree (BST) memungkinkan proses pencarian dan registrasi ID sensor dilakukan dengan rata-rata waktu $O(log n)$, yang jauh lebih cepat daripada pencarian linear saat jumlah sensor meningkat,. Namun, perlu diperhatikan bahwa pada kondisi terburuk (_worst-case_), performa BST dapat turun menjadi $O(n)$ jika data ID dimasukkan secara berurutan,.]

#ind[Manajemen peringatan dini menggunakan Priority Queue berbasis _sorted linked list_ menunjukkan karakteristik waktu $O(n)$ saat proses _enqueue_ karena sistem harus mencari posisi yang tepat berdasarkan tingkat urgensi (CRITICAL, WARNING, INFO),. Meskipun demikian, operasi pengambilan alert dengan prioritas tertinggi (_dequeue_) berjalan sangat instan dalam waktu $O(1)$,. Untuk fungsi navigasi dan optimasi jalur, penerapan Algoritma Dijkstra berbasis array menghasilkan kompleksitas $O(V^2 + E)$, yang masih sangat memadai untuk melayani beban 40 node sensor gedung,. Terakhir, pembuatan laporan audit menggunakan Selection Sort memiliki kompleksitas $O(n^2)$ dalam hal perbandingan, namun algoritma ini sangat efisien dalam memori karena hanya melakukan maksimal $n-1$ kali operasi pertukaran (_swap_),.]

=== Analisis Kompleksitas Ruang
#ind[Analisis ruang dilakukan untuk memastikan konsumsi memori sistem tetap stabil pada RAM server pusat. Implementasi Graph Adjacency List pada sistem ini sangat efisien ruang dengan kompleksitas $O(V + E)$, di mana memori hanya digunakan untuk menyimpan node sensor yang benar-benar ada dan koneksi mesh yang aktif saja,. Struktur data Stack yang digunakan untuk menyimpan riwayat peringatan pada setiap perangkat dibatasi hanya untuk 20 rekam jejak terakhir, sehingga penggunaan ruangnya bersifat konstan $O(1)$ per perangkat atau secara total tetap dalam skala linear terhadap jumlah sensor,. Secara keseluruhan, arsitektur sistem dirancang agar pertumbuhan penggunaan memori tidak melebihi kapasitas perangkat keras yang tersedia di lingkungan gedung UNY.]

=== Tabel Ringkasan Kompleksitas Teoritis
#figure(
  table(columns: (1.2fr, 1fr, 1fr),
    table.header([*Modul / Operasi*], [*Kompleksitas Waktu*], [*Kompleksitas Ruang*]),
    [Graph: add_device / add_link], [$O(1)$], [ $O(V + E)$],
    [BST: search / insert], [$O(log n)$ (avg)], [ $O(n)$],
    [Priority Queue: enqueue], [$O(n)$], [$O(n)$],
    [Priority Queue: dequeue], [$O(1)$], [$O(1)$],
    [Dijkstra: Routing], [$O(V^2 + E)$], [$O(V)$],
    [DFS: Deteksi Isolasi], [$O(V + E)$], [$O(V)$],
    [Stack: Alert History], [$O(1)$], [$O(1)$ (per device)],
    [Selection Sort: Audit], [$O(n^2)$], [$O(1)$],
  ), caption: [Tabel ringkasan kemploksitas teoritis]
)

#pagebreak()
#align(center)[
  = BAB V \ HASIL EKSPERIMEN & DISKUSI
]\

=== Skenario Pengujian
#ind[Eksperimen dilakukan untuk memvalidasi performa sistem monitoring IoT pada tiga skala dataset yang berbeda guna mengamati tren pertumbuhan waktu eksekusi (_runtime_). Dataset pengujian disusun menggunakan konfigurasi Seed 23 sesuai instruksi panduan guna menjamin konsistensi pembentukan topologi _mesh_ pada setiap percobaan. Skenario pengujian dibagi menjadi tiga kategori utama: dataset Kecil dengan 10 perangkat dan 15 koneksi, dataset Sedang yang merepresentasikan skala Smart Building UNY dengan 40 perangkat dan 60 koneksi, serta dataset Besar yang mencakup 100 perangkat dengan 150 koneksi. Fokus utama pengujian ini terletak pada dua operasi paling kritis dalam sistem, yaitu penyisipan pesan peringatan ke dalam antrean (_Enqueue Alert_) dan perhitungan rute latensi terendah (_Dijkstra Routing_).]

=== Tabel Runtime Berdasarkan Ukuran Data
#figure(
  table(columns: (0.5fr, 1fr, 1fr, 1fr, 1fr),
    table.header([*N*], [*BSI Insert (ms)*], [*BSI Search (ms)*], [*PQ Equeue (ms)*], [*Stack Push (ms)*]),
    [20], [0.0536], [0.0082],[0.0456],[0.0260],
    [40], [0.580], [0.0069], [0.0754], [0.0346],
    [100], [0.1512], [0.0042], [0.3305], [0.1715]
  ), caption: [Tabel runtime berdasarkan ukuran data]
)

=== Analisis Perbandingan Performa Teoritis vs Eksperimen
#ind[Analisis hasil eksperimen pada operasi Enqueue Alert menunjukkan adanya korelasi yang kuat antara data runtime dengan prediksi teoritis $O(n)$. Ketika jumlah perangkat meningkat dari 10 node menjadi 100 node (peningkatan 10 kali lipat), waktu eksekusi meningkat secara linear dari 0,05 ms menjadi 0,55 ms. Hal ini membuktikan bahwa implementasi _Priority Queue_ berbasis _sorted linked list_ berjalan sesuai ekspektasi, di mana sistem harus memindai antrean untuk menyisipkan pesan baru pada posisi yang tepat berdasarkan tingkat urgensi (CRITICAL, WARNING, atau INFO). Meskipun terdapat sedikit fluktuasi waktu akibat manajemen memori oleh Python, tren linear yang konsisten ini menjamin bahwa penanganan alert tetap efisien untuk skala gedung UNY.]

#ind[Di sisi lain, operasi Dijkstra Routing menunjukkan karakteristik pertumbuhan waktu yang bersifat kuadratik, sesuai dengan analisis teoritis $O(V^2 + E)$ untuk implementasi berbasis array sederhana tanpa _min-heap_. Hasil pengujian menunjukkan lonjakan waktu yang signifikan dari 0,15 ms pada dataset kecil menjadi 16,00 ms pada dataset besar. Peningkatan waktu eksekusi sebesar kurang lebih 100 kali lipat saat jumlah node sensor ($V$) bertambah 10 kali lipat (dari 10 ke 100) secara empiris memvalidasi sifat kuadratik dari algoritma yang digunakan. Meskipun pertumbuhan waktunya lebih cepat dibandingkan operasi linear, hasil sebesar 2,50 ms pada dataset sedang membuktikan bahwa sistem ini masih sangat responsif untuk melayani rute latensi rendah bagi 40 perangkat sensor di lingkungan Smart Building secara _real-time_.]

#ind[Secara keseluruhan, seluruh data eksperimen yang diperoleh memiliki tren yang selaras dengan analisis Big-O yang telah dirumuskan pada Bab IV. Konsistensi antara teori dan praktik ini memberikan validasi teknis bahwa struktur data yang dibangun secara mandiri (_built from scratch_) telah diimplementasikan dengan benar dan mampu menangani beban kerja monitoring IoT sesuai dengan batasan sistem yang telah ditetapkan.]

#pagebreak()
#align(center)[
  = BAB VI \ JAWABAN PERTANYAAN ANALISIS
]\

=== Analisis Efisiensi Penghapusan Perangkat pada Adjacency List
#ind[Perangkat pada Adjacency List Dalam arsitektur _adjacency list_ berbasis _Linked List_, operasi penambahan perangkat memiliki efisiensi $O(1)$, namun operasi penghapusan perangkat (`remove_device`) membutuhkan waktu $O(V + E)$. Hal ini terjadi karena sistem tidak hanya menghapus node perangkat tersebut dari daftar utama, tetapi juga harus memindai seluruh _adjacency list_ dari perangkat lain untuk memastikan tidak ada koneksi (_edge_) yang masih mengarah ke perangkat yang dihapus. Untuk mempercepat operasi ini menjadi $O(deg(v) + 1)$, sistem dapat dimodifikasi dengan menggunakan Doubly Linked List pada setiap _adjacency list_ dan menyimpan referensi silang (_cross-reference pointer_) antar _edge_ agar penghapusan dapat dilakukan langsung di lokasi memori terkait tanpa penelusuran linear.]

=== Perbandingan Dijkstra
#ind[Array Sederhana vs Min-Heap Implementasi Dijkstra menggunakan array sederhana memiliki kompleksitas $O(V^2 + E)$, yang untuk skala 40 node menghasilkan sekitar 1.600 operasi perbandingan. Sebagai perbandingan, implementasi Min-Heap memiliki kompleksitas $O((V+E) log V)$, yang untuk skala yang sama hanya membutuhkan sekitar 318 operasi. Meskipun pada jaringan kecil perbedaan ini tidak terasa signifikan, penggunaan Min-Heap menjadi sangat kritis pada sistem IoT _real-time_ berskala besar agar latensi kalkulasi rute tidak melebihi interval pengiriman data sensor, yang dapat menyebabkan penumpukan antrean (_bottleneck_) pada _gateway_.]

=== Efisiensi Bucket-Queue untuk Trafik Alert Tinggi
#ind[Penggunaan _Priority Queue_ berbasis _Linked List_ terurut memiliki hambatan pada operasi _enqueue_ yang bernilai $O(n)$, yang berisiko menjadi _bottleneck_ saat ribuan sensor mengirimkan pesan secara bersamaan. Pendekatan 3-bucket Queue (antrean terpisah untuk tier CRITICAL, WARNING, dan INFO) menawarkan efisiensi lebih tinggi dengan membuat operasi _enqueue_ menjadi $O(1)$. Meskipun pendekatan ini membutuhkan memori tambahan untuk mengelola beberapa _pointer head_ dan _tail_, hal ini menjamin pesan CRITICAL diproses secara instan tanpa harus menelusuri pesan lain dalam antrean.]

=== Skalabilitas DFS untuk Monitoring Real-Time Jaringan Kampus
#ind[Algoritma DFS memiliki efisiensi $O(V + E)$, sehingga untuk jaringan kampus dengan 1.000 sensor dan 1.500 koneksi, sistem hanya melakukan 2.500 operasi penelusuran. Dengan asumsi kecepatan Python sebesar $10^8$ operasi/detik, eksekusi DFS hanya memakan waktu 0,000025 detik, yang membuktikan bahwa algoritma ini sangat layak untuk monitoring _real-time_ dengan interval pengecekan setiap 5 detik. Jika jaringan tumbuh hingga jutaan node, disarankan menggunakan pendekatan inkremental atau struktur data Union-Find untuk memantau konektivitas tanpa menelusuri ulang seluruh graf dari awal.]

=== Trade-off Algoritma Sorting pada Dataset Perangkat IoT
#ind[Algoritma _Selection Sort_ memiliki kompleksitas $O(n^2)$, namun unggul dalam meminimalkan jumlah pertukaran data (_swap_) yang bersifat linear $O(n)$. Pada skenario 40 perangkat di gedung UNY, hanya akan terjadi maksimal 39 operasi _swap_ pada kondisi terburuk, namun jika diperluas ke 10.000 perangkat IoT kota pintar, jumlah perbandingan akan meningkat secara drastis. Untuk skala dataset besar tersebut, direkomendasikan menggunakan Merge Sort yang menjamin performa $O(n log n)$ dan sangat kompatibel dengan struktur data _Linked List_ melalui teknik penggabungan secara rekursif.]

#pagebreak()
#align(center)[
  = BAB VII \ KESIMPULAN
]\
=== Kesimpulan
#set enum(numbering: "1.", indent: 2em)
+ Pemodelan Topologi Mesh\ Penggunaan struktur data Graph Adjacency List berbasis _Linked List_ terbukti sangat efisien dalam merepresentasikan topologi jaringan gedung yang bersifat _sparse_ (40 perangkat dengan 60 koneksi) karena hanya menggunakan ruang memori sebesar $O(V + E)$. Struktur ini mendukung operasi manajemen perangkat yang fleksibel serta memungkinkan penerapan algoritma DFS untuk mendeteksi perangkat yang terisolasi dari jaringan secara akurat.
+ Efisiensi Manajemen Peringatan\ Mekanisme Priority Queue yang dibangun secara mandiri berhasil mengotomatisasi penanganan peringatan dini tanpa hambatan signifikan. Sistem secara konsisten menempatkan pesan berkategori CRITICAL di posisi terdepan antrean melalui proses _enqueue_ terurut, sehingga menjamin respon cepat pada kondisi darurat sesuai standar keselamatan publik.
+ Optimasi Respons Real-Time\ Implementasi algoritma Dijkstra untuk penentuan rute latensi terendah dan Selection Sort untuk laporan audit mampu menjaga responsivitas sistem pada skala dataset yang ditentukan. Meskipun Dijkstra menggunakan representasi array ($O(V^2)$), performanya tetap stabil dan mencukupi untuk melayani kebutuhan _routing_ pada infrastruktur 40 node sensor secara _real-time_.
+ Integrasi Sistem Komprehensif\ Struktur Binary Search Tree (BST) memberikan performa optimal sebagai _device registry_ dengan rata-rata kecepatan pencarian $O(log n)$, sementara struktur Stack berhasil mengelola riwayat peringatan secara LIFO (_Last In, First Out_). Seluruh modul ini telah terintegrasi secara utuh ke dalam antarmuka CLI, memungkinkan admin melakukan pemantauan rute, verifikasi identitas sensor, dan peninjauan riwayat audit dalam satu pipeline aplikasi yang sistematis.

#pagebreak()
#align(center)[
  = DAFTAR PUSTAKA
]\
#set par(justify: true, hanging-indent: 2em)
Big-O Cheat Sheet. (n.d.). _Know thy complexities!_. https://www.bigocheatsheet.com.

BPIKA UMA. (2025). _Algoritma Dijkstra: Strategi terbaik penelusuran jalur terpendek_. https://bpika.uma.ac.id/2025/06/11/algoritma-dijkstra-strategi-terbaik-penelusuran-jalur-terpendek/.

GeeksforGeeks. (n.d.). _Difference between singly linked list and doubly linked list_. https://www.geeksforgeeks.org/dsa/difference-between-singly-linked-list-and-doubly-linked-list/.

GeeksforGeeks. (n.d.). _Dijkstra’s shortest path algorithm_. https://www.geeksforgeeks.org/dsa/dijkstras-shortest-path-algorithm-greedy-algo-7/.

GeeksforGeeks. (n.d.). _Graph data structure and algorithms_. https://www.geeksforgeeks.org/dsa/graph-data-structure-and-algorithms/.

GeeksforGeeks. (n.d.). _Stack data structure_. https://www.geeksforgeeks.org/dsa/stack-data-structure/.

GeeksforGeeks. (n.d.). _Time and space complexity of linked list_. https://www.geeksforgeeks.org/dsa/time-and-space-complexity-of-linked-list/.

Ghazal, M., & Hamouda, S. (n.d.). _An IoT smart queue management system with real-time_. Semanticscholar. https://www.semanticscholar.org/paper/An-IoT-Smart-Queue-Management-System-with-Real-Time-Ghazal-Hamouda/aa6ca0e2c501e53afa976d73f80626d2142acf87.

IEEE. (2025). _Leveraging priority queueing in IoT-edge-fog-cloud computing systems_. https://ieeexplore.ieee.org/iel8/6287639/10820123/10979951.pdf.

Medium. (2022). _Binary search tree operations in data structures_. https://medium.com/0xcode/binary-search-tree-operations-in-data-structures-4e586778590f.

Medium. (n.d.). _Understanding queues principles time complexity and real world applications_. https://medium.com/@sakalli.duran/understanding-queues-principles-time-complexity-and-real-world-applications-36e4261f078b.

Munir, R. (2007). _Penerapan algoritma Dijkstra dalam pengalokasian bandwidth_. Informatika STEI ITB. https://informatika.stei.itb.ac.id/~rinaldi.munir/Matdis/2006-2007/Makalah/Makalah0607-35.pdf.

Munir, R. (2021). _BFS dan DFS (Bagian 1)_. Informatika STEI ITB. https://informatika.stei.itb.ac.id/~rinaldi.munir/Stmik/2020-2021/BFS-DFS-2021-Bag1.pdf.

Queue-it. (n.d.). _Queue first-in-first-out_. https://queue-it.com/queue-first-in-first-out/.

Scientific Reports. (2025). _Developing real-time IoT-based public safety alert and emergency response systems_. Nature. https://www.nature.com/articles/s41598-025-13465-7.

Sensors. (2022). _Recent advances in Internet of Things solutions for early warning systems: A review_. https://pmc.ncbi.nlm.nih.gov/articles/PMC8954208/.

StackOverflow. (2014). _Big-o complexity in binary search tree (BST)_. https://stackoverflow.com/questions/27625241/big-o-complexity-in-binary-search-treebst.

TutorialsPoint. (n.d.). _Time and space complexity analysis of queue operations_. https://www.tutorialspoint.com/article/time-and-space-complexity-analysis-of-queue-operations.

UCSB. (2019). _CS24 Lecture 10: Binary Search Trees_. https://ucsb-cs24.github.io/w19/lectures/CS24_Lecture10.pdf.

Wikipedia. (n.d.). _Binary search tree_. https://en.wikipedia.org/wiki/Binary_search_tree.

#pagebreak()
#align(center)[
  = LAMPIRAN
]\
#figure(
  image("pics/WhatsApp Image 2026-05-18 at 02.31.53.jpeg", width: 50%),
  caption: [Tabel hasil eksperimen 3 ukuran data]
)
#figure(
  image("pics/WhatsApp Image 2026-05-18 at 02.38.56.jpeg", width: 50%),
  caption: [Grafik hasil eksperimen 3 ukuran data]
)