module hello_sui::belajar_string {
    use std::string::{String};
    
    // Struct untuk menyimpan nama mahasiswa
    public struct Mahasiswa has key {
        id: UID,
        nama: String,
    }
    
    // Fungsi untuk membuat mahasiswa baru
    public fun buat_mahasiswa(nama: String, ctx: &mut TxContext): Mahasiswa {
        Mahasiswa {
            id: object::new(ctx),
            nama,
        }
    }
    
    // Fungsi untuk mengubah nama
    public fun ubah_nama(mahasiswa: &mut Mahasiswa, nama_baru: String) {
        mahasiswa.nama = nama_baru;
    }
    
    // Fungsi untuk mendapatkan nama
    public fun get_nama(mahasiswa: &Mahasiswa): String {
        mahasiswa.nama
    }
}