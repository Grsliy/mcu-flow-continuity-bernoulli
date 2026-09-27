# Bagian 1 — Pipa & Rentang Debit

> Arsitektur: Rev. 07 (satu tangki, pompa langsung). Hitungan ideal tanpa rugi gesek, g = 9,81 m/s², ν air ≈ 1,0 × 10⁻⁶ m²/s.

## Ukuran pipa

Tidak berubah dari Rev. 06 — perpindahan ke pompa tidak memengaruhi ukuran pipa.

| Bagian | Pipa | Diameter dalam | Luas | Rasio thd pipa besar |
|---|---|---|---|---|
| Pipa besar (S1, zona A masuk/keluar, zona B) | 3/4" | 19 mm | 2,84 cm² | 1 |
| Leher venturi (zona A) | 3/8" | 10 mm | 0,79 cm² | 3,61 |
| Zona C (S2) | 1/2" | 13 mm | 1,33 cm² | 2,14 |

## Kecepatan & selisih kolom per debit

v = Q / A (kontinuitas), selisih kolom Δh = (v₂² − v₁²) / 2g (Bernoulli, pipa mendatar).

| Debit | v pipa besar | v leher | v zona C | Δh kolom 1↔2 (venturi) | Δh kolom 5↔6 (zona C) | Re pipa besar |
|---|---|---|---|---|---|---|
| 2 L/min | 0,12 m/s | 0,42 m/s | 0,25 m/s | 8 mm | 3 mm | ± 2.200 |
| 3 L/min | 0,18 m/s | 0,64 m/s | 0,38 m/s | 19 mm | 6 mm | ± 3.300 |
| 4 L/min | 0,24 m/s | 0,85 m/s | 0,50 m/s | 34 mm | 10 mm | ± 4.500 |
| 5 L/min | 0,29 m/s | 1,06 m/s | 0,63 m/s | 53 mm | 16 mm | ± 5.600 |
| 6 L/min | 0,35 m/s | 1,27 m/s | 0,75 m/s | 76 mm | 23 mm | ± 6.700 |

## Batasan

1. **Batas atas 6 L/min** — rentang S2 (YF-S401) hanya sampai 6 L/min. Firmware wajib membatasi PWM pompa. S1 (YF-S201, 1–30 L/min) tidak membatasi.
2. **Batas bawah ± 3 L/min** —
   - Di 2 L/min, Re ± 2.200 → zona peralihan laminar–turbulen, perilaku gesekan tidak menentu, data kurang konsisten. Mulai 3 L/min aliran sudah turbulen.
   - Di bawah 3 L/min selisih kolom terlalu kecil untuk dibaca dengan penggaris 1 mm.
3. **Selisih zona C kecil** — rasio penyempitannya hanya 2,14 (venturi 3,61), jadi di 3–4 L/min selisihnya cuma 6–10 mm, rawan tertutup getaran kolom akibat pompa. Jelas terbaca di 5–6 L/min (16–23 mm).

## Kesimpulan

- **Debit kerja: 3–6 L/min.** Titik data yang disarankan: **3, 4, 5, 6 L/min**.
- **Zona A (venturi) = data Bernoulli utama.** Zona C = pembanding di ketinggian berbeda, paling jelas di 5–6 L/min.
- Opsi (belum diambil): perkecil zona C ke ID 10 mm supaya selisihnya sejelas venturi — harus dicek dulu terhadap ukuran lubang dalam S2.

## Berikutnya

Bagian 2 — profil manometer: tinggi tiap kolom termasuk rugi gesek, lalu tinggi tabung yang dibutuhkan (cukup 350 mm atau tidak).
