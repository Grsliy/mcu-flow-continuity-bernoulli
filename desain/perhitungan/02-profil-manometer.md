# Bagian 2 — Profil Manometer

> Arsitektur: **Rev. 08** (satu tangki, pompa langsung, **leher angsa**, tanpa servo). Hitungan utama untuk **paket inti** (zona A + B, sadap 1–5); zona C + S2 dibahas terpisah di bagian [Paket lengkap](#paket-lengkap-zona-c--s2). Contoh memakai **Q = 6 L/min** (debit maksimum). g = 9,81 m/s², ν air ≈ 1,0 × 10⁻⁶ m²/s. Ukuran pipa dari [Bagian 1](01-pipa-dan-debit.md).
>
> ⚠️ Semua angka rugi gesek di file ini adalah **estimasi dari koefisien umum**, bukan hasil ukur. Angka yang boleh masuk skripsi adalah hasil pengukuran alat jadi.

## Dasar

### Datum

Garis acuan "nol" untuk semua ketinggian = **sumbu pipa bawah**. Angka 0 penggaris manometer disejajarkan dengan garis ini (pakai selang air / waterpass saat perakitan). Semua z dan semua bacaan tabung diukur dari datum yang sama, supaya semua tabung bisa dibandingkan langsung.

### Energi air = tiga bagian

```
H  =  P/ρg      +      z        +     h_v
     (tekanan)    (ketinggian pipa)  (kecepatan)
     └──── bacaan penggaris ──────┘
```

| Suku | Artinya | Terbaca manometer? |
|---|---|---|
| P/ρg | Tinggi tekanan | Ya |
| z | Ketinggian titik sadap dari datum | Ya (tabung mulai dari titik sadap) |
| h_v = v²/2g | Energi gerak, dinyatakan sebagai tinggi | **Tidak** (kecuali tabung pitot) |
| H | Energi total | Tidak langsung (tabung pitot membacanya) |

### Rumus yang dipakai berulang

| Rumus | Asal | Dipakai untuk |
|---|---|---|
| **v = Q / A** | Kekekalan massa: A₁v₁ = A₂v₂ | Kecepatan di tiap penampang |
| **h_v = v² / 2g** | Energi kinetik per satuan berat (½mv² / mg) | Tinggi kecepatan |
| **bacaan = P/ρg + z** | Hidrostatis di dalam tabung (P + ρgz = tetap di air diam) | Membaca tekanan dari tabung |
| **H = bacaan + h_v** | Bernoulli: P + ½ρv² + ρgz = tetap, dibagi ρg | Energi total tiap titik |
| **H₁ = H₂ + h_rugi** | Bernoulli + gesekan | H hanya boleh **turun** searah aliran (kecuali di pompa) |
| **v₁ = √(2g·Δh / ((A₁/A₂)² − 1))** | Kontinuitas + Bernoulli, z sama, tanpa gesekan | Venturimeter: Q dari selisih kolom |

## Posisi titik sadap

| Titik | Lokasi | D dalam | Luas | z | Paket |
|---|---|---|---|---|---|
| 1 | Pipa besar, **≥ 20 cm setelah S1**, sebelum venturi | 19 mm | 2,835 cm² | 0 | inti |
| 2 | Leher venturi | 10 mm | 0,785 cm² | 0 | inti |
| 3 | Pipa besar, setelah venturi | 19 mm | 2,835 cm² | 0 | inti |
| 4 | Tengah tanjakan (zona B) | 19 mm | 2,835 cm² | 60 mm | inti |
| 5 | Atas tanjakan (zona B) | 19 mm | 2,835 cm² | 120 mm | inti |
| 6 | Zona C setelah reducer, sebelum S2 — **atau** tabung pitot di leher | 13 mm | 1,327 cm² | 120 mm | lengkap / opsi |

> Sadap 1 wajib **setelah** S1 dan diberi pipa lurus ≥ 20 cm (± 10D): kincir sensor menghambat aliran dan membuat pusaran. Kalau S1 ada di antara sadap 1 dan 2, rugi tekanan sensor ikut terbaca sebagai "efek venturi".

## Perhitungan per titik — paket inti (Q = 6 L/min = 0,0001 m³/s)

### Langkah 0 — Pompa → S1

Kenop mengatur **target debit**; kontrol PI menahan Q = 6 L/min (dibaca S1 yang sudah dikalibrasi). Tinggi kolom ditentukan leher angsa di ujung (Langkah 6), jadi kolom 1 disebut **h₁** dulu dan titik lain dihitung relatif terhadap h₁.

### Titik 1 — pipa besar

```
A₁   = π/4 × 0,019²         = 2,835 × 10⁻⁴ m²
v₁   = 0,0001 / 2,835×10⁻⁴  = 0,353 m/s
h_v1 = 0,353² / 19,62       = 6,3 mm
Re   = 0,353 × 0,019 / 10⁻⁶ ≈ 6.700   → turbulen
```

Manometer: **h₁**. Energi total H₁ = h₁ + 6,3.

**Bisa dihitung:** kecepatan, tekanan dinamis ½ρv² = 62 Pa, rezim aliran, tekanan statis P₁ = ρg·h₁.

### Titik 2 — leher venturi (menyempit)

```
A₂   = π/4 × 0,010²         = 7,854 × 10⁻⁵ m²
v₂   = 0,0001 / 7,854×10⁻⁵  = 1,273 m/s   (3,61× lebih cepat)
h_v2 = 1,273² / 19,62       = 82,6 mm

h₂ = h₁ − (h_v2 − h_v1) − rugi
   = h₁ − (82,6 − 6,3) − ±4,5
   ≈ h₁ − 81 mm
```

Rugi ± 4,5 mm = penyempitan + gesekan di leher (estimasi).

**Bisa dihitung:**
- Kontinuitas: v₂/v₁ = A₁/A₂ = 3,61.
- Bernoulli: turunnya kolom = naiknya tinggi kecepatan.
- Venturimeter: dari Δh₁₂ → Q teori. **C_d = Q gelas ukur ÷ Q teori** — ini yang diukur. Kalau rugi 4,5 mm di atas benar, C_d akan ± 0,97, tapi angka itu **perkiraan**, bukan hasil.

### Titik 3 — melebar kembali

```
v₃ = v₁ = 0,353 m/s   → h_v3 = 6,3 mm
ideal: h₃ = h₁
nyata: h₃ ≈ h₁ − 15 mm
```

Rugi terbesar di bagian melebar (diffuser): air melambat, sebagian energi jadi pusaran. ± 15–20% dari penurunan di leher — wajar untuk venturi berkerucut halus. **Venturi bertingkat** (tanpa kerucut) berperilaku seperti orifice: rugi jauh lebih besar dan C_d berubah — karena itu venturi dicetak 3D dengan kerucut.

**Bisa dihitung:** rugi energi permanen venturi = h₁ − h₃, terbaca langsung karena kecepatan titik 1 dan 3 sama.

### Titik 4 & 5 — tanjakan (zona B)

Penampang tetap → v = 0,353 m/s, h_v = 6,3 mm. Yang berubah hanya z: 60 lalu 120 mm.

```
h₄ ≈ h₃ − 3 mm      (gesekan + belokan 1)
h₅ ≈ h₃ − 7 mm      (gesekan + belokan 2)   → kolom 3, 4, 5 hampir sama tinggi

tekanan sebenarnya titik 5:
P₅/ρg = h₅ − z₅ = (h₃ − 7) − 120   → turun 127 mm dari titik 3
```

120 mm dari penurunan itu pindah jadi ketinggian — suku ρgh Bernoulli: ρgΔz = 1000 × 9,81 × 0,12 = **1177 Pa**. Di panel, **garis merah z + skala kedua** di tabung 4 dan 5 membuat penurunan tekanan ini terlihat walau puncak kolom sama tinggi.

**Bisa dihitung:** pertukaran tekanan ↔ ketinggian (ρgΔz), rugi gesek pipa lurus + belokan.

### Langkah 6 — leher angsa menentukan level

Setelah titik 5: pipa → ball valve (terbuka penuh) → leher angsa naik sampai ujung keluar di **z_out ≈ 170 mm** (50 mm di atas pipa atas) → air jatuh bebas ke corong.

Di ujung keluar tekanan = 0 (udara luar). Energi di titik 5 harus cukup untuk naik ke z_out plus menutup semua rugi di hilir:

```
Rugi hilir (estimasi, di pipa 19 mm, h_v = 6,3 mm):
  3 belokan 90° (K ≈ 0,7 × 3)          2,1
  ball valve terbuka (K ≈ 0,05)         0,05
  gesekan pipa ± 0,5 m (f·L/D ≈ 0,9)    0,9
  energi gerak yang terbawa keluar       1,0
  ΣK ≈ 4,1   →  4,1 × 6,3 ≈ 26 mm

H₅ = z_out + 26 = 170 + 26 = 196 mm
h₅ = H₅ − h_v5  = 196 − 6,3 ≈ 190 mm
```

Lalu mundur ke titik sebelumnya: h₄ ≈ 194, h₃ ≈ 197, h₁ ≈ 212, h₂ ≈ 131.

**Cek keamanan:** tekanan di titik tertinggi (sadap 5) = 190 − 120 = **70 mm > 0** → tidak ada udara tersedot. Karena ujung keluar selalu lebih tinggi dari pipa atas, syarat ini **terpenuhi otomatis di semua debit** — tidak perlu interlock atau penyetelan katup.

## Hasil lengkap — paket inti, Q = 6 L/min

| Titik | v (m/s) | h_v (mm) | **Bacaan penggaris** (mm) | z (mm) | P/ρg (mm) | P (Pa) | H (mm) |
|---|---|---|---|---|---|---|---|
| 1 | 0,353 | 6,3 | **212** | 0 | 212 | 2080 | 218 |
| 2 | 1,273 | 82,6 | **131** | 0 | 131 | 1285 | 214 |
| 3 | 0,353 | 6,3 | **197** | 0 | 197 | 1933 | 203 |
| 4 | 0,353 | 6,3 | **194** | 60 | 134 | 1315 | 200 |
| 5 | 0,353 | 6,3 | **190** | 120 | 70 | 687 | 196 |
| pitot di leher (opsi tabung 6) | — | — | **± 214** | 0 | — | — | 214 |

- **Validasi data:** kolom H harus selalu turun dari titik ke titik (selisihnya = rugi gesek). Kalau H naik di suatu titik, ada salah baca atau salah ukur.
- **Tabung pitot** di leher membaca energi total (± 214 mm) — hampir setinggi kolom 1, padahal kolom 2 di sebelahnya turun ke 131. Kekekalan energi terlihat langsung.

## Debit lain & uji nol — paket inti

Bagian dinamis (selisih, rugi, energi gerak) sebanding Q², level dasar = z_out = 170 mm. Faktor f = (Q/6)².

| Debit | f | Kolom 1 | Kolom 2 | Kolom 3 | Kolom 4 | Kolom 5 | Selisih 1↔2 | Tekanan sadap 5 |
|---|---|---|---|---|---|---|---|---|
| **0 (pompa mati)** | 0 | 170 | 170 | 170 | 170 | 170 | 0 | 50 mm |
| 3 L/min | 0,25 | 180 | 160 | 177 | 176 | 175 | 20 mm | 55 mm |
| 4 L/min | 0,44 | 189 | 153 | 182 | 181 | 179 | 36 mm | 59 mm |
| 4,5 L/min | 0,56 | 193 | 148 | 185 | 183 | 181 | 46 mm | 61 mm |
| 5 L/min | 0,69 | 199 | 143 | 189 | 186 | 184 | 56 mm | 64 mm |
| 6 L/min | 1 | 212 | 131 | 197 | 194 | 190 | 81 mm | 70 mm |

- Semua kolom berada di **130–212 mm** di seluruh rentang debit → **tabung 350 mm cukup**, tanpa perlu menyetel katup.
- **Uji nol** (baris pertama): pompa mati, katup searah menahan air → semua kolom sama tinggi, setinggi ujung leher angsa. Dipakai untuk mengecek offset kapiler & datum sebelum tiap sesi, sekaligus demo hidrostatis: tekanan sadap = ρg(170 − z) → sadap bawah 170 mm, sadap atas 50 mm.

## Kepekaan & ketidakpastian

| Sumber | Besar | Efek ke selisih venturi Δh₁₂ | Penanganan |
|---|---|---|---|
| Baca manometer | ± 1 mm per tabung → ± 2 mm selisih | 5,6% di 4 L/min, 2,5% di 6 L/min | Mata sejajar meniskus, peredam |
| Akurasi S1 tanpa kalibrasi | ± 10% Q | **± 20%** (karena Δh ∝ Q²) | **Kalibrasi volumetrik wajib** |
| Diameter leher | ± 0,1 mm / ± 0,3 mm | ± 4% / **± 12%** (Δh ∝ d⁻⁴) | Ukur leher setelah dicetak, masukkan ke firmware |
| Kapilaritas | ± 4–5 mm (tabung 6–8 mm) | Hilang kalau semua tabung identik | Tabung sama diameter, cek lewat uji nol |
| Udara di selang | Bisa puluhan mm | Data rusak | Buang udara per selang + SOP |

**Uji Bernoulli yang bisa gagal:** plot Δh₁₂ terhadap Q² pada ≥ 5 debit (4,0–6,0 L/min, Q dari S1 terkalibrasi). Hasilnya harus **garis lurus melewati nol**. Kemiringan teori (tanpa rugi) = 76,3 mm ÷ 36 = **2,12 mm per (L/min)²**; data nyata sedikit lebih curam karena rugi di leher.

## Paket lengkap (zona C + S2)

Hanya berlaku kalau client memilih paket lengkap.

### Titik 6 — zona C

```
A₆   = π/4 × 0,013²         = 1,327 × 10⁻⁴ m²
v₆   = 0,0001 / 1,327×10⁻⁴  = 0,754 m/s
h_v6 = 0,754² / 19,62       = 28,9 mm

h₆ = h₅ − (28,9 − 6,3) − rugi reducer ±6
   ≈ h₅ − 29 mm
```

- Kontinuitas dengan S2: A₁v₁ = A₆v₆ → 2,835 × 0,353 = 1,327 × 0,754 = 1,0 × 10⁻⁴ m³/s ✓ (S1 **dan** S2 wajib terkalibrasi).
- Selisih kolom 5↔6 hanya 7 mm (3 L/min) sampai 29 mm (6 L/min), dan rugi reducer (± 6 mm) setara dengan sinyalnya → C_d zona C diperkirakan jauh lebih buruk dari zona A (± 0,89).

### Batas rugi tekanan S2 — syarat lolos uji

YF-S401 dipasang setelah sadap 6, jadi rugi tekanannya (sebut **X**, di 6 L/min) mengangkat semua kolom. Dengan pipa kembali ke 19 mm langsung setelah S2:

```
Rugi hilir sadap 6:
  pipa 13 mm pendek + pelebaran 13→19   ≈ 19 mm
  S2                                      X
  ball valve + 3 belokan + keluar (19 mm) ≈ 26 mm

H₆ = 170 + 19 + X + 26 = 215 + X
h₆ = H₆ − 28,9          = 186 + X
h₁ = h₆ + 51            = 237 + X     (51 = selisih kolom 1 → 6)

Syarat tabung: h₁ ≤ 330 mm   →   X ≤ ± 90 mm
```

**Uji bangku S2 sebelum membeli komponen lain:** alirkan 6 L/min (diukur gelas ukur) lewat satu YF-S401 dengan satu tabung bening sebelum dan sesudah sensor. Kalau selisihnya > ± 90 mm (atau tabung meluap), zona C + S2 gugur — atau butuh tabung lebih tinggi dan pompa lebih kuat.

## Kebutuhan pompa (gambaran)

Paket inti di 6 L/min: energi di titik 1 = 218 mm, ditambah rugi sebelum titik 1 — S1 (belum diketahui), katup searah (tipe swing/flapper: kecil; tipe pegas biasa bisa ratusan mm), bulkhead & belokan (± 20 mm). Perkiraan **± 0,3–0,5 m pada 6 L/min (0,36 m³/jam)**; paket lengkap ditambah X. Pompa DC kecil umumnya sanggup 1–5 m, jadi tenaga berlebih — firmware wajib membatasi PWM dan mematikan pompa kalau debit tidak tercapai (katup tertutup/tersumbat). Detail di Bagian 3.

## Kesimpulan

1. **Paket inti aman di tabung 350 mm**: semua kolom 130–212 mm di seluruh rentang debit, tanpa penyetelan katup.
2. **Leher angsa** (ujung keluar ± 170 mm) menjamin tekanan semua sadap positif di semua debit → tidak ada udara tersedot; servo tidak diperlukan.
3. **Uji nol** (pompa mati → semua kolom 170 mm) dipakai sebelum tiap sesi, sekaligus demo hidrostatis.
4. **Wajib**: sadap 1 ≥ 20 cm setelah S1; kalibrasi volumetrik S1; ukur diameter leher setelah dicetak; semua tabung diameter sama.
5. **C_d dan rugi di file ini perkiraan** — yang masuk skripsi adalah hasil ukur (C_d = Q gelas ukur ÷ Q teori) dan plot Δh vs Q².
6. **Zona C + S2** hanya layak kalau rugi tekanan S2 ≤ ± 90 mm di 6 L/min (uji bangku dulu).

## Berikutnya

Bagian 3 — kebutuhan pompa: head + debit, rugi S1 & katup searah, pilih pompa DC, rentang PWM, dan kontrol PI.
