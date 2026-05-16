#set document(
  title: "Laporan Praktikum Fisika Dasar",
  author: "dija",
  date: datetime.today(),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
)

#set text(
  size: 12pt,
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

== pendahuluan

=== Latar Belakang
=== Rumusan Masalah
=== Tujuan
=== Batasan Masalah

== landasan teori

=== Linked List
=== Stack
=== Queue
=== Binary Search Tree
=== Graph
=== Dijkstra Algorithm

== Desain dan Implementasi

=== Arsitektur Sistem
=== Desain Modul
=== Pseudocode

== Hasil dan Pembahasan

=== Hasil
=== Pembahasan

== Kesimpulan dan Saran

=== Kesimpulan
=== Saran

== Daftar Pustaka