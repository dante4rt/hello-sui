module hello_sui::belajar_boolean {
    use std::string::String;
    
    // Struct dengan boolean
    public struct StatusMahasiswa has key {
        id: UID,
        nama: String,
        aktif: bool,
        lulus: bool,
    }
    
    // Fungsi untuk membuat status mahasiswa
    public fun buat_status(nama: String, ctx: &mut TxContext): StatusMahasiswa {
        StatusMahasiswa {
            id: object::new(ctx),
            nama,
            aktif: true,  // Default aktif
            lulus: false, // Default belum lulus
        }
    }
    
    // Fungsi untuk set lulus
    public fun set_lulus(status: &mut StatusMahasiswa) {
        status.lulus = true;
    }
    
    // Fungsi untuk nonaktifkan
    public fun nonaktifkan(status: &mut StatusMahasiswa) {
        status.aktif = false;
    }
    
    // Fungsi untuk cek apakah bisa wisuda
    public fun bisa_wisuda(status: &StatusMahasiswa): bool {
        status.aktif && status.lulus
    }
}