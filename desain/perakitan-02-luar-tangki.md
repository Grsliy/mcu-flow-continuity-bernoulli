# Perakitan 2 — Luar Tangki (Langkah 9–20)

Lanjutan dari `perakitan-01-dalam-tangki.md`. Mulai dari sisi luar tank connector.

```
  dalam tangki │ dinding │ luar
               │         │
  ══[SDL]══ [● TANK CONNECTOR ●]──[ ⑨ S1 ]──[ ⑩ SDD verlop ]══ ⑪ akrilik A1 ══►
                                    panah →    1/2" ulir │ 3/4" soket
```

## Langkah

| No | Dari → ke | Barang | Ukuran | Panjang | Cara pasang |
|---|---|---|---|---|---|
| 9 | Tank connector → S1 | **Sensor flow S1 (YF-S201)**, drat luar di kedua ujung | 1/2" | ± 6,5 cm (badan sensor) | Seal tape 5–6 lilitan, sekrup **dengan tangan** (badan plastik). Panah menjauhi tangki, kabel menghadap atas |
| 10 | S1 → peralihan | **SDD verlop 3/4" × 1/2"**: drat dalam 1/2" untuk S1, soket lem 3/4" untuk akrilik | 1/2" → 3/4" | ± 4 cm | Seal tape di ulir S1, sekrup dengan tangan |
| 11 | Peralihan → akrilik A1 | **Pipa akrilik A1**, dengan **sadap 1** di sisi atas, 180 mm dari ujung yang masuk verlop | OD 25–26 / ID 19–20 mm | **250 mm** (20 masuk verlop, ± 210 terlihat, 20 masuk soket venturi) | Epoxy di ujung, masukkan ke soket verlop sampai mentok, tahan lurus sampai keras |
| 12 | Akrilik A1 → venturi | **Venturi cetak 3D PETG** (`desain/cad/venturi.scad`), **sadap 2** = nipple di leher, hadap atas | Soket = OD akrilik + 0,25 mm; lubang 19 → 10 → 19 mm | ± 127 mm | Epoxy tipis di ujung A1, masuk sampai mentok di bibir penahan. **Kerucut pendek menghadap A1** (sisi masuk) |
| 13 | Venturi → akrilik A2 | **Pipa akrilik A2** mendatar, **sadap 3** di sisi atas, 105 mm dari ujung yang masuk venturi (± 85 mm setelah venturi, ± 70 mm sebelum siku) | OD 25–26 / ID 19–20 mm | **195 mm** (20 masuk venturi, ± 155 terlihat, 20 masuk siku 45°) | Epoxy di ujung, masuk soket venturi sampai mentok, tahan lurus |
| 14 | Akrilik A2 → siku | **Siku PVC 45°**, mulut satunya mengarah miring ke atas searah aliran (awal tanjakan) | 3/4" | — | **Epoxy** di ujung akrilik. Cek dengan waterpass: tanjakan tegak lurus ke atas, tidak miring ke depan/belakang |
| 15 | Siku → akrilik A3 | **Pipa akrilik A3** miring 45° (tanjakan), **sadap 4** tepat di tengah (80 mm dari tiap ujung, z ± 60 mm), sisi menghadap atas | OD 25–26 / ID 19–20 mm | **160 mm** (20 masuk tiap siku, ± 120 terlihat) | Epoxy, masuk siku bawah sampai mentok. Sumbu pipa atas harus **tepat 120 mm** di atas sumbu A2; sesuaikan panjang potong bila perlu |
| 16 | Akrilik A3 → siku | **Siku PVC 45°** atas, mulut satunya **mendatar** searah aliran | 3/4" | — | Epoxy di ujung akrilik. Cek mulut datar dengan waterpass |
| 17 | Siku → akrilik A4 | **Pipa akrilik A4** mendatar di z = 120 mm, **sadap 5** di sisi atas, 120 mm dari ujung yang masuk siku (± 100 mm setelah belokan) | OD 25–26 / ID 19–20 mm | **240 mm** (20 masuk siku, ± 200 terlihat, 20 masuk peralihan ball valve) | Epoxy. Cek: selisih tinggi sumbu A4 dan A2 = 120 mm, A4 datar |
| 18 | Akrilik A4 → ball valve | **SDL 3/4"** (soket di-epoxy ke akrilik), disekrup ke **ball valve PVC 3/4"** drat dalam kedua sisi | 3/4" | SDL ± 4 cm + ball valve ± 6–7 cm | Sekrup SDL ke ball valve **dulu** (seal tape), baru epoxy akrilik ke SDL supaya akrilik tidak terpuntir. Tuas ke atas/belakang. Saat praktikum: terbuka penuh |
| 19 | Ball valve → leher angsa | **Leher angsa PVC 3/4"** bentuk ⊓: SDL → pipa ± 5 cm → knee 90° naik → pipa naik ± 6–7 cm → knee 90° → pipa puncak ± 6 cm → knee 90° turun → pipa mulut ± 4 cm, **ujung terbuka** | 3/4" | lihat Barang | Lem PVC (SDL: seal tape). **Sumbu pipa puncak = sumbu A4 + 5 cm**; sesuaikan pipa naik. Mulut tidak disambung rapat (cegah sifon) |
| 20 | Leher angsa → tangki | **Corong** Ø 8–10 cm di bawah mulut (ada celah udara, tidak menempel) → pipa PVC tegak ± 10 cm → knee → **pipa balik** lewat belakang alat, terus menurun (≥ ± 3 cm sepanjang jalur) → **tank connector kedua** di dinding kanan belakang, ± 15 cm dari dasar (di atas muka air, sisi sekat jauh dari pompa) | 3/4" | pipa balik ± 120–140 cm | Lem PVC; leher corong dirapatkan dengan sealant. Untuk kalibrasi S1: geser corong, tadah air dari mulut dengan gelas ukur |

