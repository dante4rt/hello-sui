#[allow(lint(self_transfer))]

module hello_sui::owned_objects {
    use std::string::String;
    
    // Struct mahasiswa yang dimiliki oleh address tertentu
    public struct KartuMahasiswa has key, store {
        id: UID,
        nama: String,
        nim: u32,
        jurusan: String,
        tahun_masuk: u16,
    }
    
    // Fungsi untuk membuat kartu mahasiswa (owned object)
    public fun daftar_mahasiswa(
        nama: String,
        nim: u32,
        jurusan: String,
        tahun_masuk: u16,
        ctx: &mut TxContext
    ) {
        let kartu = KartuMahasiswa {
            id: object::new(ctx),
            nama,
            nim,
            jurusan,
            tahun_masuk,
        };
        
        // Transfer ke sender (mahasiswa yang mendaftar)
        transfer::transfer(kartu, tx_context::sender(ctx));
    }
    
    // Mahasiswa bisa update data sendiri
    public fun update_nama(kartu: &mut KartuMahasiswa, nama_baru: String) {
        kartu.nama = nama_baru;
    }
    
    // Fungsi untuk transfer kartu ke orang lain
    public fun transfer_kartu(kartu: KartuMahasiswa, penerima: address) {
        transfer::public_transfer(kartu, penerima);
    }
}