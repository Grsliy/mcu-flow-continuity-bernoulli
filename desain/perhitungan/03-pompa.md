# 3 — Pompa

Rev. 08, paket inti. Pompa terpilih: **MAXPUMP brushless 12 V, 19 W, 800 L/jam, head maks 5 m, outlet 1/2"**.

## Kebutuhan sistem

Head sistem = ketinggian ujung leher angsa di atas muka air tangki (± 0,17 m, muka air ≈ datum) + rugi aliran (∝ Q²). Rugi sebelum titik 1 (S1, katup searah, sambungan) belum diukur, jadi dipakai estimasi:

| Debit | Head sistem (perkiraan) |
|---|---|
| 3 L/min | 0,24 m |
| 4 L/min | 0,29 m |
| 5 L/min | 0,36 m |
| 6 L/min | 0,45 m |

## Titik kerja pompa

Model kasar: kurva pompa lurus, dan hukum afinitas (debit ∝ kecepatan, head ∝ kecepatan²):

```
H = H₀·s² − (H₀/Q₀)·s·Q        s = fraksi kecepatan (1 = penuh)
```

| Debit | MAXPUMP 5 m (s) | ZYW890 8 m (s) | Head saat katup tertutup (MAXPUMP) |
|---|---|---|---|
| 3 L/min | 0,36 | — | 0,64 m |
| 4 L/min | 0,44 | 0,35 | 0,95 m |
| 5 L/min | 0,52 | — | 1,33 m |
| 6 L/min | 0,60 | 0,48 | 1,80 m |

- MAXPUMP bekerja di 36–60% kecepatan. ZYW890 lebih rendah lagi (35–48%), terlalu dekat batas tersendat → MAXPUMP lebih cocok.
- Head saat katup tertutup jauh di atas tabung 350 mm → pipa limpah manometer dan pengaman firmware wajib.

## Kendali kecepatan

- Pompa brushless dengan driver internal, tanpa kabel PWM → kecepatan diatur lewat **tegangan** (modul buck), kira-kira sebanding: 6 L/min ≈ 7 V, 4 L/min ≈ 5 V.
- Risiko: driver pompa umumnya berhenti di bawah ± 5–6 V → debit terendah yang stabil bisa ± 4,5–5 L/min.
- Kalau terjadi, tambah hambatan **di hulu** (katup antara pompa dan S1) atau **bypass** ke tangki, supaya pompa berputar lebih cepat untuk debit yang sama. Jangan menghambat di hilir: itu menaikkan semua kolom manometer.
- Cara MCU mengatur buck (mis. PWM terfilter ke pin feedback) ditentukan di uji bangku.

## Listrik & sambungan

- 19 W / 12 V ≈ 1,6 A → adaptor 12 V 5 A cukup, sekring 3 A.
- Outlet 1/2" → sok reduksi 1/2" → 3/4", lalu katup searah.
- Pompa harus selalu terendam; sambungan kabel di atas muka air.

## Yang harus diukur di uji bangku

Tegangan minimum stabil, kurva tegangan → debit (gelas ukur), dan head saat katup tertutup. Lembar ukur: `catatan/uji-bangku.md`.