## Catatan

- S1 dipasang **sebelum** semua titik sadap, supaya hambatan kincir sensor tidak terbaca sebagai efek venturi.
- Setelah S1 wajib ada **pipa lurus ≥ 20 cm** sebelum sadap 1.
- **Langkah 10, alternatif** kalau SDD verlop 3/4" × 1/2" tidak ada: SDD 1/2" → pipa PVC 1/2" ± 4 cm → sok verlop 3/4" × 1/2".
- **Akrilik ke soket PVC 3/4"** (diameter dalam ± 26 mm): OD 26 mm masuk pas; OD 25 mm isi celah dengan epoxy atau lilit 1–2 lapis selotip. **Lem PVC tidak menempel ke akrilik — wajib epoxy.**

## Membuat titik sadap (berlaku untuk semua sadap di pipa akrilik)

1. Tandai posisi dengan spidol, tepat di garis atas pipa.
2. Bor **Ø 2 mm pelan**, tegak lurus, dengan potongan kayu di dalam pipa sebagai alas. Jangan ditekan keras.
3. Haluskan duri di bagian dalam lubang (tusuk gigi berlapis amplas halus).
4. Tempel **konektor selang** (barb akuarium) di atas lubang dengan **epoxy**; lubang konektor segaris dan tidak tertutup lem.
5. Setelah kering, pasang selang bening ke kolom manometer yang sesuai.
6. Latih dulu di batang akrilik cadangan.

## Sebelum venturi dipasang

1. Beri tanda panah arah aliran di badan venturi: kerucut pendek = masuk, kerucut panjang = keluar.
2. Rapikan leher dengan mata bor 10 mm diputar **dengan tangan**.
3. Ukur diameter leher dengan jangka sorong, catat (dipakai di firmware; selisih 0,3 mm menggeser Δh ± 12%).
4. Uji rembes: tutup satu ujung, isi air, tekan sedikit; dinding dan nipple tidak boleh basah dari luar.
