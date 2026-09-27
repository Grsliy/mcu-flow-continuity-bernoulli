# 2 — Profil Manometer

Rev. 08, paket inti, contoh Q = 6 L/min. Angka rugi = estimasi; yang masuk skripsi = hasil ukur.

## Rumus

```
H = P/ρg + z + v²/2g        (energi total, dalam mm)
    └ bacaan ┘   └ h_v ┘
```

- Datum (0) = sumbu pipa bawah. Bacaan penggaris = tekanan + ketinggian sadap.
- Tanpa gesekan H tetap; dengan gesekan H hanya turun searah aliran.
- v = Q/A · h_v = v²/2g · venturimeter: v₁ = √(2gΔh / ((A₁/A₂)² − 1))

## Titik sadap

| Titik | Lokasi | D | z |
|---|---|---|---|
| 1 | Pipa besar, ≥ 20 cm setelah S1 | 19 mm | 0 |
| 2 | Leher venturi | 10 mm | 0 |
| 3 | Setelah venturi | 19 mm | 0 |
| 4 | Tengah tanjakan | 19 mm | 60 mm |
| 5 | Atas tanjakan | 19 mm | 120 mm |
| 6 | Zona C atau pitot (opsional) | 13 mm | 120 mm |

## Hitungan (Q = 6 L/min = 0,0001 m³/s)

```
Titik 1   v = 0,353 m/s   h_v = 6,3 mm   Re ≈ 6.700   h₁ = ditentukan leher angsa
Titik 2   v = 1,273 m/s   h_v = 82,6 mm  h₂ = h₁ − 76,3 − 4,5 (rugi) ≈ h₁ − 81
Titik 3   v = 0,353 m/s                  h₃ ≈ h₁ − 15   (rugi venturi)
Titik 4   z = 60 mm                      h₄ ≈ h₃ − 3
Titik 5   z = 120 mm                     h₅ ≈ h₃ − 7    tekanan turun 127 mm, 120 mm jadi ketinggian (ρgΔz = 1177 Pa)
```

**Level oleh leher angsa** (ujung keluar 170 mm): rugi hilir ΣK ≈ 4,1 × 6,3 = 26 mm → H₅ = 196 → h₅ = 190 mm. Tekanan sadap 5 = 70 mm > 0, jadi tidak ada udara tersedot — berlaku di semua debit.

## Hasil (Q = 6 L/min)

| Titik | v (m/s) | Bacaan (mm) | z (mm) | Tekanan (mm) | P (Pa) | H (mm) |
|---|---|---|---|---|---|---|
| 1 | 0,353 | 212 | 0 | 212 | 2080 | 218 |
| 2 | 1,273 | 131 | 0 | 131 | 1285 | 214 |
| 3 | 0,353 | 197 | 0 | 197 | 1933 | 203 |
| 4 | 0,353 | 194 | 60 | 134 | 1315 | 200 |
| 5 | 0,353 | 190 | 120 | 70 | 687 | 196 |
| pitot di leher | — | ± 214 | 0 | — | — | 214 |

H harus turun dari titik ke titik. Kalau naik → salah baca atau salah ukur.

## Semua debit (bacaan kolom, mm)

| Debit | 1 | 2 | 3 | 4 | 5 | Δh 1↔2 |
|---|---|---|---|---|---|---|
| 0 (pompa mati) | 170 | 170 | 170 | 170 | 170 | 0 |
| 3 L/min | 180 | 160 | 177 | 176 | 175 | 20 |
| 4 L/min | 189 | 153 | 182 | 181 | 179 | 36 |
| 4,5 L/min | 193 | 148 | 185 | 183 | 181 | 46 |
| 5 L/min | 199 | 143 | 189 | 186 | 184 | 56 |
| 6 L/min | 212 | 131 | 197 | 194 | 190 | 81 |

Semua kolom 130–212 mm → tabung 350 mm cukup. Baris pompa mati = uji nol.

## Ketidakpastian

| Sumber | Efek ke Δh 1↔2 | Penanganan |
|---|---|---|
| Baca ± 2 mm | 5,6% (4 L/min), 2,5% (6 L/min) | Mata sejajar meniskus, peredam |
| S1 ± 10% | ± 20% | Kalibrasi gelas ukur |
| Leher ± 0,3 mm | ± 12% | Ukur leher setelah dicetak |
| Kapilaritas | hilang bila tabung identik | Tabung satu ukuran, cek uji nol |

## Paket lengkap (zona C + S2)

- h₆ ≈ h₅ − 29 mm (h_v6 = 28,9 mm, rugi reducer ± 6 mm).
- Rugi S2 (X) mengangkat semua kolom: h₁ = 237 + X ≤ 330 → **X ≤ ± 90 mm di 6 L/min**. Uji bangku dulu.

## Pompa

± 0,3–0,5 m pada 6 L/min, ditambah rugi S1 dan katup searah (belum diukur). Detail di Bagian 3.
