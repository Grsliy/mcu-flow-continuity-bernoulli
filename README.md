# Alat Praktikum Fluida Dinamis Interaktif

Freelance job: merancang dan membangun alat praktikum fisika berbasis mikrokontroler untuk kebutuhan skripsi client, membuktikan **hukum kontinuitas** dan **asas Bernoulli** secara terukur dan interaktif — bukan sekadar alat peraga pasif.

> **Status saat ini: tahap desain, belum masuk fabrikasi.** Belum ada firmware/kode. Lihat [§ Status & Blocker](#status--blocker) sebelum melanjutkan kerja apa pun.

## Ringkasan

Alat ini punya tiga lapis:

1. **Pengukuran inti** — sensor flow terkalibrasi volumetrik (gelas ukur) dan panel manometer yang membaca tekanan **langsung** (bukan dihitung) di sepanjang test section: venturi mendatar (zona A) → segmen naik (zona B). Paket lengkap menambah penyempitan di ketinggian atas (zona C) + sensor flow kedua.
2. **Kontrol fisik** — pompa DC di satu tangki mendorong aliran langsung. Kenop mengatur **target debit** yang dikunci kontrol PI, dan selisih antar kolom manometer mengikuti. Level kolom diatur otomatis oleh **leher angsa** di ujung pipa, jadi tidak ada servo.
3. **Presentasi** — prediksi di balik tombol CEK (muncul setelah siswa mencatat bacaan), sonifikasi (nada mengikuti debit), dan mode tantangan target.

Prinsip yang mendasari semua keputusan desain:

> Alat harus punya input yang benar-benar mengontrol kondisi fisik sistem, dan output (bacaan sensor) mengikuti input tersebut — bukan cuma sistem pasif yang mengikuti kondisi fisika tetap.

## Struktur folder

```
├── README.md                          ← file ini
├── referensi/                         ← 4 jurnal acuan (lihat di bawah)
├── anggaran/
│   └── RAB-alat-praktikum-rev08.xlsx  ← RAB per kelompok (elektronik, mekanis, jasa, dll) + ringkasan otomatis
├── catatan/
│   └── konteks-dan-spesifikasi.md     ← acuan kerja aktif — scope, desain, biaya, pertanyaan, log keputusan
├── desain/
│   ├── rancangan-alat.html            ← sketsa tampak depan + alur, Rev. 08 (buka di browser)
│   └── perhitungan/
│       ├── 01-pipa-dan-debit.md       ← hitungan dimensi, satu file per bagian
│       └── 02-profil-manometer.md
└── arsip/                             ← materi usang (draft awal, desain gravity-fed Rev. 06)
```

Yang aktif hanya `anggaran/`, `catatan/`, dan `desain/`. Isi `arsip/` disimpan sebagai jejak keputusan saja — lihat `arsip/README.md`.

## Referensi

| Tahun | Penulis | Judul | Relevansi |
|---|---|---|---|
| 2020 | Shidqi & Anggaryani | Alat Peraga Berbasis Sensor Flowmeter untuk Menerapkan Persamaan Kontinuitas | Rig 2-sensor, model pengembangan ADDIE |
| 2022 | Nurfajrihana dkk. | Alat Peraga Fisika dengan Waterflow Sensor pada Materi Asas Kontinuitas | 2× YF-S201 + venturimeter 2 diameter, dimensi 90×30×70 cm |
| 2025 | Mulianti dkk. | Alat Praktikum Pengukur Debit Air Berbasis Sensor Flow | Metode P=ρgh dari ketinggian tangki, bukan sensor tekanan |
| 2025 | Arumningrum dkk. | Prototipe Alat Peraga Asas Bernoulli Berbasis Arduino Uno | Venturimeter akrilik 2 sensor (YF-B5 + YF-S201), model 4D |

Tidak satu pun dari keempat jurnal ini memakai sensor tekanan fisik atau panel manometer — semua menghitung tekanan secara tidak langsung. Panel manometer 6 tabung di desain project ini (lihat catatan) mengadopsi pendekatan alat peraga Bernoulli komersial (referensi foto dari client), yang justru mengukur tekanan langsung.

## Model bisnis

- Hardware + firmware saja — pengambilan data, analisis, dan penulisan skripsi dikerjakan client sendiri.
- Biaya komponen direimburse terpisah dari fee jasa.
- Deadline longgar (>2 minggu).
- Rincian lengkap & angka fee: lihat `catatan/konteks-dan-spesifikasi.md` §3 dan §5. Estimasi budget Rev. 06 ada di `arsip/gravity-fed/` (belum dihitung ulang untuk Rev. 08).

## Status & Blocker

Hal-hal ini **wajib selesai sebelum belanja komponen atau mulai fabrikasi** (daftar lengkap di `catatan/konteks-dan-spesifikasi.md` §6):

1. **BAB I–III skripsi client** — menentukan apakah skripsinya R&D alat praktikum atau verifikasi eksperimen, dan karenanya zona/sensor mana yang benar-benar perlu.
2. **Pilih paket + kesepakatan tertulis satu halaman.** Paket inti (zona A + B) ditargetkan ± **Rp2 juta total** (komponen + jasa, belum dikonfirmasi client dan belum dihitung ulang); paket lengkap menambah zona C + sensor kedua. Kesepakatan memuat kriteria penerimaan terukur, serah terima alat + laporan kalibrasi, dan pernyataan bahwa metodologi & validitas data tanggung jawab client.
3. **Uji bangku murah** sebelum belanja penuh: stabilitas pompa di PWM rendah, kalibrasi S1 dengan gelas ukur, getaran kolom, ukur ID pipa riil — dan rugi tekanan S2 kalau paket lengkap dipilih.

## Riwayat desain (ringkas)

Desain berkembang signifikan lewat diskusi, dari alat pasif jadi sistem dengan input-output yang benar-benar terkontrol:

- **Revisi arsitektur besar** (kemudian dibatalkan di Rev. 07): dari "pompa mendorong aliran mendatar" menjadi **gravity-fed** (tangki sumber elevated, air turun karena gravitasi) — supaya ketinggian tangki bisa jadi variabel tekanan hidrostatis (P=ρgh) yang nyata, bukan cuma dekorasi.
- **Koreksi penting**: sketsa awal sempat menaruh dua sensor flow di penampang berukuran sama (tidak membuktikan apa-apa) — diperbaiki dengan menambah reducer sehingga A₁≠A₂.
- **Test section berkembang dari 1 jadi 3 zona**: venturi mendatar (isolasi efek kecepatan) → segmen naik (isolasi efek ketinggian) → penyempitan lagi di ketinggian lain (replikasi Bernoulli, sekaligus mengembalikan makna sensor kedua sebagai pembanding kecepatan).
- **Panel manometer 6 tabung ditambahkan** setelah client membagikan foto alat peraga Bernoulli komersial — mengubah tekanan dari "dihitung" jadi "terukur langsung", peningkatan kredibilitas data terbesar dalam seluruh proses desain.
- **Peran pompa diperjelas** jadi tiga mode (Isi/Tahan/Mati), dengan mode Tahan berfungsi sebagai *constant head tank* elektronik — rencana "pompa kedua" yang sempat dipertimbangkan akhirnya tidak diperlukan.
- **Arsitektur dibalik ke pompa langsung, satu tangki (Rev. 07)**: pada gravity-fed, tinggi tangki dan katup saling mengunci dan sulit dijelaskan ke siswa. Pompa berperan sebagai "tangki virtual" yang tingginya bisa diatur, setara secara fisika. Rak, tangki kedua, dan mode Isi/Tahan/Mati hilang.
- **Evaluasi kelayakan uji → Rev. 08**: zona A terbukti kokoh sebagai bukti utama, zona C lemah dan berisiko. Servo dihapus dan diganti **leher angsa** (level otomatis, tidak menyedot udara); kenop jadi target debit dengan kontrol PI; zona C + sensor kedua jadi opsional (paket lengkap). Ditambah kalibrasi volumetrik, katup searah, uji nol, dan skala tekanan kedua di panel.

Detail teknis lengkap, alasan tiap keputusan, dan estimasi biaya per komponen: lihat `catatan/konteks-dan-spesifikasi.md`.

---

*Nama repo (`mcu-flow-continuity-bernoulli`) sengaja platform-agnostic — desain belum mengunci mikrokontroler tertentu (Arduino Uno jadi asumsi kerja awal, bisa berubah).*
