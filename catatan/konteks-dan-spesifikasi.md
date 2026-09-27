# Spesifikasi & Keputusan

Acuan kerja utama. Sketsa: `desain/rancangan-alat.html` · hitungan: `desain/perhitungan/` · biaya: `anggaran/`.

## 1. Scope

- Dikerjakan: hardware + firmware sampai alat berfungsi dan terkalibrasi.
- Tidak termasuk: pengambilan data, analisis, penulisan skripsi, LKPD/instrumen penelitian.
- Komponen direimburse terpisah dari jasa. Termin usulan: DP 50%, pelunasan 50% saat serah terima.
- Prinsip client: input fisik mengontrol sistem, output mengikuti.

## 2. Desain Rev. 08

**Alur air:** tangki → pompa DC → katup searah → S1 → pipa lurus ≥ 20 cm → venturi (zona A) → tanjakan Δz 120 mm (zona B) → [zona C + S2] → ball valve → leher angsa (+5 cm) → corong → tangki.

| | Paket inti | Paket lengkap |
|---|---|---|
| Zona | A + B | A + B + C |
| Sensor flow | S1 (YF-S201) | S1 + S2 (YF-S401) |
| Tabung manometer | 5 (+ opsi pitot) | 6 |
| Syarat | — | Rugi tekanan S2 ≤ ± 90 mm di 6 L/min |

**Kontrol**
- Kenop = target debit, dikunci PI (S1 → PWM pompa).
- Pengaman: PWM dibatasi; pompa mati bila PWM maksimum tapi debit < 50% target selama > 3 detik.
- Tombol CEK: prediksi v dan Δh muncul setelah siswa mencatat bacaan.
- Servo dihapus. Leher angsa menjaga level kolom otomatis dan tekanan semua sadap tetap positif.

**Panel manometer**
- Skala 0–350 mm, nol = sumbu pipa bawah (datum).
- Garis merah z + skala kedua di tabung 4–5 → tekanan terbaca langsung.
- Peta pipa berkode warna, klem buang udara dan peredam per selang, semua tabung diameter sama.
- Uji nol: pompa mati → semua kolom ± 170 mm.

**Hidrostatis (P = ρgh):** uji nol sudah memperlihatkannya (tekanan sadap = ρg(170 − z)). Sensor tekanan tangki / probe kedalaman hanya jika hidrostatis masuk materi.

**Debit kerja:** 4–6 L/min (3 L/min pelengkap, aliran masih transisi).

Daftar komponen: RAB.

## 3. Syarat data valid

1. Ukur diameter dalam tiap sadap. Leher venturi paling kritis: Δh ∝ d⁻⁴, meleset 0,3 mm → ± 12%.
2. Tidak ada sensor flow di antara dua sadap yang dibandingkan; sadap jauh dari belokan.
3. Lubang sadap tegak lurus dinding, bebas duri.
4. Kalibrasi S1 dengan gelas ukur (≥ 5 ulangan per debit). Tanpa ini galat Δh ± 20%.
5. C_d = Q gelas ukur ÷ Q teori — hasil ukur, bukan angka perkiraan.
6. Uji Bernoulli: plot Δh(1↔2) vs Q² di ≥ 5 debit → garis lurus lewat nol (kemiringan teori 2,12 mm per (L/min)²).
7. Buang udara dan uji nol sebelum tiap sesi.

## 4. Biaya

- RAB: `anggaran/RAB-alat-praktikum-rev08.xlsx`.
- Perkiraan paket inti ± Rp4,1 juta (komponen ± Rp2,25 jt + kontingensi 10% + ongkir + jasa Rp1,5 jt); paket lengkap ± Rp4,5 juta.
- Target client Rp2 juta → kurangi scope atau naikkan budget.

## 5. Pertanyaan ke client

**Sebelum belanja**
1. BAB I–III: R&D alat atau verifikasi eksperimen?
2. Paket inti atau lengkap?
3. Kesepakatan tertulis: paket, harga, termin, kriteria penerimaan (mis. Δh venturi ± 10% dari prediksi di 3 debit), garansi, batas jasa alat vs isi skripsi.
4. Setuju servo dihapus (interaksi lewat kenop debit)?

**Untuk desain final**
5. Hidrostatis masuk materi?
6. Tabel data apa yang dibutuhkan untuk Bab IV?
7. Berapa variasi debit (saran ≥ 5)?
8. Toleransi error dari dosen?
9. Batas ukuran alat?
10. Deadline / jadwal sidang?

## 6. Log keputusan

| Rev. | Keputusan |
|---|---|
| awal | Scope hardware + firmware; repo `mcu-flow-continuity-bernoulli` (tidak terkunci ke Arduino). |
| 02 | S1 dan S2 harus di penampang berbeda (koreksi sketsa awal). |
| 03–06 | Gravity-fed + pompa Isi/Tahan/Mati — dibatalkan di Rev. 07. |
| — | Panel manometer: tekanan diukur langsung, bukan dihitung. |
| 06 | Test section 3 zona: venturi, tanjakan, penyempitan atas. |
| 07 | Pompa langsung, satu tangki: tinggi tangki dan katup saling mengunci, sulit dijelaskan ke siswa. |
| 08 | Setelah evaluasi: servo dihapus → leher angsa; kenop target debit + PI; zona C opsional; tambah katup searah, kalibrasi volumetrik, uji nol, skala kedua. Koreksi: Re 3.300 masih transisi; C_d hanya perkiraan. |
| 08 | RAB dibuat. |
