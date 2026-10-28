# Alat Praktikum Fluida Dinamis

Alat praktikum berbasis mikrokontroler untuk skripsi client: membuktikan **debit, kontinuitas, dan Bernoulli** secara terukur dan interaktif.

**Status:** desain Rev. 08, tahap belanja & perakitan (DP diterima), firmware belum dibuat.

## Alat (Rev. 08)

- Satu tangki + pompa DC brushless (12 V 22 W, 800 L/jam). Kenop = target debit, dikunci kontrol PI dari sensor flow S1.
- MCU: ESP32-C3 Super Mini.
- Test section: venturi mendatar (zona A) → tanjakan 12 cm (zona B). Zona C + sensor kedua opsional (paket lengkap).
- Panel manometer membaca tekanan langsung. Level kolom diatur otomatis oleh leher angsa (tanpa servo).

## Folder

```
anggaran/   RAB + keuangan (Excel), nota/ untuk foto nota
catatan/    spesifikasi, uji bangku, kesepakatan, milestone & jadwal harian (PDF)
desain/     sketsa (HTML), langkah perakitan 1–20 (md), cad/ (model 3D OpenSCAD, pratinjau, gambar kerja 2D DXF),
            perhitungan/ (pipa, manometer, pompa)
firmware/   rencana fungsi & pinout (kode belum dibuat)
referensi/  4 jurnal acuan
```

## Sebelum belanja

1. Minta BAB I–III client: skripsinya R&D alat atau verifikasi eksperimen?
2. Kesepakatan tertulis (`catatan/draf-kesepakatan.md`): paket, harga, kriteria penerimaan, batas jasa alat vs isi skripsi.
3. Uji bangku murah (`catatan/uji-bangku.md`): pompa, S1, katup searah, ukuran pipa riil.

RAB paket inti ± Rp4,2–4,3 juta, target client Rp2 juta — perlu dibahas.

## Referensi

| Jurnal | Isi |
|---|---|
| Shidqi & Anggaryani (2020) | 2 sensor flow, kontinuitas |
| Nurfajrihana dkk. (2022) | 2× YF-S201 + venturimeter |
| Mulianti dkk. (2025) | Debit + P = ρgh dari tinggi tangki |
| Arumningrum dkk. (2025) | Venturimeter akrilik, Bernoulli |

Keempatnya menghitung tekanan secara tidak langsung; alat ini mengukurnya langsung dengan manometer.
