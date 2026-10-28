// Model 3D alat praktikum fluida dinamis — Rev. 08, paket inti
// Satuan mm. Sumbu: x = arah aliran (kiri → kanan), y = ke belakang, z = ke atas.
// z = 0 permukaan pelat dasar. Datum (sumbu pipa uji bawah) = z 120.
// Ukuran mengikuti desain/perakitan-01-dalam-tangki.md dan perakitan-02-luar-tangki.md.
// Ini model bentuk & tata letak, bukan gambar fabrikasi (fitting disederhanakan).

$fn = 40;

// ---------------- PARAMETER ----------------
DATUM   = 120;      // tinggi sumbu pipa uji bawah dari pelat dasar
DZ      = 120;      // kenaikan tanjakan
LEHER   = 50;       // puncak leher angsa di atas sumbu pipa atas
Y_PIPA  = 100;      // posisi pipa uji (dari depan)
OD_AKR  = 25;       // diameter luar pipa akrilik
OD_PVC12 = 21.3;    // PVC 1/2"
OD_PVC34 = 26.7;    // PVC 3/4"
T_TANGKI = [300, 200, 250];
X_TANGKI = 20;

// warna bahan
C_AKR  = [0.75, 0.90, 0.97, 0.45];   // akrilik bening
C_PVC  = [0.70, 0.74, 0.78];         // PVC
C_PET  = [0.95, 0.65, 0.35];         // cetak 3D PETG
C_KUN  = [0.79, 0.64, 0.15];         // kuningan
C_SEN  = [0.17, 0.19, 0.22];         // sensor
C_SEL  = [0.50, 0.72, 0.84, 0.8];    // selang
C_AIR  = [0.35, 0.64, 0.82, 0.35];

