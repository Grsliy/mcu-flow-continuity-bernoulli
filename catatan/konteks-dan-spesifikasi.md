# Konteks & Spesifikasi Project

> Catatan hidup — diperbarui seiring diskusi dengan client. Ini acuan kerja utama. Sketsa aktif: `desain/rancangan-alat.html`; hitungan dimensi: `desain/perhitungan/`. Materi usang ada di `arsip/`.

## 1. Ringkasan Project

Freelance job: membuat **alat praktikum fluida dinamis berbasis mikrokontroler** untuk kebutuhan skripsi client. Mengacu ke tiga jurnal di folder `referensi/`, tapi tidak sekadar meniru — client ingin versi yang lebih **interaktif secara engineering** (ada kontrol input, bukan cuma sensor pasif).

## 2. Scope Kerja (Disepakati)

- **Yang dikerjakan**: hardware (rakit alat) + firmware (kode mikrokontroler) sampai alat berfungsi dan bisa dipakai ukur.
- **Yang TIDAK termasuk**: pengambilan data eksperimen, analisis data, penulisan laporan/skripsi — itu dikerjakan client sendiri.
- Alat dipakai client untuk **pengambilan data skripsi** → akurasi & kalibrasi krusial, bukan sekadar alat peraga demo.
- **Usulan tambahan (belum disepakati, lihat §6):** freelancer menyerahkan alat + **laporan kalibrasi**; metodologi dan validitas data skripsi tetap tanggung jawab client.

## 3. Model Bisnis

- Biaya komponen (BOM) **direimburse terpisah** oleh client — bukan bagian dari fee jasa.
- Deadline: **longgar (>2 minggu)**, tidak perlu premi rush.
- Fee jasa dibayar terpisah dari dana komponen, skema disarankan: DP 50% saat mulai kerja, pelunasan 50% saat serah terima & alat terbukti berfungsi.
- Pengerja (freelancer) sudah familiar Arduino/elektronika — bukan pemula.
- Tidak ada requirement khusus dari dosen pembimbing soal metode/komponen — bebas asal alat berfungsi dan data valid. *(Catatan: kemungkinan berarti dosen belum melihat desainnya — lihat §6.)*

## 4. Arah Desain Teknis (Rev. 08)

