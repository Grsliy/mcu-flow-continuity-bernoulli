# Konteks & Spesifikasi Project

> Catatan hidup — diperbarui seiring diskusi dengan client. Ini acuan kerja utama, beda dari `draft-desain-awal.md` yang sudah usang.

## 1. Ringkasan Project

Freelance job: membuat **alat praktikum fluida dinamis berbasis mikrokontroler** untuk kebutuhan skripsi client. Mengacu ke tiga jurnal di folder `referensi/`, tapi tidak sekadar meniru — client ingin versi yang lebih **interaktif secara engineering** (ada kontrol input, bukan cuma sensor pasif).

## 2. Scope Kerja (Disepakati)

- **Yang dikerjakan**: hardware (rakit alat) + firmware (kode mikrokontroler) sampai alat berfungsi dan bisa dipakai ukur.
- **Yang TIDAK termasuk**: pengambilan data eksperimen, analisis data, penulisan laporan/skripsi — itu dikerjakan client sendiri.
- Alat dipakai client untuk **pengambilan data skripsi** → akurasi & kalibrasi krusial, bukan sekadar alat peraga demo.

## 3. Model Bisnis

- Biaya komponen (BOM) **direimburse terpisah** oleh client — bukan bagian dari fee jasa.
- Deadline: **longgar (>2 minggu)**, tidak perlu premi rush.
- Fee jasa dibayar terpisah dari dana komponen, skema disarankan: DP 50% saat mulai kerja, pelunasan 50% saat serah terima & alat terbukti berfungsi.
- Pengerja (freelancer) sudah familiar Arduino/elektronika — bukan pemula.
- Tidak ada requirement khusus dari dosen pembimbing soal metode/komponen — bebas asal alat berfungsi dan data valid.

## 4. Arah Desain Teknis (Berkembang)

### 4.1 Inti pengukuran (dari referensi)
- 2 sensor flow (hall-effect) dipasang di pipa **besar** dan **kecil** (efek venturi) — buktikan hukum kontinuitas (Q1=Q2) dan asas Bernoulli (ΔP dari kecepatan).
- Mikrokontroler (kemungkinan Arduino Uno, tapi nama repo sengaja platform-agnostic `mcu-*` biar tidak terkunci) baca pulsa sensor → hitung debit, volume, kecepatan, estimasi ΔP.
- LCD (kemungkinan upgrade 16x2 → 20x4 I2C) untuk tampilkan hasil.
- **Dua metode hitung tekanan sekarang berjalan berdampingan** (lihat §4.5): ΔP dari kecepatan (Bernoulli, ala Arumningrum) dan P dari ketinggian tangki sumber (P=ρgh, ala Mulianti) — bisa dibandingkan satu sama lain, bukan cuma satu metode teoritis.

### 4.1a Arsitektur fisik — REVISI: gravity-fed, bukan pompa-dorong-langsung
Setelah §4.5 ditambahkan, arsitektur alirannya direkonfigurasi supaya ketinggian tangki sumber jadi variabel tekanan yang nyata:

