# Konteks & Spesifikasi Project

> Catatan hidup — diperbarui seiring diskusi dengan client. Ini acuan kerja utama. Sketsa aktif: `desain/rancangan-alat.html`; hitungan dimensi: `desain/perhitungan/`. Materi usang ada di `arsip/`.

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

### 4.1 Inti pengukuran
- **2 sensor flow** (hall-effect) mengukur debit: S1 di pipa **besar** (A₁), S2 di pipa **kecil** setelah reducer (A₂).
- **Panel manometer 6 tabung** membaca tekanan statis **langsung** di 6 titik sepanjang test section — ini sumber data tekanan utama (lihat Fitur #5).
- **Debit diukur dua jalur independen**: langsung dari S1, dan tidak langsung dari selisih kolom manometer lebar ↔ sempit (prinsip venturimeter: v₁ = √(2gΔh / ((A₁/A₂)² − 1))). Kecocokan keduanya = bukti kontinuitas + Bernoulli.
- Mikrokontroler (Arduino Uno atau setara; nama repo sengaja platform-agnostic `mcu-*`) baca pulsa sensor → hitung debit, volume, kecepatan, lalu dibandingkan dengan pembacaan manometer.
- LCD (16x2 atau 20x4 I2C) untuk tampilkan hasil.

### 4.2 Arsitektur fisik — satu tangki, pompa langsung (Rev. 07, FINAL)
- **Satu tangki** akrilik duduk di pelat dasar alat. Tidak ada rak tinggi, tidak ada tangki kedua.
- **Pompa celup DC** di dalam tangki mendorong air **langsung** ke test section; debit diatur PWM. Air kembali ke tangki yang sama lewat pipa belakang (sirkuit tertutup).
- Aliran: Tangki → pompa → pipa besar + **S1** → **zona A** venturi mendatar → **zona B** segmen naik (Δh ≈ 12 cm, penampang tetap) → **zona C** reducer di atas + **S2** → kran pembuang udara → **katup hilir servo** → kembali ke tangki.
- Energi aliran berasal dari pompa ("tinggi setara"/head pompa), bukan dari tinggi air tangki. Secara fisika setara: pada Q yang sama, bacaan manometer identik dengan versi tangki tinggi. Selisih kolom hanya bergantung pada Q dan ukuran pipa.
- **Penting**: S1 dan S2 wajib di penampang yang benar-benar berbeda (A₁ ≠ A₂). Sketsa versi pertama keliru menaruh keduanya di pipa berukuran sama — sudah dikoreksi dengan reducer sebelum S2.
- Sketsa acuan: `desain/rancangan-alat.html` (Rev. 07).
- Debit kerja **3–6 L/min** (hitungan: `desain/perhitungan/01-pipa-dan-debit.md`).

*Arsitektur lama gravity-fed (tangki sumber di rak + tangki penampung, Rev. 03–06) dibatalkan — lihat §7.*

### 4.3 Fitur interaktif
Prinsip yang disepakati client:

> **Alat harus punya input yang benar-benar mengontrol kondisi fisik sistem, dan output (bacaan sensor) mengikuti input tersebut — bukan cuma sistem pasif.**

*(Interpretasi awal Predict-Observe-Explain sudah digantikan prinsip ini. Elemen "prediksi dulu baru lihat hasil" masih bisa dihidupkan di dalam mode tantangan, tapi bukan konsep utamanya.)*

#### Fitur #1 — Kontrol debit via PWM pompa
- Kenop pompa → PWM → **debit Q**. Q menentukan semua kecepatan, dan karenanya **selisih** antar kolom manometer (Δh ∝ Q²).
- Mode Isi/Tahan/Mati dari desain gravity-fed **dihapus** — tidak relevan lagi.
- **Mode Q-konstan (opsional)**: firmware menahan debit target (kontrol proporsional/PID dari S1) walau katup diputar, sehingga siswa bisa mengubah satu variabel saja.

Syarat teknis:
- **Pompa celup DC 12 V** yang bisa di-PWM + driver MOSFET. Pompa AC 800 L/jam dari rancangan lama tidak bisa diatur halus.
- **PWM di bawah ~30–40% biasanya tidak memutar pompa** (stall). Rentang efektif harus dites & dicatat saat kalibrasi.
- **Denyut pompa** bisa membuat kolom manometer bergetar → pasang peredam (restriktor kecil) di selang tiap tabung.
- Operasi praktikum yang disarankan: **± 4–6 L/min** (di bawah itu selisih kolom venturi hanya beberapa mm, sulit dibaca).

#### Fitur #2 — Katup hilir via servo
- Servo memutar katup di **ujung hilir** test section. Fungsinya mengatur **letak** (level) semua kolom manometer: menutup katup → semua kolom naik bersama, pola/selisihnya tetap. Juga ikut menurunkan Q kalau pompa tidak dikompensasi (lihat mode Q-konstan).
- Pembagian tugas: **kenop pompa = selisih kolom (kecepatan)**, **kenop katup = level kolom (tekanan sistem)**.
- **Risiko meluap**: katup terlalu tertutup / pompa terlalu kencang → kolom melewati tinggi tabung. Firmware wajib membatasi kombinasi PWM–sudut katup; tinggi tabung final menunggu hitungan dimensi ulang (kemungkinan ± 500 mm, atau manifold udara di atas tabung seperti alat komersial).
- Pertimbangan servo: SG90 (~Rp15rb) kemungkinan kurang torsi melawan tekanan air — siapkan opsi MG995/MG996R (~Rp45–60rb). Perlu dites saat perakitan.
- Perlu kalibrasi hubungan sudut servo ↔ bukaan aktual ↔ debit yang dihasilkan.

#### Fitur #3 — Presentasi & engagement (tanpa kontrol fisik baru)
- **Pewarna air** — aliran jadi terlihat jelas di pipa akrilik bening. Biaya nyaris nol, tanpa dampak firmware.
- **Sonifikasi** — pitch buzzer mengikuti debit real-time; fisika jadi terdengar, bukan cuma terbaca.
- **Mode tantangan** — sekarang bisa memakai target fisik yang terlihat, mis. *"atur pompa & katup sampai selisih tinggi kolom manometer 1 dan 3 mencapai X mm"*. Jauh lebih konkret daripada target angka di LCD.

#### Fitur #4 — Demo hidrostatis P = ρgh (terpisah, opsional)
Dengan pompa langsung, tinggi air tangki **tidak lagi menggerakkan aliran**. P = ρgh tetap muncul di tiga tingkat:

| "h" yang mana | Artinya | Di alat |
|---|---|---|
| Tinggi kolom manometer | Cara **membaca** tekanan | Setiap tabung (memakai, bukan membuktikan) |
| Ketinggian pipa | Suku **ρgh di Bernoulli** | Zona B, kolom 3 ↔ 5 |
| Kedalaman air | **Hidrostatis** | Demo terpisah ini |

- Membuktikan P = ρgh (bukan sekadar memakainya) butuh tekanan yang diukur **dengan cara lain** lalu dibandingkan dengan ρgh — kalau hanya pakai manometer, argumennya sirkular.
- Opsi A: sensor tekanan analog (0–10 kPa) di dasar tangki + HC-SR04 di tutup; pompa mati, tangki diisi/dikuras bertahap → grafik P vs h lurus (metode Mulianti dkk.).
- Opsi B (disarankan kalau hidrostatis masuk materi): **probe kedalaman** — corong bermembran dicelup di kedalaman 5/10/15 cm, disambung manometer U (+ sensor tekanan opsional). Siswa mengubah kedalaman, Δh ≈ d.
- Kalau skripsi hanya kontinuitas & Bernoulli, fitur ini bisa dibuang untuk hemat budget (suku ρgh Bernoulli sudah terbukti di zona B). **Menunggu jawaban client** (§6).

#### Fitur #5 — Panel manometer 6 tabung (BARU)
Mengikuti alat peraga Bernoulli standar lab teknik (referensi foto dari client).

- 6 titik sadap (nipple kuningan) di sepanjang venturi → selang bening → 6 tabung vertikal berskala 0–300 mm.
- Tinggi kolom air = **tekanan statis terukur langsung** di titik itu. Murni mekanik, tidak butuh elektronik sama sekali.
- Pola yang terlihat: tinggi di sisi masuk → jatuh tajam di leher → pulih sebagian di sisi keluar (tidak penuh, karena rugi gesek).
- **Ini mengubah peran hitungan lain**: ΔP dari kecepatan (½ρv²) berubah dari "hasil utama" jadi **pembanding teori vs pengukuran** — justru bagus untuk pembahasan skripsi (hitung persen error antara keduanya).
- Jumlah sadap masih bisa dikurangi jadi 4–5 kalau mau lebih murah & lebih kecil risiko bocor (6 dipakai di gambar supaya terlihat profesional).

### 4.4 Komponen tambahan (per fitur)
| Komponen | Fungsi | Fitur |
|---|---|---|
| Modul MOSFET logic-level (mis. IRLZ44N) | Jembatan sinyal PWM → daya pompa | #1 |
| Dioda flyback (1N4007) | Proteksi induksi balik dari pompa | #1 |
| 2 potensiometer / kenop | Input user: debit (pompa) & level (katup) | #1, #2 |
| Pompa celup DC 12 V (bisa PWM) | Mendorong aliran langsung | #1 |
| Servo motor (SG90 / MG995 / MG996R) | Putar tuas katup hilir | #2 |
| Bracket servo ke katup | Penghubung mekanik (cetak 3D / akrilik) | #2 |
| Sensor tekanan analog 0–10 kPa + HC-SR04 | Demo P = ρgh (opsi A), opsional | #4 |
| Corong + membran + manometer U | Probe kedalaman (opsi B), opsional | #4 |
| Restriktor/peredam kecil per selang | Redam getaran kolom akibat denyut pompa | #5 |
| 6 tabung bening Ø6–8 mm + papan berskala | Panel manometer | #5 |
| 6 nipple kuningan + selang bening | Titik sadap tekanan → tabung | #5 |
| Reducer pipa besar → kecil | Bikin A₂ ≠ A₁ supaya S2 bermakna | inti |

### 4.5 Syarat agar ketiga konsep benar-benar terbukti
Gampang terlewat saat fabrikasi, tapi bisa membatalkan validitas seluruh data:

1. **Luas penampang tiap titik sadap wajib diukur presisi** (jangka sorong, dicatat satu per satu). Tanpa A yang akurat, v tidak bisa dihitung dan pembuktian jadi kualitatif belaka.
2. **Lubang sadap harus tegak lurus dinding dan bebas duri.** Lubang miring/berduri bikin yang terbaca bukan tekanan statis murni — seluruh data Bernoulli ikut meleset. Ini bagian paling menuntut ketelitian saat perakitan.
3. **Q₁ = Q₂ itu "otomatis benar"** (kekekalan massa, aliran tunggal tanpa cabang). Selisihnya hanya menunjukkan error kalibrasi atau kebocoran — bukan pembuktian fisika. Yang membuktikan kontinuitas adalah **kecepatan berbeda di penampang berbeda** (v = Q/A).
4. **Pembuktian yang tidak sirkular** butuh dua jalur independen: (a) v dari sensor debit (Q/A), dan (b) v yang diturunkan dari beda tekanan manometer lewat persamaan Bernoulli. Kalau keduanya cocok, barulah kontinuitas & Bernoulli terbukti secara eksperimental.
5. **Suku ρgh Bernoulli** dibuktikan di zona B (pipa naik, penampang tetap): kolom 3, 4, 5 harus sama tinggi pada penggaris bersama. Untuk mengubah bacaan jadi tekanan (Pa), kurangi dulu dengan ketinggian titik sadap; untuk membandingkan energi antar titik, pakai angka penggaris langsung (tinggi piezometrik).
6. **Kalibrasi sensor flow wajib** — konstanta pulsa/liter pabrikan biasanya meleset; validasi dengan gelas ukur + stopwatch, minimal 5 pengulangan (mengikuti metode jurnal referensi).

## 5. Estimasi Biaya (Berjalan)

> ⚠️ **Tabel di bawah belum diperbarui ke Rev. 07.** Perubahan yang perlu dihitung ulang: rak & tangki kedua hilang (hemat), pompa AC 800 L/jam diganti pompa DC PWM, fee #1 & #4 berubah isi, tabung manometer mungkin lebih tinggi. Estimasi budget terakhir (Rp3,0–5,4 jt untuk Rev. 06) ada di `arsip/gravity-fed/estimasi-budget-rev06.html`. Target kerja saat ini: **Rp2 juta total** (belum dikonfirmasi client).

| Pos | Estimasi |
|---|---|
| BOM inti (sensor flow, MCU, LCD, pipa, tangki, dll) | Rp455.000 – 760.000 |
| Tambahan BOM #1 — kontrol PWM pompa | +Rp10.000 – 20.000 (MOSFET+dioda+potensio) |
| Tambahan BOM #1b — upgrade pompa ke ~800 L/jam | +Rp30.000 – 50.000 (syarat mode Tahan) |
| Tambahan BOM #2 — servo valve | +Rp45.000 – 80.000 (servo torsi+bracket) |
| Tambahan BOM #4 — sensor ultrasonik + rak | +Rp30.000 – 80.000 (HC-SR04 + bahan rak) |
| Tambahan BOM #5 — panel manometer 6 tabung | +Rp100.000 – 200.000 (tabung, papan berskala, nipple, selang) |
| Ongkir & buffer belanja | Rp50.000 – 100.000 |
| **Subtotal komponen** | **Rp720.000 – 1.290.000** |
| Fee jasa dasar (kontinuitas + Bernoulli) | Rp800.000 – 900.000 |
| Fee #1 (kontrol PWM + kontrol level tiga mode) | +Rp150.000 – 250.000 |
| Fee #2 (servo valve + kalibrasi sudut↔bukaan) | +Rp150.000 – 300.000 |
| Fee #3 (pewarna + sonifikasi + mode tantangan) | +Rp75.000 – 150.000 |
| Fee #4 (sensor ketinggian + P=ρgh + isi/tahan otomatis) | +Rp100.000 – 200.000 |
| Fee #5 (6 titik sadap presisi + panel manometer + kalibrasi skala) | +Rp200.000 – 350.000 |
| **Subtotal jasa** | **Rp1.475.000 – 2.150.000** |
| **Total estimasi ke client** | **± Rp2.195.000 – 3.440.000** |

> ⚠️ **Angka ini sudah jauh dari estimasi awal** (Rp1,3–1,75jt saat kesepakatan pertama) — sekarang hampir dua kali lipat setelah Fitur #2, #3, #4, dan #5 masuk. **Wajib dikonfirmasi ulang ke client sebelum belanja apa pun.** Kalau budget jadi penghalang, urutan pemangkasan yang paling masuk akal: kurangi titik sadap 6 → 4 (hemat ±Rp80rb BOM + fee), lalu lepas Fitur #3 (hemat ±Rp150rb fee, tidak mengurangi validitas data sama sekali).
>
> Catatan lama soal "mungkin butuh pompa kedua" **sudah dibatalkan** — tidak diperlukan (lihat Fitur #1).

## 6. Pertanyaan yang Masih Menggantung ke Client

**Prioritas tinggi (memblokir belanja komponen):**
1. **Konfirmasi kenaikan biaya** ke ± Rp2,2–3,4jt (lihat peringatan di §5). Ini yang paling mendesak — jangan belanja sebelum ini disepakati.
2. Jumlah titik sadap manometer: **6** (seperti gambar, terlihat profesional) atau **4** (lebih murah, lebih kecil risiko bocor)?

**Untuk kunci desain final & kalibrasi:**
3. Judul/topik skripsi persisnya apa (kontinuitas, Bernoulli, atau dua-duanya setara)? **Apakah hidrostatis (P = ρgh) ikut masuk materi?** Menentukan apakah Fitur #4 dipertahankan, dan opsi A atau B.
4. Data seperti apa yang dibutuhkan untuk Bab IV (tabel apa saja)?
5. Berapa banyak variasi debit & bukaan katup yang direncanakan untuk pengambilan data?
6. Ada ekspektasi toleransi error dari dosen pembimbing (mis. <10% seperti di jurnal referensi)?
7. Ada batasan ukuran fisik alat (rancangan sekarang ± 95 × 30 × 65 cm — muat di lab/meja yang dituju)?
8. Deadline pasti (tanggal target selesai / rencana sidang)?

## 7. Log Keputusan

- **Repo GitHub**: `github.com/Grsliy/mcu-flow-continuity-bernoulli` — sudah dibuat & di-push.
- **Folder project** (dirapikan 2026-09-27): `referensi/` (4 jurnal), `catatan/` (file ini), `desain/` (sketsa aktif + `perhitungan/`), `arsip/` (draft awal + materi gravity-fed Rev. 06).
- Firmware versi pertama sudah dihapus — akan ditulis ulang setelah desain final terkunci. Konsep POE (prediksi dulu) sudah digantikan kontrol fisik nyata; sisa jejaknya cuma di mode tantangan (Fitur #3).
- Fitur #2 (kontrol bukaan valve via servo) ditambahkan sebagai fitur interaktif kedua — perlu konfirmasi ulang ke client soal kenaikan biaya karena signifikan dari estimasi awal (lihat §5).
- Fitur #3 (pewarna air, sonifikasi nada, mode tantangan target) ditambahkan sebagai fitur presentasi/engagement — murni software+komponen yang sudah ada, dampak biaya kecil dibanding fitur #1 dan #2.
- **Fitur #4 ditambahkan** (ketinggian tangki sumber sebagai variabel tekanan hidrostatis, P=ρgh ala Mulianti) — ini memicu **revisi arsitektur fisik** jadi gravity-fed (§4.1a): Tangki Sumber elevated di rak, air turun karena gravitasi, pompa (Fitur #1) berubah peran jadi isi-ulang otomatis alih-alih dorong aliran langsung. Perlu dikonfirmasi ke client apakah reframing peran pompa ini bisa diterima, atau tetap butuh kontrol debit real-time terpisah (→ pompa kedua, biaya tambahan).
- Sketsa sistem (diagram blok + tampak samping) sudah dibuat (kini di `arsip/gravity-fed/sketsa-sistem.html`).
- **Fitur #5 ditambahkan**: panel manometer 6 tabung, mengikuti referensi foto alat komersial dari client. Ini menjadikan tekanan **terukur langsung**, bukan lagi dihitung — peningkatan kredibilitas data yang paling besar sejauh ini, sekaligus tambahan biaya terbesar.
- **Koreksi desain penting**: sketsa versi pertama menaruh S1 dan S2 di penampang berukuran sama (venturi melebar kembali), sehingga v₁ = v₂ dan tidak membuktikan apa-apa. Diperbaiki di Rev. 02 dengan menambah reducer sebelum S2.
- **Peran pompa diperjelas**: tiga mode (Isi / Tahan / Mati). Mode Tahan = constant head tank elektronik, bikin data tunak & bisa diulang. Rencana "pompa kedua" dibatalkan — tidak diperlukan.
- Bentuk fisik final: **hybrid benchtop** (tangki di rak pendek menyatu dengan bodi), gaya lab kit putih–biru PVC–kuningan, ± 95 × 30 × 65 cm. Sketsa tampak depan sudah dibuat (Rev. 02).
- Test section berkembang jadi **tiga zona** (A venturi mendatar, B segmen naik, C reducer di atas) — Rev. 06.
- **2026-09-27 — Arsitektur dibalik ke POMPA LANGSUNG, satu tangki (Rev. 07, keputusan final).** Alasan: pada gravity-fed, tinggi tangki dan katup saling mengunci (tinggi = atap energi, katup wajib selalu menutup sebagian karena bukaan penuh melampaui range S2), sulit dijelaskan ke siswa dan butuh rak + tangki kedua + logika Isi/Tahan/Mati. Dengan pompa: kenop pompa = debit/selisih kolom, kenop katup = level kolom — langsung dan mudah dipahami. Secara fisika setara (pompa = "tangki virtual" dengan head yang bisa diatur). Konsekuensi: P = ρgh hidrostatis tidak lagi jadi penggerak aliran → dipindah jadi demo terpisah opsional (Fitur #4); pompa diganti DC PWM; perlu hitung ulang dimensi, tinggi tabung manometer, dan budget.
