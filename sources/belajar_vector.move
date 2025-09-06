module hello_sui::belajar_vector {
    use std::string::String;
    
    // Struct untuk menyimpan daftar mahasiswa
    public struct DaftarMahasiswa has key {
        id: UID,
        nama_mahasiswa: vector<String>,
        nim_mahasiswa: vector<u32>,
    }
    
    // Fungsi untuk membuat daftar kosong
    public fun buat_daftar_kosong(ctx: &mut TxContext): DaftarMahasiswa {
        DaftarMahasiswa {
            id: object::new(ctx),
            nama_mahasiswa: vector::empty<String>(),
            nim_mahasiswa: vector::empty<u32>(),
        }
    }
    
    // Fungsi untuk tambah mahasiswa ke daftar
    public fun tambah_mahasiswa(
        daftar: &mut DaftarMahasiswa,
        nama: String,
        nim: u32
    ) {
        vector::push_back(&mut daftar.nama_mahasiswa, nama);
        vector::push_back(&mut daftar.nim_mahasiswa, nim);
    }
    
    // Fungsi untuk menghitung jumlah mahasiswa
    public fun jumlah_mahasiswa(daftar: &DaftarMahasiswa): u64 {
        vector::length(&daftar.nama_mahasiswa)
    }
    
    // Fungsi untuk mendapatkan mahasiswa berdasarkan index
    public fun get_mahasiswa_ke(daftar: &DaftarMahasiswa, index: u64): (String, u32) {
        let nama = *vector::borrow(&daftar.nama_mahasiswa, index);
        let nim = *vector::borrow(&daftar.nim_mahasiswa, index);
        (nama, nim)
    }
    
    // Fungsi untuk cek apakah daftar kosong
    public fun apakah_kosong(daftar: &DaftarMahasiswa): bool {
        vector::is_empty(&daftar.nama_mahasiswa)
    }
}