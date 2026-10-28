// Sok venturi cetak 3D — Rev. 08
// Ganti angka di bagian PARAMETER setelah pipa akrilik diukur, lalu Render (F6) → Export STL.
// Cetak berdiri (sumbu tegak), PETG, layer 0,15–0,2 mm, infill 100%.

// ---------------- PARAMETER (mm) ----------------
pipa_od       = 25.0;   // diameter luar pipa akrilik TERUKUR
celah_soket   = 0.25;   // kelonggaran soket (0,2–0,3)
pipa_id       = 19.0;   // diameter dalam pipa akrilik TERUKUR (lubang venturi disamakan)
leher_d       = 10.0;   // diameter leher (dirapikan dengan mata bor 10 mm setelah cetak)
leher_l       = 20.0;   // panjang leher
sudut_masuk   = 10.5;   // sudut setengah kerucut masuk (derajat)
sudut_keluar  = 7.0;    // sudut setengah kerucut keluar (derajat), lebih landai
soket_dalam   = 20.0;   // kedalaman soket tiap ujung
dinding       = 3.0;    // tebal dinding minimum
sadap_lubang  = 1.8;    // diameter lubang sadap di leher
nipple_od     = 6.0;    // diameter luar nipple (sesuai selang 4/6)
nipple_tinggi = 12.0;   // tinggi nipple dari permukaan luar

$fn = 96;

// ---------------- turunan ----------------
soket_d  = pipa_od + celah_soket;
luar_d   = soket_d + 2 * dinding;
l_masuk  = (pipa_id - leher_d) / 2 / tan(sudut_masuk);
l_keluar = (pipa_id - leher_d) / 2 / tan(sudut_keluar);
bibir    = 3;                                   // bibir penahan pipa di dasar soket
z_masuk  = soket_dalam + bibir;
z_leher  = z_masuk + l_masuk;
z_keluar = z_leher + leher_l;
z_soket2 = z_keluar + l_keluar + bibir;
total    = z_soket2 + soket_dalam;

echo(str("Panjang total venturi = ", total, " mm"));
echo(str("Kerucut masuk = ", l_masuk, " mm, kerucut keluar = ", l_keluar, " mm"));

module lubang() {
    // soket bawah dan atas
    translate([0, 0, -0.01]) cylinder(d = soket_d, h = soket_dalam + 0.01);
    translate([0, 0, z_soket2]) cylinder(d = soket_d, h = soket_dalam + 0.01);
    // bibir (lubang = ID pipa, supaya tidak ada undakan)
    translate([0, 0, soket_dalam - 0.01]) cylinder(d = pipa_id, h = bibir + 0.02);
    translate([0, 0, z_soket2 - bibir - 0.01]) cylinder(d = pipa_id, h = bibir + 0.02);
    // kerucut masuk, leher, kerucut keluar
    translate([0, 0, z_masuk]) cylinder(d1 = pipa_id, d2 = leher_d, h = l_masuk + 0.01);
    translate([0, 0, z_leher]) cylinder(d = leher_d, h = leher_l + 0.01);
    translate([0, 0, z_keluar]) cylinder(d1 = leher_d, d2 = pipa_id, h = l_keluar + 0.01);
    // lubang sadap di tengah leher
    translate([0, 0, z_leher + leher_l / 2]) rotate([0, 90, 0])
        cylinder(d = sadap_lubang, h = luar_d / 2 + nipple_tinggi + 1);
}

module badan() {
    cylinder(d = luar_d, h = total);
    // nipple sadap leher
    translate([0, 0, z_leher + leher_l / 2]) rotate([0, 90, 0]) {
        cylinder(d = nipple_od, h = luar_d / 2 + nipple_tinggi);
        // gerigi penahan selang
        translate([0, 0, luar_d / 2 + nipple_tinggi - 4])
            cylinder(d1 = nipple_od + 1.2, d2 = nipple_od - 0.4, h = 3);
    }
}

difference() {
    badan();
    lubang();
}
