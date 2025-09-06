module hello_sui::belajar_number {
    // Struct untuk data mahasiswa dengan angka
    public struct DataMahasiswa has key {
        id: UID,
        nim: u32,
        umur: u8,
        total_sks: u64,
    }
    
    // Fungsi untuk membuat data mahasiswa
    public fun buat_data_mahasiswa(
        nim: u32,
        umur: u8,
        ctx: &mut TxContext
    ): DataMahasiswa {
        DataMahasiswa {
            id: object::new(ctx),
            nim,
            umur,
            total_sks: 0,
        }
    }
    
    // Fungsi untuk menambah SKS
    public fun tambah_sks(data: &mut DataMahasiswa, sks: u64) {
        data.total_sks = data.total_sks + sks;
    }
    
    // Fungsi untuk menambah umur
    public fun tambah_umur(data: &mut DataMahasiswa) {
        data.umur = data.umur + 1;
    }
}