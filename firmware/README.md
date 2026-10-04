# Firmware

Belum ada kode. File ini rencana fungsi dan pinout. MCU: **ESP32-C3 Super Mini** (Arduino core ESP32).

## Fungsi

| Fungsi | Cara |
|---|---|
| Baca debit S1 | Interrupt per pulsa, ukur **periode** antar-pulsa (± 30–45 Hz di 4–6 L/min), konversi pakai tabel faktor-K hasil kalibrasi |
| Kenop target debit | ADC1, dirata-rata |
| Kontrol debit | PI: debit S1 → keluaran ke pompa (PWM atau buck, ditentukan uji bangku) |
| Pengaman | Masa tenggang 5–10 s saat start; batas keluaran maks; keluaran maks tapi debit < 50% target > 3 s → pompa mati + pesan di layar |
| Tombol CEK | Tampilkan v₁, v leher, prediksi Δh (diameter leher terukur, C_d = 1), label "prediksi" |
| Tombol Start/Stop | Nyala/mati pompa |
| Layar | LCD 20×4 I2C: target, debit, status, pesan error + cara restart |
| Buzzer | Nada mengikuti debit; bunyi alarm saat pengaman aktif |
| Log | Serial CSV: waktu, target, debit, keluaran pompa, faktor-K |
| Watchdog | Program macet → reset, pompa mati |

## Pinout (usulan — cek ulang dengan board yang dibeli)

| GPIO | Fungsi | Catatan |
|---|---|---|
| 1 | Kenop target debit | ADC1 |
| 3 | Pulsa S1 | Lewat level shifter (sensor 5 V) |
| 4 | Tombol CEK | Input pull-up |
| 5 | Tombol Start/Stop | Input pull-up |
| 6 | I2C SDA (LCD) | Lewat level shifter |
| 7 | I2C SCL (LCD) | Lewat level shifter |
| 10 | Kendali pompa | Pull-down 10 kΩ → pompa mati saat reset |
| 20 | Buzzer | |
| 0 | Cadangan: pulsa S2 (paket lengkap) | |

Hindari GPIO 2/8/9 untuk keluaran penting (pin strapping, bisa HIGH sesaat saat boot) dan GPIO 18/19 (USB).

## Urutan pengerjaan

1. Firmware uji bangku: baca S1, atur keluaran pompa manual, log serial.
2. Kontrol PI + pengaman.
3. Layar, tombol, CEK, buzzer.
4. Rapikan, kalibrasi akhir, dokumentasi.