- **Tangki Sumber** diposisikan **elevated di atas rak/tower**, bukan sejajar dengan komponen lain.
- Air mengalir **turun karena gravitasi** dari Tangki Sumber → pipa besar+Sensor 1 → venturi+servo-valve → pipa kecil+Sensor 2 → Tangki Penampung di titik terendah. Ini mengikuti persis arsitektur rig asli di jurnal Shidqi & Mulianti (bukan konfigurasi "pompa mendorong air mendatar" yang sempat direncanakan di draft awal).
- Debit eksperimen sekarang murni fungsi dari **ketinggian tangki sumber** (tekanan hidrostatis) + **bukaan valve** (Fitur #2) — kombinasi dua variabel ini yang menentukan v1, v2, Q1, Q2 yang terbaca sensor.
- Pipa boleh (dan realistisnya akan) berkelok/naik-turun mengikuti tata letak fisik alat di atas meja — bukan garis lurus mendatar seperti di diagram blok sebelumnya (diagram blok itu tetap valid untuk hubungan sinyal, tapi bukan representasi bentuk fisik).

### 4.2 Fitur interaktif — REVISI PENTING
Interpretasi awal (Predict-Observe-Explain via tombol/encoder untuk "menebak" nilai) **sudah digantikan** oleh konsep yang lebih tepat menurut client:

> **Alat harus punya input yang benar-benar mengontrol kondisi fisik sistem, dan output (bacaan sensor) mengikuti input tersebut — bukan cuma sistem pasif yang mengikuti kondisi fisika tetap.**

Ada dua input fisik yang disepakati untuk ditambahkan:

#### 4.2.1 Kontrol pompa via PWM — Fitur #1 — REVISI PERAN
**Peran pompa berubah** menyusul keputusan di §4.5 (gravity-fed architecture):
- Pompa **bukan lagi** mendorong aliran eksperimen secara langsung — perannya sekarang **isi-ulang otomatis** Tangki Sumber dari Tangki Penampung, sampai ketinggian target tercapai (feedback dari sensor ultrasonik di §4.5).
- User tetap mengatur target (lewat potensiometer/tombol) — bedanya target itu sekarang **ketinggian**, bukan kecepatan aliran instan. Konsep "input mengontrol, output mengikuti" tetap berlaku, cuma levelnya closed-loop (isi sampai target, lalu berhenti otomatis).
- Manfaat tambahan: client bisa ambil banyak titik data di berbagai level ketinggian dengan mudah & presisi (lebih konsisten untuk Bab IV skripsi) dibanding mengisi manual pakai penggaris seperti di jurnal referensi.
- **Trade-off terbuka**: kalau client tetap ingin kontrol debit *real-time* langsung (bukan cuma isi-ulang), butuh pompa kedua terpisah untuk itu — nambah biaya. Saat ini didesain dengan 1 pompa (isi-ulang) sampai dikonfirmasi lain oleh client.

#### 4.2.2 Kontrol bukaan valve (luas penampang efektif) via servo — Fitur #2
- Servo motor memutar tuas kran/valve manual yang sudah ada di BOM ke sudut tertentu, dikontrol dari mikrokontroler.
- Secara fisika ini langsung mengubah variabel **A** (luas penampang efektif) — inti dari hukum kontinuitas (A1v1=A2v2), independen dari kecepatan pompa.
- Kombinasi dengan fitur #1: user bisa atur debit (pompa) **dan** bukaan valve (luas efektif) secara terpisah → bisa eksplorasi skenario seperti "debit dinaikkan tapi valve dikecilkan" — jauh lebih kaya daripada 1 variabel saja.
- Pertimbangan servo: SG90 (murah, ~Rp15rb) kemungkinan torsinya kurang kuat untuk memutar valve fisik melawan tekanan air — kemungkinan perlu servo torsi lebih besar (mis. MG995/MG996R, ~Rp45-60rb). Perlu dites langsung saat perakitan.
- Perlu kalibrasi hubungan sudut servo ↔ bukaan valve aktual ↔ debit yang dihasilkan.

**Catatan terbuka**: apakah elemen "prediksi dulu baru lihat hasil" (POE) masih relevan digabung dengan dua kontrol ini, atau sepenuhnya digantikan — belum final, perlu didiskusikan lagi saat kunci desain.

### 4.3 Komponen tambahan untuk fitur kontrol (#1 + #2 + #4)
| Komponen | Fungsi | Untuk fitur |
|---|---|---|
| Modul MOSFET logic-level (mis. IRLZ44N) | Jembatan sinyal PWM Arduino → daya pompa | #1 |
| Dioda flyback (1N4007) | Proteksi induksi balik dari pompa | #1 |
| Potensiometer / tombol | Set target ketinggian/kecepatan isi-ulang (input user) | #1 |
| Servo motor (SG90 atau MG995/MG996R jika perlu torsi lebih) | Putar tuas valve untuk atur bukaan | #2 |
| Bracket/dudukan servo ke valve | Mekanisme penghubung servo-valve (custom, kemungkinan cetak 3D atau akrilik) | #2 |
| Sensor ultrasonik (HC-SR04) | Ukur jarak permukaan air → hitung ketinggian di Tangki Sumber | #4 |
| Rak/tower penyangga Tangki Sumber | Struktur elevasi (kayu/akrilik/besi siku sederhana) | #4 |

### 4.5 Ketinggian tangki sumber sebagai variabel tekanan hidrostatis — Fitur #4

Mengacu langsung ke metode jurnal **Mulianti dkk.** — mereka menghitung "tekanan" langsung dari ketinggian air di tangki sumber pakai rumus **P=ρgh** (bukan sensor tekanan asli, bukan juga dari kecepatan/Bernoulli). Metode ini valid dan sudah pernah dipakai di penelitian sejenis, jadi aman diikuti lagi untuk skripsi client.

- Sensor ultrasonik (HC-SR04) dipasang di atas Tangki Sumber menghadap ke bawah, mengukur jarak ke permukaan air → dikonversi jadi ketinggian air (h) → dihitung P=ρgh secara real-time.
- Ketinggian ini divariasikan antar percobaan (mis. mengacu ke 7/14/21 cm seperti di jurnal Mulianti) — diisi ke level target via pompa (Fitur #1) dengan sensor ultrasonik sebagai feedback otomatis.
- Nilai P=ρgh ini bisa **dibandingkan langsung** dengan ΔP dari Bernoulli (kecepatan) — dua metode ukur tekanan sekaligus, nilai tambah kuat untuk pembahasan Bab IV/V skripsi (mana yang lebih konsisten, kenapa bisa beda, dst).

### 4.4 Fitur presentasi/engagement — Fitur #3 (bukan kontrol fisik baru)
Berbeda dari fitur #1 dan #2 (menambah variabel fisika yang bisa dikontrol), tiga fitur ini murni soal bagaimana sistem **terasa dan terlihat** — memanfaatkan komponen yang sudah direncanakan, hampir tanpa tambahan BOM.

- **Pewarna air** — beberapa tetes pewarna makanan di air sirkulasi, biar aliran kelihatan jelas di pipa akrilik bening (air bening susah diamati mata telanjang). Biaya nyaris nol, tanpa dampak firmware.
- **Sonifikasi (nada mengikuti kecepatan aliran)** — buzzer piezo (sudah direncanakan untuk feedback) diberi logika tambahan: pitch berubah real-time mengikuti debit. Efek "mendengar" fisika, bukan cuma membaca angka di LCD.
- **Mode tantangan target** — LCD menampilkan target (mis. "capai debit 50 mL/s!"), siswa atur pompa (fitur #1) + valve (fitur #2) untuk mencoba mencapai target, LED/buzzer kasih tanda saat berhasil dalam toleransi. Mengubah alat dari "alat ukur pasif" jadi "alat main sambil belajar" — gamifikasi ringan murni via kode, memanfaatkan komponen yang sudah ada.

## 5. Estimasi Biaya (Berjalan)

| Pos | Estimasi |
|---|---|
| BOM inti (sensor, Arduino, LCD, pompa, pipa, dll) | Rp455.000 – 760.000 |
| Tambahan BOM fitur #1 — kontrol PWM pompa | +Rp10.000 – 20.000 (MOSFET+dioda+potensio) |
| Tambahan BOM fitur #2 — servo valve | +Rp45.000 – 80.000 (servo torsi+bracket) |
| Ongkir & buffer belanja | Rp50.000 – 100.000 |
| Fee jasa dasar (versi lengkap: kontinuitas+Bernoulli) | Rp800.000 – 900.000 |
| Fee tambahan fitur #1 (kontrol PWM pompa) | +Rp150.000 – 250.000 |
| Fee tambahan fitur #2 (servo valve + kalibrasi sudut↔bukaan) | +Rp150.000 – 300.000 |
| Fee tambahan fitur #3 (pewarna+sonifikasi+mode tantangan) | +Rp75.000 – 150.000 |
| Tambahan BOM fitur #4 — sensor ultrasonik + rak/tower | +Rp30.000 – 80.000 (HC-SR04 + bahan rak sederhana) |
| Fee tambahan fitur #4 (sensor ketinggian + P=ρgh + isi-ulang otomatis) | +Rp100.000 – 200.000 |
| **Total estimasi ke client** | **± Rp1.865.000 – 2.840.000** |

*Client sudah paham dan setuju ada biaya tambahan untuk fitur interaktif ini — perlu dikonfirmasi ulang ke client karena kenaikan dari estimasi awal (Rp1,3-1,75jt) sudah cukup signifikan setelah fitur #2, #3, dan #4 ditambahkan. Belum termasuk potensi pompa kedua kalau client tetap ingin kontrol debit real-time terpisah dari isi-ulang ketinggian (lihat §4.2.1).*

## 6. Pertanyaan yang Masih Menggantung ke Client

Belum dikonfirmasi, tapi penting untuk kunci desain final & kalibrasi:
1. Judul/topik skripsi persisnya apa (kontinuitas, Bernoulli, atau dua-duanya setara)?
2. Data seperti apa yang dibutuhkan untuk Bab IV (tabel apa saja)?
3. Variasi percobaan yang direncanakan (variasi debit via PWM sudah confirmed jadi bagian dari alat — tapi berapa banyak titik/level yang direncanakan)?
4. Ada ekspektasi toleransi error dari dosen pembimbing (mis. <10% seperti di jurnal referensi)?
5. Ada batasan ukuran fisik alat (harus dibawa ke kampus/lab tertentu)?
6. Deadline pasti (tanggal target selesai / rencana sidang)?

## 7. Log Keputusan

- **Repo GitHub**: nama disarankan `mcu-flow-continuity-bernoulli`, private (belum di-push).
- **Folder project**: `referensi/` (3 jurnal), `catatan/` (dokumen kerja, termasuk file ini).
- Firmware versi pertama (kombinasi 3 konsep tanpa kontrol PWM) sudah dihapus — akan ditulis ulang setelah desain final terkunci (termasuk fitur kontrol PWM, servo valve, & keputusan soal POE).
- Fitur #2 (kontrol bukaan valve via servo) ditambahkan sebagai fitur interaktif kedua — perlu konfirmasi ulang ke client soal kenaikan biaya karena signifikan dari estimasi awal (lihat §5).
- Fitur #3 (pewarna air, sonifikasi nada, mode tantangan target) ditambahkan sebagai fitur presentasi/engagement — murni software+komponen yang sudah ada, dampak biaya kecil dibanding fitur #1 dan #2.
- **Fitur #4 ditambahkan** (ketinggian tangki sumber sebagai variabel tekanan hidrostatis, P=ρgh ala Mulianti) — ini memicu **revisi arsitektur fisik** jadi gravity-fed (§4.1a): Tangki Sumber elevated di rak, air turun karena gravitasi, pompa (Fitur #1) berubah peran jadi isi-ulang otomatis alih-alih dorong aliran langsung. Perlu dikonfirmasi ke client apakah reframing peran pompa ini bisa diterima, atau tetap butuh kontrol debit real-time terpisah (→ pompa kedua, biaya tambahan).
- Sketsa sistem (diagram blok) sudah dipublikasikan sebagai artifact — akan ditambah versi tampak samping (physical layout) yang menunjukkan elevasi & routing pipa nyata.
