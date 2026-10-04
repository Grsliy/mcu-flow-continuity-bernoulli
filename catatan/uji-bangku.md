# Uji Bangku

Tujuan: membuktikan asumsi desain dengan biaya kecil sebelum belanja penuh dan memotong akrilik. Kalau ada yang gagal, desain disesuaikan dulu.

**Bahan:** pompa + buck + adaptor, ESP32-C3, YF-S201, katup searah, selang naik ± 170 mm, ember, gelas ukur 2 L, stopwatch (HP), jangka sorong, 1 tabung manometer, venturi hasil cetak.

## Daftar uji

| # | Uji | Syarat lulus |
|---|---|---|
| 1 | Pompa: tegangan minimum yang masih stabil | Tercatat; pompa tidak tersendat |
| 2 | Pompa: debit 4–6 L/min | Tercapai dan halus di bawah tegangan maksimum |
| 3 | Head saat katup tertutup pada tegangan maks yang diizinkan | Di bawah tinggi panel (350 mm), atau jadi batas firmware |
| 4 | Katup searah menahan kolom 170 mm | ≥ 10 menit tanpa turun; tidak bergetar saat mengalir |
| 5 | Kalibrasi S1 vs gelas ukur di 4 / 5 / 6 L/min | 5 ulangan per debit; faktor-K tercatat |
| 6 | Firmware ukur periode pulsa S1 (± 30–45 Hz) | Bacaan debit stabil, tidak loncat-loncat |
| 7 | Diameter dalam pipa riil | Terukur → file perhitungan 01–02 dihitung ulang |
| 8 | Venturi cetak: ukur leher, cetak 2–3, pilih terbaik | Leher terukur ± 0,1 mm; nipple tidak rembes |
| 9 | Getaran kolom dengan/tanpa peredam | Amplitudo ≤ ± 2 mm |
| 10 | Pengaman: start, reset, upload firmware | Tidak ada alarm palsu saat start (masa tenggang 5–10 s); pompa mati saat reset |
| 11 | Sambungan bocor | Direndam/terisi 24 jam tanpa rembes |
| 12 | (Paket lengkap) rugi tekanan S2 di 6 L/min | ≤ ± 90 mm |

## Lembar ukur pompa

| Tegangan (V) | Waktu isi 1 L (s) | Debit gelas ukur (L/min) | Debit S1 (L/min) | Catatan |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

## Lembar kalibrasi S1

| Target (L/min) | Ulangan | Volume (L) | Waktu (s) | Debit gelas ukur | Pulsa S1 | Faktor-K (pulsa/L) |
|---|---|---|---|---|---|---|
| 4 | 1–5 | | | | | |
| 5 | 1–5 | | | | | |
| 6 | 1–5 | | | | | |