// ---------------- MODUL DASAR ----------------
// batang silinder dari titik a ke titik b
module batang(a, b, d) {
    hull() { translate(a) sphere(d = d); translate(b) sphere(d = d); }
}
// rangkaian batang mengikuti daftar titik
module jalur(pts, d) {
    for (i = [0 : len(pts) - 2]) batang(pts[i], pts[i + 1], d);
}
// silinder sepanjang sumbu x
module silx(x1, x2, d, y = Y_PIPA, z = DATUM) {
    translate([x1, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = x2 - x1);
}

// ---------------- PELAT DASAR & KAKI ----------------
color([0.93, 0.92, 0.88]) translate([0, -40, -18]) cube([1600, 330, 18]);
for (x = [60, 800, 1540]) for (y = [-20, 270])
    color([0.25, 0.27, 0.30]) translate([x, y, -30]) cylinder(d = 40, h = 12);

// ---------------- TANGKI ----------------
module tangki() {
    difference() {
        cube(T_TANGKI);
        translate([5, 5, 5]) cube(T_TANGKI - [10, 10, 0]);
    }
}
translate([X_TANGKI, 0, 0]) {
    color(C_AKR) tangki();
    color(C_AIR) translate([5, 5, 5]) cube([T_TANGKI[0] - 10, T_TANGKI[1] - 10, DATUM - 5]);
    color(C_AKR) translate([195, 5, 60]) cube([3, T_TANGKI[1] - 10, 120]);       // sekat (celah 6 cm di bawah)
}

// ---------------- DALAM TANGKI (langkah 1–8), PVC 1/2" ----------------
Z_POMPA = 45;   // tinggi sumbu outlet pompa
color([0.12, 0.45, 0.72]) translate([60, Y_PIPA - 30, 5]) cube([90, 60, 75]);    // ① pompa
color(C_KUN) silx(150, 210, 28, Y_PIPA, Z_POMPA);                                 // ② katup searah
color(C_KUN) translate([180, Y_PIPA, Z_POMPA + 10]) cylinder(d = 18, h = 12, $fn = 6);
color(C_PVC) silx(210, 223, 25, Y_PIPA, Z_POMPA);                                 // ③ SDL
color(C_PVC) jalur([[223, Y_PIPA, Z_POMPA], [276, Y_PIPA, Z_POMPA],               // ④ ⑤ ⑥ ⑦
                    [276, Y_PIPA, DATUM], [318, Y_PIPA, DATUM]], OD_PVC12);
color(C_KUN) silx(310, 336, 34);                                                  // ⑧ tank connector

// ---------------- LUAR TANGKI (langkah 9–18) ----------------
X_S1 = 336;
color(C_SEN) silx(X_S1, X_S1 + 65, 30);                                           // ⑨ S1
color(C_SEN) translate([X_S1 + 18, Y_PIPA - 10, DATUM + 12]) cube([30, 20, 14]);
X_VER = X_S1 + 65;
color(C_PVC) silx(X_VER, X_VER + 40, 33);                                         // ⑩ SDD verlop

X_A1 = X_VER + 20;                                                                // akrilik masuk 20 mm
color(C_AKR) silx(X_A1, X_A1 + 250, OD_AKR);                                      // ⑪ A1
X_TAP1 = X_A1 + 180;

X_VEN = X_A1 + 230;                                                               // ⑫ venturi
module venturi() {
    // profil luar venturi (diputar mengelilingi sumbu)
    rotate([0, 90, 0]) rotate_extrude($fn = 48)
        polygon([[0, 0], [15.6, 0], [15.6, 23], [13, 23], [8, 47.3], [8, 67.3], [13, 104], [15.6, 104],
                 [15.6, 127], [0, 127]]);
}
color(C_PET) translate([X_VEN, Y_PIPA, DATUM]) venturi();
X_TAP2 = X_VEN + 57;
color(C_PET) translate([X_TAP2, Y_PIPA, DATUM + 7]) cylinder(d = 6, h = 14);

X_A2 = X_VEN + 107;                                                               // ⑬ A2
color(C_AKR) silx(X_A2, X_A2 + 195, OD_AKR);
X_TAP3 = X_A2 + 105;

X_B1 = X_A2 + 195 + 8;                                                            // titik belok bawah
B1 = [X_B1, Y_PIPA, DATUM];
B2 = [X_B1 + DZ, Y_PIPA, DATUM + DZ];                                             // titik belok atas
color(C_PVC) { batang(B1 - [20, 0, 0], B1, 31); batang(B1, B1 + [14, 0, 14], 31); }   // ⑭ siku 45° bawah
color(C_AKR) batang(B1 + [14, 0, 14], B2 - [14, 0, 14], OD_AKR);                // ⑮ A3 tanjakan
TAP4 = (B1 + B2) / 2;
color(C_PVC) { batang(B2 - [14, 0, 14], B2, 31); batang(B2, B2 + [20, 0, 0], 31); }   // ⑯ siku 45° atas

Z_ATAS = DATUM + DZ;
X_A4 = B2[0] + 12;                                                                // ⑰ A4
color(C_AKR) silx(X_A4, X_A4 + 240, OD_AKR, Y_PIPA, Z_ATAS);
X_TAP5 = X_A4 + 120;

X_SDL = X_A4 + 220;                                                               // ⑱ SDL + ball valve
color(C_PVC) silx(X_SDL, X_SDL + 40, 33, Y_PIPA, Z_ATAS);
color([0.12, 0.45, 0.72]) silx(X_SDL + 40, X_SDL + 105, 40, Y_PIPA, Z_ATAS);
color([0.75, 0.15, 0.12]) translate([X_SDL + 72, Y_PIPA, Z_ATAS + 20]) rotate([0, 60, 0]) cylinder(d = 6, h = 45);

// ⑲ leher angsa (PVC 3/4")
X_LA = X_SDL + 105;
Z_PUNCAK = Z_ATAS + LEHER;
X_MULUT = X_LA + 80;
color(C_PVC) jalur([[X_LA, Y_PIPA, Z_ATAS], [X_LA + 30, Y_PIPA, Z_ATAS], [X_LA + 30, Y_PIPA, Z_PUNCAK],
                    [X_MULUT, Y_PIPA, Z_PUNCAK], [X_MULUT, Y_PIPA, Z_PUNCAK - 30]], OD_PVC34);

// ⑳ corong + pipa balik (menurun ke tangki, masuk di atas muka air)
Z_CORONG = Z_PUNCAK - 45;
color(C_AKR) translate([X_MULUT, Y_PIPA, Z_CORONG - 40]) cylinder(d1 = 16, d2 = 90, h = 40);
Z_INLET = 150;                                                                    // tank connector kedua
color(C_PVC) jalur([[X_MULUT, Y_PIPA, Z_CORONG - 40], [X_MULUT, Y_PIPA, Z_INLET + 35],
                    [X_MULUT, 275, Z_INLET + 35], [X_TANGKI + T_TANGKI[0] + 20, 275, Z_INLET + 5],
                    [X_TANGKI + T_TANGKI[0] + 20, 165, Z_INLET], [X_TANGKI + T_TANGKI[0] - 2, 165, Z_INLET]],
                   OD_PVC34);
color(C_KUN) translate([X_TANGKI + T_TANGKI[0] - 6, 165, Z_INLET]) rotate([0, 90, 0]) cylinder(d = 34, h = 20);

// ---------------- TUMPUAN PIPA ----------------
for (p = [[X_A1 + 60, DATUM], [X_A2 + 60, DATUM], [X_A4 + 150, Z_ATAS], [X_SDL + 70, Z_ATAS]])
    color([0.88, 0.89, 0.88]) translate([p[0] - 8, Y_PIPA - 8, 0]) cube([16, 16, p[1] - 12]);

// ---------------- PANEL MANOMETER ----------------
Y_PAPAN = 225;
X_PAPAN1 = X_A1 + 120;  X_PAPAN2 = X_A4 + 200;
Z_ATAS_SELANG = DATUM + 450;
color([0.97, 0.97, 0.95]) translate([X_PAPAN1, Y_PAPAN, DATUM - 20]) cube([X_PAPAN2 - X_PAPAN1, 8, 500]);
for (x = [X_PAPAN1 - 16, X_PAPAN2]) color([0.88, 0.89, 0.88]) translate([x, Y_PAPAN, 0]) cube([16, 16, DATUM + 480]);
color([1, 0.95, 0.75]) translate([X_PAPAN1 + 10, Y_PAPAN - 1, DATUM]) cube([18, 1, 450]);   // meteran tempel

// selang: sadap → naik → ke papan → tegak sampai 450 mm di atas datum
module selang(tap, xkol, zmulai) {
    color(C_SEL) jalur([tap, tap + [0, 0, 25], [xkol, Y_PAPAN - 6, zmulai], [xkol, Y_PAPAN - 6, Z_ATAS_SELANG]], 7);
    color(C_KUN) translate(tap - [0, 0, 4]) cylinder(d = 8, h = 10);
}
selang([X_TAP1, Y_PIPA, DATUM + 12], X_TAP1,  DATUM + 60);
selang([X_TAP2, Y_PIPA, DATUM + 21], X_TAP2,  DATUM + 60);
selang([X_TAP3, Y_PIPA, DATUM + 12], X_TAP3,  DATUM + 60);
selang(TAP4 + [-9, 0, 9],             TAP4[0] - 9, DATUM + 100);
selang([X_TAP5, Y_PIPA, Z_ATAS + 12], X_TAP5,  DATUM + 170);

// ---------------- KOTAK ELEKTRONIK ----------------
color([0.88, 0.89, 0.88]) translate([X_S1 + 80, 30, 0]) cube([14, 14, 200]);
color([0.96, 0.96, 0.94]) translate([X_S1 + 20, 10, 200]) cube([160, 60, 90]);
color(C_SEN) translate([X_S1 + 35, 9, 240]) cube([80, 2, 35]);                   // LCD

echo(str("Panjang pelat dasar 1600 mm; ujung mulut leher angsa x = ", X_MULUT, " mm"));
echo(str("Sadap: x1=", X_TAP1, " x2=", X_TAP2, " x3=", X_TAP3, " titik4=", TAP4, " x5=", X_TAP5));
