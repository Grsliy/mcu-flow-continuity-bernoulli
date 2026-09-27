# Alat Praktikum Fluida Dinamis

Alat praktikum berbasis mikrokontroler untuk skripsi client: membuktikan **debit, kontinuitas, dan Bernoulli** secara terukur dan interaktif.

**Status:** desain Rev. 08, belum fabrikasi, belum ada firmware.

## Alat (Rev. 08)

- Satu tangki + pompa DC. Kenop = target debit, dikunci kontrol PI dari sensor flow S1.
- Test section: venturi mendatar (zona A) → tanjakan 12 cm (zona B). Zona C + sensor kedua opsional (paket lengkap).
- Panel manometer membaca tekanan langsung. Level kolom diatur otomatis oleh leher angsa (tanpa servo).

## Folder

```
anggaran/   RAB (Excel): harga perkiraan + kolom harga online shop
catatan/    spesifikasi, pertanyaan ke client, log keputusan
desain/     sketsa (HTML) + perhitungan/
referensi/  4 jurnal acuan
arsip/      desain lama, tidak dipakai
```

## Sebelum belanja

1. Minta BAB I–III client: skripsinya R&D alat atau verifikasi eksperimen?
2. Kesepakatan tertulis: paket, harga, kriteria penerimaan, batas jasa alat vs isi skripsi.
3. Uji bangku murah: pompa, S1, katup searah, ukuran pipa riil.

RAB paket inti ± Rp4,1 juta, target client Rp2 juta — perlu dibahas.

## Referensi

| Jurnal | Isi |
|---|---|
| Shidqi & Anggaryani (2020) | 2 sensor flow, kontinuitas |
| Nurfajrihana dkk. (2022) | 2× YF-S201 + venturimeter |
| Mulianti dkk. (2025) | Debit + P = ρgh dari tinggi tangki |
| Arumningrum dkk. (2025) | Venturimeter akrilik, Bernoulli |

Keempatnya menghitung tekanan secara tidak langsung; alat ini mengukurnya langsung dengan manometer.
