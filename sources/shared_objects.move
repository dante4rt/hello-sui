module hello_sui::shared_objects {
    use std::string::String;
    
    // Struct untuk registrasi kampus (shared object)
    public struct RegistrasiKampus has key {
        id: UID,
        nama_kampus: String,
        total_mahasiswa: u64,
        daftar_nim: vector<u32>,
        admin: address,
    }
    
    // Fungsi untuk membuat registrasi kampus (shared)
    public fun buat_registrasi_kampus(
        nama_kampus: String,
        ctx: &mut TxContext
    ) {
        let registrasi = RegistrasiKampus {
            id: object::new(ctx),
            nama_kampus,
            total_mahasiswa: 0,
            daftar_nim: vector::empty<u32>(),
            admin: tx_context::sender(ctx),
        };
        
        // Share object agar semua orang bisa akses
        transfer::share_object(registrasi);
    }
    
    // Siapa saja bisa lihat jumlah mahasiswa
    public fun get_total_mahasiswa(registrasi: &RegistrasiKampus): u64 {
        registrasi.total_mahasiswa
    }
    
    // Hanya admin yang bisa tambah mahasiswa
    public fun tambah_mahasiswa_ke_registrasi(
        registrasi: &mut RegistrasiKampus,
        nim: u32,
        ctx: &TxContext
    ) {
        // Cek apakah yang memanggil adalah admin
        assert!(registrasi.admin == tx_context::sender(ctx), 0);
        
        // Tambah mahasiswa
        registrasi.total_mahasiswa = registrasi.total_mahasiswa + 1;
        vector::push_back(&mut registrasi.daftar_nim, nim);
    }
}