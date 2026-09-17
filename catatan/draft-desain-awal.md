> **Status: DRAFT lama, belum jadi acuan kerja.** Ditulis sebelum konteks kebutuhan client (dosen pembimbing, fokus skripsi, presisi data) dikonfirmasi. Simpan sebagai referensi ide, jangan dipakai langsung untuk eksekusi sebelum direview ulang.

# Alat Praktikum Fluida Dinamis (Arduino Uno + Sensor Flow)

Project ini mengadaptasi dan menggabungkan tiga referensi jurnal fisika pendidikan yang ada di folder ini:

1. **Mulianti, Saehana, & Gustina (2025)** — *Desain Alat Praktikum Pengukur Debit Air Menggunakan Sensor Flow Berbasis Arduino Uno pada Materi Fluida Dinamis*. JPFT, 13(2), 278–287.
2. **Shidqi & Anggaryani (2020)** — *Pengembangan Alat Peraga Berbasis Sensor Flowmeter untuk Menerapkan Persamaan Kontinuitas pada Materi Fluida Dinamis*. IPF, 9(2), 133–143.
3. **Arumningrum, Hamdani, & Medriati (2025)** — *Pengembangan Prototipe Alat Peraga Asas Bernoulli Berbasis Arduino Uno untuk Pembelajaran Fluida Dinamis*. Jurnal Kumparan Fisika, 8(1), 21–32.

Alat yang dirancang di sini bisa menunjukkan **ketiga konsep sekaligus**: debit air, hukum kontinuitas (Q1 = Q2), dan asas Bernoulli — menggunakan dua sensor flow yang dipasang di dua bagian pipa berbeda diameter (mirip prinsip venturimeter).

## Prinsip Kerja

```
Tangki sumber --[kran]--> Pipa besar --[Sensor 1]--> Penyempitan --[Sensor 2]--> Pipa kecil --> Tangki penampung
                                                                                       ^
                                                                                  Pompa air (sirkulasi balik ke tangki sumber)
```

- **Sensor 1** dipasang di penampang **besar**, **Sensor 2** di penampang **kecil** (setelah reducer/penyempitan pipa).
- Arduino menghitung pulsa dari kedua sensor tiap detik → didapat debit (Q), volume kumulatif (V), dan waktu (t).
- Dari Q dan luas penampang (A) yang diketahui, dihitung kecepatan aliran `v = Q / A`.
- **Kontinuitas**: dibandingkan Q1 vs Q2 (idealnya sama, toleransi ±10% seperti pada jurnal referensi).
- **Bernoulli**: dihitung selisih tekanan teoritis `ΔP = ½ρ(v2² − v1²)` dengan asumsi kedua titik sama tinggi (pipa horizontal).
- Semua data ditampilkan bergantian di LCD 16x2 dan juga dikirim ke Serial Monitor (format CSV) untuk direkam/dianalisis di Excel, sama seperti metode pengambilan data pada ketiga jurnal.

## Bill of Materials (BOM)

Karena belum ada komponen, berikut rekomendasi (harga & ketersediaan mudah dicek di toko elektronik lokal/online):

| No | Komponen | Jumlah | Catatan |
|----|----------|--------|---------|
| 1 | Arduino Uno R3 (atau kompatibel) | 1 | Otak sistem |
| 2 | Sensor Flow **YF-S201** (hall effect, 1/2"–3/4") | 1 | Dipasang di pipa **besar** |
| 3 | Sensor Flow **YF-S401** (hall effect, 1/4"–3/8") | 1 | Dipasang di pipa **kecil**. Boleh diganti 2x YF-S201 kalau lebih mudah dicari, asal ukuran pipa disesuaikan |
| 4 | LCD 16x2 + modul I2C backpack (PCF8574) | 1 | I2C dipilih supaya hemat pin & wiring simpel |
| 5 | Reducer/fitting pipa PVC atau akrilik (besar→kecil) | secukupnya | Titik penyempitan (efek venturi) |
| 6 | Pipa PVC atau akrilik bening | secukupnya | Akrilik lebih baik agar aliran terlihat jelas (saran dari jurnal Arumningrum dkk.) |
| 7 | Pompa air celup DC 12V (submersible, ~240–380 L/H) | 1 | Sirkulasi air dari penampung ke sumber |
| 8 | Modul relay 1 channel 5V | 1 (opsional) | Kontrol on/off pompa dari Arduino |
| 9 | Adaptor 12V | 1 | Power supply pompa |
| 10 | Ember/tandon plastik | 2 | Tangki sumber & tangki penampung |
| 11 | Kran/valve pengatur aliran | 1–2 | Mengatur debit untuk variasi percobaan |
| 12 | Push button | 1 | Reset pengukuran (volume & waktu) |
| 13 | Breadboard/PCB dot, kabel jumper, selang silikon, klem selang, sealant | secukupnya | Perakitan & mencegah kebocoran |