### 4.1 Inti pengukuran
- **S1 (YF-S201)** mengukur debit di pipa besar. **Wajib dikalibrasi volumetrik** (gelas ukur + stopwatch di ujung leher angsa) — akurasi pabrik ± 10% dan rentang kerja kita ada di ujung bawah rentangnya.
- **Panel manometer** membaca tekanan statis langsung: tabung 1–5 (paket inti), tabung 6 opsional (lihat Fitur #5).
- **S2 (YF-S401) opsional** — hanya di paket lengkap, dengan syarat lolos uji rugi tekanan (lihat §4.2).
- **Dua jalur debit yang independen**: (a) Q dari S1 terkalibrasi, dengan **gelas ukur sebagai acuan**; (b) Q dari selisih kolom venturi (v₁ = √(2gΔh / ((A₁/A₂)² − 1))). Perbandingan keduanya = **C_d hasil ukur**.
- Mikrokontroler (Arduino Uno atau setara; nama repo sengaja platform-agnostic `mcu-*`): baca pulsa S1, kontrol PI debit, hitung v dan prediksi Δh.
- LCD (16x2 atau 20x4 I2C) untuk tampilkan hasil.

### 4.2 Arsitektur fisik — satu tangki, pompa langsung, leher angsa
- **Satu tangki** akrilik di pelat dasar alat. **Pompa celup DC** di dalamnya mendorong air langsung; **katup searah** (tipe swing/flapper, tekanan buka rendah) di keluaran pompa menahan air di pipa saat pompa mati.
- Aliran: tangki → pompa → katup searah → **S1** → **≥ 20 cm pipa lurus** (± 10D, meredam pusaran kincir S1) → sadap 1 → **zona A** venturi mendatar → **zona B** tanjakan (Δz = 120 mm, penampang tetap) → [**zona C** + **S2**, opsional] → **ball valve manual** → **leher angsa** → air jatuh bebas ke corong → pipa balik ke tangki (diarahkan menjauhi hisapan pompa supaya gelembung tidak tersedot).
- **Leher angsa**: pipa balik naik dulu sampai ujung keluarnya **± 5 cm di atas pipa atas** (± 170 mm dari datum), lalu air **jatuh bebas** ke corong terbuka. Pipa turun **tidak boleh** disambung rapat (bisa jadi sifon). Efeknya: pipa uji selalu penuh, tekanan di semua sadap otomatis positif (tidak menyedot udara), level kolom mengatur dirinya sendiri, dan ujung keluarnya jadi titik kalibrasi gelas ukur.
- Energi aliran berasal dari pompa ("tinggi setara"/head pompa). Secara fisika setara dengan tangki tinggi: selisih kolom hanya bergantung pada Q dan ukuran pipa.

| | Paket inti | Paket lengkap |
|---|---|---|
| Zona | A (venturi) + B (tanjakan) | A + B + C (menyempit di atas) |
| Sensor flow | S1 | S1 + S2 |
| Tabung manometer | 5 (+ opsi tabung 6 = pitot) | 6 |
| Target budget | ± Rp2 juta (belum dihitung ulang) | Di atas paket inti |
| Syarat | — | S2 lolos uji: rugi tekanan ≤ ± 90 mm di 6 L/min (lihat `desain/perhitungan/02-profil-manometer.md`) |

- Sketsa acuan: `desain/rancangan-alat.html` (Rev. 08).
- Debit kerja: **demonstrasi & data utama 4–6 L/min**; 3 L/min hanya pelengkap (Re ± 3.300 masih zona transisi). Hitungan: `desain/perhitungan/01-pipa-dan-debit.md`.

*Arsitektur lama gravity-fed (tangki sumber di rak + tangki penampung, Rev. 03–06) dibatalkan — lihat §7.*

### 4.3 Fitur interaktif
Prinsip yang disepakati client:

> **Alat harus punya input yang benar-benar mengontrol kondisi fisik sistem, dan output (bacaan sensor) mengikuti input tersebut — bukan cuma sistem pasif.**

*(Interpretasi awal Predict-Observe-Explain sudah digantikan prinsip ini. Elemen "prediksi dulu baru lihat hasil" hidup lagi lewat tombol CEK di Fitur #3.)*

#### Fitur #1 — Kenop target debit (kontrol PI)
- Kenop = **target debit (L/min)**, bukan PWM mentah. Firmware menjalankan kontrol **PI dari S1 ke PWM pompa** sehingga debit terkunci — ini input utama siswa: putar kenop → debit berubah → selisih kolom manometer mengikuti (Δh ∝ Q²).
- PI hanya seakurat S1 → **kalibrasi S1 dulu** (tabel faktor-K per debit masuk firmware).

Syarat teknis:
- **Pompa celup DC 12 V** + driver MOSFET + dioda flyback.
- **PWM di bawah ~30–40% biasanya tidak memutar pompa** (stall). Rentang efektif dites & dicatat saat kalibrasi.
- **Pengaman luapan (firmware)**: batas PWM maksimum, dan kalau PWM sudah maksimum tapi debit < 50% target selama > 3 detik (katup tertutup/tersumbat) → **pompa dimatikan**.
- **Denyut pompa** bisa membuat kolom bergetar → peredam (restriktor kecil) di selang tiap tabung.

#### Fitur #2 — Servo katup: **DIHAPUS (Rev. 08)**
- Alasan: servo hanya mengatur level kolom, padahal level tidak mengubah fisikanya (selisih antar kolom tetap). Servo justru membawa masalah: kenop katup ikut mengubah debit, bisa menyedot udara kalau level diturunkan terlalu jauh, dan bisa meluap kalau menutup saat alat baru dinyalakan.
- Pengganti: **leher angsa** (level otomatis & aman) + **ball valve manual** untuk penyetelan/buang udara/perawatan — bukan kenop praktikum (letak di belakang atau tuas dilepas).
- Demo "katup menggeser semua kolom bersama" masih bisa ditunjukkan pengajar lewat ball valve, dengan hati-hati.
- Hemat ± Rp200–400 rb (komponen servo + bracket + fee kalibrasi).

#### Fitur #3 — Presentasi & engagement
- **Tombol CEK — prediksi di balik tombol**: LCD menampilkan v₁, v leher, dan **prediksi Δh kolom 1↔2** hanya setelah tombol ditekan, yaitu sesudah siswa mencatat bacaan manometer. Tujuannya: prediksi tidak jadi kunci jawaban dan tidak membuat bacaan bias.
- **Pewarna air** — hanya untuk kontras kolom manometer. Pewarna yang disuntik untuk memperlihatkan aliran tidak dipakai: di sirkuit tertutup, seluruh tangki langsung ikut berwarna.
- **Sonifikasi** — pitch buzzer mengikuti debit real-time.
- **Mode tantangan** — target fisik yang terlihat, mis. *"atur debit sampai selisih kolom 1 dan 2 tepat 50 mm"*.

#### Fitur #4 — Hidrostatis P = ρgh
- **Gratis dari desain Rev. 08 (uji nol)**: pompa mati, katup searah menahan air → semua kolom setinggi ujung leher angsa (± 170 mm). Tekanan tiap sadap = ρg(170 − z): sadap di z = 0 → 170 mm, sadap di z = 120 → 50 mm. Siswa melihat tekanan di fluida diam bergantung pada kedalaman.
- Catatan: ini tetap **memakai** manometer, jadi belum **membuktikan** P = ρgh secara mandiri. Kalau hidrostatis masuk materi skripsi, butuh pengukuran tekanan dengan cara lain:

| "h" yang mana | Artinya | Di alat |
|---|---|---|
| Tinggi kolom manometer | Cara **membaca** tekanan | Setiap tabung (memakai, bukan membuktikan) |
| Ketinggian pipa | Suku **ρgh di Bernoulli** | Zona B, kolom 3 ↔ 5 |
| Kedalaman air | **Hidrostatis** | Uji nol (gratis) / opsi A–B di bawah |

- Opsi A: sensor tekanan analog (0–10 kPa) di dasar tangki + HC-SR04 di tutup; pompa mati, tangki diisi/dikuras bertahap → grafik P vs h lurus (metode Mulianti dkk.).
- Opsi B: **probe kedalaman** — corong bermembran dicelup di kedalaman 5/10/15 cm, disambung manometer U (+ sensor tekanan opsional).
- **Menunggu jawaban client** (§6) apakah hidrostatis masuk materi.

#### Fitur #5 — Panel manometer
Mengikuti alat peraga Bernoulli standar lab teknik (referensi foto dari client).

- Titik sadap (nipple, tercetak menyatu dengan venturi) → selang bening → tabung vertikal berskala **0–350 mm**, angka 0 sejajar sumbu pipa bawah (datum).
- **Garis merah z** di tabung yang titik sadapnya lebih tinggi (tabung 4 di 60 mm, tabung 5 & 6 di 120 mm) + **skala kedua** yang nolnya di garis itu → tekanan terbaca langsung tanpa berhitung. Tanpa ini siswa akan salah baca (di 6 L/min kolom 5 terbaca ± 190 mm padahal tekanannya hanya ± 70 mm).
- **Peta pipa berkode warna** di panel: nomor/warna yang sama pada sadap, selang, dan tabung.
- **Buang udara**: klem/katup kecil per selang + SOP pemancingan sebelum ambil data. Udara di selang = penyebab gagal nomor satu alat seperti ini.
- **Uji nol** sebelum tiap sesi (pompa mati → semua kolom harus sama tinggi) → offset kapiler & datum terukur.
- Semua tabung **diameter dalam sama** (6–8 mm) supaya kenaikan kapiler sama dan hilang saat dikurangkan.
- **Tabung 6 (opsional)**: zona C di paket lengkap, **atau** tabung pitot (head total) di leher venturi pada paket inti — kolomnya tetap ± setinggi kolom 1 saat kolom 2 turun, sehingga kekekalan energi terlihat langsung tanpa bergantung pada S1.

### 4.4 Komponen (Rev. 08)
| Komponen | Fungsi | Paket |
|---|---|---|
| Pompa celup DC 12 V (bisa PWM) | Mendorong aliran langsung | inti |
| Modul MOSFET logic-level (mis. IRLZ44N) + dioda flyback (1N4007) | PWM → daya pompa, proteksi | inti |
| 1 potensiometer + 1 tombol | Target debit, tombol CEK | inti |
| Katup searah swing/flapper, tekanan buka rendah | Tahan air saat pompa mati (bukan tipe pegas biasa — memakan head) | inti |
| Ball valve 3/4" manual | Penyetelan, buang udara, perawatan | inti |
| Pipa + fitting leher angsa + corong | Level otomatis, anti sedot udara, titik kalibrasi | inti |
| Venturi cetak 3D (PETG), satu badan dengan nipple sadap | Zona A; CAD parametrik dari ID pipa terukur | inti |
| Gelas ukur 1–2 L + stopwatch | Kalibrasi volumetrik S1 | inti |
| Tabung bening Ø dalam 6–8 mm + papan skala (+ garis merah z, skala kedua) | Panel manometer | inti |
| Nipple + selang bening + klem kecil per selang | Sadap → tabung, buang udara | inti |
| Restriktor/peredam kecil per selang | Redam getaran kolom | inti |
| Jarum/tabung kecil menghadap arus di leher | Tabung pitot (opsi tabung 6) | opsional |
| Reducer 19 → 13 mm + YF-S401 | Zona C + S2 | lengkap |
| Sensor tekanan 0–10 kPa + HC-SR04 / probe kedalaman | Demo hidrostatis opsi A / B | opsional |

### 4.5 Syarat agar pembuktian valid
Gampang terlewat saat fabrikasi, tapi bisa membatalkan validitas seluruh data:

1. **Luas penampang tiap titik sadap wajib diukur presisi.** Paling kritis: **diameter leher venturi** — Δh ∝ d⁻⁴, jadi leher 10 mm yang meleset 0,3 mm menggeser Δh ± 12%. Ukur leher setelah dicetak, masukkan nilainya ke firmware.
2. **Sensor flow tidak boleh berada di antara dua titik sadap yang dibandingkan**, dan harus ada **≥ 20 cm pipa lurus** antara S1 dan sadap 1 (pusaran dari kincir). Sadap juga dijauhkan ± 5D dari belokan.
3. **Lubang sadap harus tegak lurus dinding dan bebas duri.** Lubang miring/berduri bikin yang terbaca bukan tekanan statis murni.
4. **Acuan debit = gelas ukur, bukan S1 mentah.** Kalibrasi S1 di ujung leher angsa, ≥ 5 pengulangan per debit, hasilnya jadi tabel faktor-K di firmware. Tanpa ini galat Q ± 10% → galat prediksi Δh ± 20%.
5. **Kontinuitas**: dibuktikan lewat Q S1 terkalibrasi = Q gelas ukur, ditambah v leher dari Δh (v berbeda di penampang berbeda). Kalau S2 dipakai, keduanya wajib terkalibrasi — tanpa kalibrasi, selisih antar-sensor akan terbaca "kontinuitas gagal".
6. **C_d harus hasil ukur**: C_d = Q gelas ukur ÷ Q teori venturi. Angka C_d di file perhitungan 02 hanya perkiraan dari koefisien rugi asumsi — **jangan ditulis sebagai hasil**.
7. **Uji Bernoulli yang bisa gagal**: plot Δh kolom 1↔2 terhadap Q² di ≥ 5 debit (mis. 4,0 / 4,5 / 5,0 / 5,5 / 6,0 L/min). Harus linear dan melewati nol; kemiringan teori ± 2,12 mm per (L/min)².
8. **Suku ρgh Bernoulli** dibuktikan di zona B: kolom 3, 4, 5 sama tinggi pada penggaris bersama, sementara skala kedua menunjukkan tekanannya turun.
9. **Uji nol dan buang udara** sebelum tiap sesi pengambilan data.

## 5. Estimasi Biaya (Berjalan)

> ⚠️ **Belum dihitung ulang untuk Rev. 08.** Perubahan sejak tabel lama: rak & tangki kedua hilang, servo dihapus (hemat ± Rp200–400 rb), pompa AC diganti DC PWM, tambahan katup searah + ball valve + leher angsa + venturi cetak 3D + gelas ukur. Target kerja: **paket inti ± Rp2 juta total** (belum dikonfirmasi client). Estimasi Rev. 06 (Rp3,0–5,4 jt) ada di `arsip/gravity-fed/estimasi-budget-rev06.html`.

<details>
<summary>Tabel lama (Rev. 05–06, acuan kasar saja)</summary>

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

</details>

## 6. Pertanyaan & Kesepakatan dengan Client

**Prioritas tinggi (memblokir belanja komponen):**
1. **Minta BAB I–III** (minimal judul, rumusan masalah, metode). Menentukan jenis skripsi: **pendidikan/R&D alat** (prioritas: kokoh, konsisten, mudah dibaca) atau **fisika/verifikasi eksperimen** (prioritas: akurasi & kalibrasi) — dan karenanya zona/sensor mana yang benar-benar perlu.
2. **Pilih paket**: inti (A+B, ± Rp2 juta) atau lengkap (+ zona C & S2, syarat lolos uji S2).
3. **Kesepakatan tertulis satu halaman**: paket yang dipilih; **kriteria penerimaan terukur** (mis. *"Δh venturi dalam ± 10% prediksi pada 3 debit, dengan S1 terkalibrasi volumetrik"*); freelancer menyerahkan alat + laporan kalibrasi; metodologi & validitas data tanggung jawab client.
4. **Konfirmasi penghapusan servo** (Fitur #2) — interaksi utama pindah ke kenop target debit.

**Untuk kunci desain final & kalibrasi:**
5. Apakah hidrostatis (P = ρgh) ikut masuk materi? Menentukan Fitur #4 (cukup uji nol, atau opsi A/B).
6. Data seperti apa yang dibutuhkan untuk Bab IV (tabel apa saja)?
7. Berapa variasi debit yang direncanakan? (Disarankan ≥ 5 titik di 4–6 L/min.)
8. Ada ekspektasi toleransi error dari dosen pembimbing (mis. < 10% seperti di jurnal referensi)?
9. Ada batasan ukuran fisik alat (muat di lab/meja yang dituju)?
10. Deadline pasti (tanggal target selesai / rencana sidang)?

## 7. Log Keputusan

- **Repo GitHub**: `github.com/Grsliy/mcu-flow-continuity-bernoulli` — sudah dibuat & di-push.
- **Folder project** (dirapikan 2026-09-27): `referensi/` (4 jurnal), `catatan/` (file ini), `desain/` (sketsa aktif + `perhitungan/`), `arsip/` (draft awal + materi gravity-fed Rev. 06).
- Firmware versi pertama sudah dihapus — akan ditulis ulang setelah desain final terkunci. Konsep POE (prediksi dulu) sudah digantikan kontrol fisik nyata; sisa jejaknya di tombol CEK dan mode tantangan (Fitur #3).
- Fitur #2 (kontrol bukaan valve via servo) ditambahkan sebagai fitur interaktif kedua — *dihapus lagi di Rev. 08*.
- Fitur #3 (pewarna air, sonifikasi nada, mode tantangan target) ditambahkan sebagai fitur presentasi/engagement — murni software+komponen yang sudah ada, dampak biaya kecil dibanding fitur #1 dan #2.
- **Fitur #4 ditambahkan** (ketinggian tangki sumber sebagai variabel tekanan hidrostatis, P=ρgh ala Mulianti) — ini memicu **revisi arsitektur fisik** jadi gravity-fed: Tangki Sumber elevated di rak, air turun karena gravitasi, pompa berubah peran jadi isi-ulang otomatis. *(Dibatalkan di Rev. 07.)*
- Sketsa sistem (diagram blok + tampak samping) sudah dibuat (kini di `arsip/gravity-fed/sketsa-sistem.html`).
- **Fitur #5 ditambahkan**: panel manometer 6 tabung, mengikuti referensi foto alat komersial dari client. Ini menjadikan tekanan **terukur langsung**, bukan lagi dihitung — peningkatan kredibilitas data yang paling besar sejauh ini, sekaligus tambahan biaya terbesar.
- **Koreksi desain penting**: sketsa versi pertama menaruh S1 dan S2 di penampang berukuran sama (venturi melebar kembali), sehingga v₁ = v₂ dan tidak membuktikan apa-apa. Diperbaiki di Rev. 02 dengan menambah reducer sebelum S2.
- **Peran pompa diperjelas**: tiga mode (Isi / Tahan / Mati). Mode Tahan = constant head tank elektronik. Rencana "pompa kedua" dibatalkan. *(Mode dihapus di Rev. 07.)*
- Bentuk fisik: **hybrid benchtop**, gaya lab kit putih–biru PVC–kuningan, ± 95 × 30 × 65 cm.
- Test section berkembang jadi **tiga zona** (A venturi mendatar, B segmen naik, C reducer di atas) — Rev. 06.
- **2026-09-27 — Arsitektur dibalik ke POMPA LANGSUNG, satu tangki (Rev. 07).** Alasan: pada gravity-fed, tinggi tangki dan katup saling mengunci (tinggi = atap energi, katup wajib selalu menutup sebagian karena bukaan penuh melampaui range S2), sulit dijelaskan ke siswa dan butuh rak + tangki kedua + logika Isi/Tahan/Mati. Secara fisika setara (pompa = "tangki virtual" dengan head yang bisa diatur). Konsekuensi: P = ρgh hidrostatis tidak lagi jadi penggerak aliran; pompa diganti DC PWM.
- **2026-09-27 — Evaluasi kelayakan uji (review multi-sudut) → Rev. 08.** Kesimpulan: zona A (venturi) kokoh sebagai bukti utama; zona B berhasil tapi butuh bantuan visual; zona C lemah dan berisiko (rugi tekanan YF-S401 belum diketahui). Keputusan:
  - **Servo dihapus**, diganti **leher angsa** + ball valve manual (level otomatis, anti sedot udara, hemat).
  - Kenop jadi **target debit dengan kontrol PI**; pengaman luapan di firmware.
  - **Paket inti = zona A + B**; zona C + S2 hanya paket lengkap dengan syarat lolos uji S2.
  - Tambahan wajib: katup searah, kalibrasi volumetrik S1 (gelas ukur), ≥ 20 cm pipa lurus setelah S1, garis merah z + skala kedua, peta pipa, buang udara per selang, uji nol, prediksi di balik tombol CEK.
  - Venturi dicetak 3D (PETG), bukan kerucut akrilik atau venturi bertingkat (bertingkat berperilaku seperti orifice).
  - Koreksi hitungan sebelumnya: Re 3.300 masih zona transisi (bukan turbulen penuh); C_d 0,97/0,89 hanya perkiraan dari koefisien asumsi; kenop pompa & katup ternyata tidak independen tanpa kontrol PI.
