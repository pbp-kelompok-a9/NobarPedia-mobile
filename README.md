# 📺 NobarPedia-Mobile 📺
## Proyek Akhir Semester Mata Kuliah Pemrograman Berbasis Platform 25/26

[![Build Status](https://app.bitrise.io/app/3ea252d0-dbb4-4afc-827f-6eec8436263f/status.svg?token=vrZwF6Soiqv-V47o-6vO9w&branch=main)](https://app.bitrise.io/app/3ea252d0-dbb4-4afc-827f-6eec8436263f)

---

## ⬇️ Download
Download aplikasi versi terbaru [disini](https://app.bitrise.io/app/3ea252d0-dbb4-4afc-827f-6eec8436263f/installable-artifacts/0ca65aeab7103551/public-install-page/9aedfac695f1fbf74842a4a7ffb42209).

---

## ❓ Apa itu NobarPedia?

**NobarPedia** adalah website komunitas yang memudahkan kamu untuk mencari dan berbagi informasi seputar tempat nonton bareng di seluruh Indonesia. Di sini, kamu bisa menemukan berbagai lokasi nobar berdasarkan jarak terdekat, waktu pertandingan, atau tempat nobar yang paling rame. Kamu juga bisa menambahkan tempat nobar baru, daftar untuk ikut nonton di suatu lokasi, memberi review, dan berbagi rekomendasi dengan teman-temanmu. Dengan NobarPedia, nyari tempat nobar jadi lebih seru, gampang, dan bikin kamu makin deket sama sesama pecinta nobar!

---

## 👨‍👨‍👦‍👦 Anggota Kelompok

| NPM | Nama | Akun Github |
| :-- | :--- | :---------- |
| 2406353276 | Inayah Saffanah Asri | [inaeah](https://github.com/Inaeah) |
| 2406434090 | Daffa Ismail | [dfi06](https://github.com/dfi06) |
| 2406426196 | Faiz Kusumadinata | [FaizKusumadinata](https://github.com/FaizKusumadinata) |
| 2406358056 | Christopher Evan Tanuwidjaja | [evan052006](https://github.com/evan052006) |
| 2406362860 | Muhammad Lanang Zalkifla Harits | [r3gulus-4rcturus](https://github.com/r3gulus-4rcturus) |

---

## 📚 Modul

+ 🔐 **Account**

*Dikerjakan oleh [Lanang](https://github.com/r3gulus-4rcturus)* 

Modul ini berfungsi untuk mengatur sistem autentikasi pengguna dalam aplikasi. Di dalamnya terdapat halaman registrasi, login, dan logout. Pengguna bertipe **User** dapat melihat profil dirinya sendiri maupun pengguna lain, memperbarui data diri, mengganti password, serta menghapus akun pribadi. **Guest** memiliki akses untuk melakukan registrasi dan login, sedangkan **Admin** dapat melihat data pengguna lain serta memiliki wewenang untuk menghapus akun pengguna tertentu.  


+ 🏠 **Homepage**

*Dikerjakan oleh [Inaeah](https://github.com/Inaeah)*

Modul ini mengelola operasi **CRUD** untuk entitas *acara nobar*. Acara nobar merupakan event yang berlangsung di suatu tempat nobar. **Guest**, **User**, maupun **Admin** dapat melihat daftar acara nobar. Pengguna bertipe **User** dapat menambahkan tempat nobar baru, membuat acara nobar, serta mengedit detail tempat dan acara yang dimilikinya.  

+ 🗓️ **Match**

*Dikerjakan oleh [Evan](https://github.com/evan052006)*

Modul ini berfungsi untuk mengatur data pertandingan atau *match*. Hanya **Admin** yang memiliki hak penuh untuk melakukan operasi **CRUD** pada data *match*, termasuk menambah, mengedit, melihat, dan menghapus jadwal pertandingan. **User** dan **Guest** hanya memiliki akses untuk melihat daftar jadwal pertandingan yang tersedia.  

+ 🙋‍♂️ **Join**

*Dikerjakan oleh [Daffa](https://github.com/dfi06)*

Modul ini mengatur interaksi pengguna terhadap acara nobar melalui fitur **Join**. Pengguna bertipe **User** dapat memilih untuk bergabung ke dalam suatu acara nobar dengan dua opsi, yaitu ```pasti datang``` atau ```belum pasti datang```. Selain itu, **User** dapat mengubah pilihannya, membatalkan keikutsertaan, dan melihat jumlah peserta yang telah bergabung. Pemilik tempat nobar dapat melihat daftar pengguna yang bergabung dalam acara mereka. Sementara itu, **Guest** hanya dapat melihat jumlah pengunjung yang telah bergabung tanpa bisa berinteraksi lebih lanjut.  

+ ⭐ **Review**

*Dikerjakan oleh [Faiz](https://github.com/FaizKusumadinata)*

Modul ini menyediakan fitur **CRUD** untuk ulasan (*review*) terhadap tempat nobar. Pengguna bertipe **User** dapat memberikan ulasan berupa rating bintang dan komentar terhadap suatu tempat nobar, serta mengedit atau menghapus ulasan yang telah dibuat. **Guest** hanya dapat melihat daftar ulasan yang tersedia tanpa dapat menambah atau mengubahnya. 

---

## 🪪 Role

* **Guest** → Pengguna yang mengakses **NobarPedia** tanpa melakukan autentikasi.  

* **User** → Pengguna yang dapat membuat dan mengelola tempat dan acara nobar, memberikan review, serta bergabung dalam acara nobar.  

* **Admin** → Pengguna yang memiliki hak untuk melakukan manipulasi match.

---

## ⚙️ Alur pengintegrasian dengan web service

1. Pengintegrasian aplikasi mobile dengan web service dilakukan dengan mengambil data berformat JSON dari URL web service yang digunakan untuk deploy Proyek Tengah Semester.
2. Proses fetch dilakukan menggunakan Uri.parse pada file Dart, kemudian data diambil dengan metode GET yang memiliki tipe application/json.
3. Setelah data berhasil diambil, data tersebut di-decode menggunakan jsonDecode(). Hasil decode kemudian diubah ke dalam bentuk model yang sudah dibuat, dan ditampilkan secara asinkron melalui widget FutureBuilder.
4. Data JSON tersebut kemudian dapat dimanfaatkan untuk operasi CRUD di kedua platform secara asinkron

---

## 🗂️ Dataset

Dataset awal pada aplikasi ini bersumber dari **Google Maps API**.
Dataset tersebut dapat dilihat [disini](https://pastebin.com/86erZaLJ).

---

## 🎨 Design

Design web dapat dilihat [disini](https://www.figma.com/design/Rrkw3y34LQvzZG2eX4y9qv/NobarPedia?node-id=1-4&t=pk6UbIUrCsmu7ZqR-1).

---

## 📝 Spreadsheet Planning

Spreadsheet planning dapat dilihat [disini](https://docs.google.com/spreadsheets/d/1DroMRWnR7XHWlZpcN-5UQMeX-QigGDYLUc1qxplRMDs/edit?usp=sharing).