### Opsional (upgrade akurasi Bernoulli)

Kode saat ini menghitung ΔP secara **teoritis** dari kecepatan aliran (bukan sensor tekanan asli), sama seperti pendekatan di jurnal Mulianti dkk. Jika ingin ΔP terukur langsung:

| No | Komponen | Jumlah | Catatan |
|----|----------|--------|---------|
| 14 | Sensor tekanan air analog G1/4, 0–1.2 MPa (5V, output 0.5–4.5V) | 2 | Pasang sebelum & sesudah penyempitan pipa, baca lewat pin analog (A0, A1) Arduino |

## Wiring

| Komponen | Pin Arduino Uno |
|----------|------------------|
| Sensor Flow 1 (pipa besar) — kabel sinyal | D2 (INT0) |
| Sensor Flow 2 (pipa kecil) — kabel sinyal | D3 (INT1) |
| Sensor Flow 1 & 2 — VCC | 5V |
| Sensor Flow 1 & 2 — GND | GND |
| LCD I2C — SDA | A4 |
| LCD I2C — SCL | A5 |
| LCD I2C — VCC/GND | 5V / GND |
| Push button reset | D4 (ke GND saat ditekan, pakai `INPUT_PULLUP`) |
| Relay pompa (opsional) — IN | D7 |

> Catatan: Uno hanya punya 2 pin interrupt hardware (D2, D3) — karena project ini pakai 2 sensor, keduanya sudah terpakai. Jika nanti menambah sensor tekanan analog, gunakan pin `A0`/`A1` (tidak butuh interrupt).

## Kalibrasi (WAJIB sebelum dipakai)

Sama seperti metodologi di ketiga jurnal (mereka melakukan 5x pengulangan kalibrasi dengan gelas ukur & stopwatch):

1. Alirkan air dengan volume yang diketahui (misalnya 1000 mL, ukur pakai gelas ukur) melalui masing-masing sensor.
2. Catat jumlah pulsa yang terhitung Arduino (bisa tambahkan `Serial.println(pulse1)` sementara untuk debug) dan waktu tempuh dengan stopwatch.
3. Ulangi 5 kali per sensor, ambil rata-rata **pulsa per liter**.
4. Masukkan nilai tersebut ke `CAL_SENSOR1` dan `CAL_SENSOR2` di kode (`alat_praktikum_fluida_dinamis.ino`).
5. Ukur juga diameter dalam pipa yang sebenarnya dipakai, hitung luas penampang `A = π(d/2)²`, lalu perbarui konstanta `A1` dan `A2`.

## Instalasi Firmware

1. Install Arduino IDE.
2. Di Library Manager, install library **LiquidCrystal_I2C**.
3. Buka `firmware/alat_praktikum_fluida_dinamis.ino`, sesuaikan `CAL_SENSOR1`, `CAL_SENSOR2`, `A1`, `A2` sesuai hasil kalibrasi.
4. Upload ke Arduino Uno.
5. Buka Serial Monitor (9600 baud) untuk melihat data mentah (format CSV: waktu, Q1, Q2, V1, V2, v1, v2, ΔP, %selisih) — bisa disalin ke Excel untuk membuat tabel/grafik seperti pada jurnal.

## Tampilan LCD (bergantian tiap 3 detik)

1. **Layar 1** — Debit sesaat Q1 & Q2 (L/menit)
2. **Layar 2** — Volume kumulatif V1 & V2 (liter)
3. **Layar 3** — Kecepatan aliran v1, v2 (m/s) + % selisih kontinuitas
4. **Layar 4** — Estimasi selisih tekanan Bernoulli (Pa)

Tekan tombol reset untuk mengulang percobaan (volume & waktu di-nolkan, seperti pengulangan 5 kali percobaan pada jurnal).

## Batasan (mengikuti catatan "Saran" di ketiga jurnal)

- ΔP Bernoulli dihitung dari kecepatan (teoritis), bukan sensor tekanan asli — akurasi bergantung pada akurasi kalibrasi sensor flow.
- Belum ada filter air — disarankan tambahkan filter sederhana agar kotoran tidak merusak sensor (saran dari jurnal Mulianti dkk.).
- Pastikan pipa/sambungan rapat agar tidak bocor, terutama di titik penyempitan.
