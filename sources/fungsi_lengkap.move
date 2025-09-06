module hello_sui::fungsi_lengkap {
    use std::string::String;
    
    // Error constants
    const ENIM_INVALID: u64 = 0;
    const ENILAI_INVALID: u64 = 1;
    const ESKS_INVALID: u64 = 2;
    const ENOT_AUTHORIZED: u64 = 3;
    
    public struct MahasiswaProfile has key {
        id: UID,
        nama: String,
        nim: u32,
        total_sks: u64,
        nilai_list: vector<u8>,
        owner: address,
    }
    
    // Fungsi dengan validasi lengkap
    public fun buat_profile(
        nama: String,
        nim: u32,
        ctx: &mut TxContext
    ) {
        // Validasi NIM (8 digit, dimulai 20)
        assert!(nim >= 20000000 && nim <= 29999999, ENIM_INVALID);
        
        // Validasi nama tidak kosong
        assert!(string::length(&nama) > 0, 100);
        
        let profile = MahasiswaProfile {
            id: object::new(ctx),
            nama,
            nim,
            total_sks: 0,
            nilai_list: vector::empty<u8>(),
            owner: tx_context::sender(ctx),
        };
        
        transfer::transfer(profile, tx_context::sender(ctx));
    }
    
    // Fungsi dengan authorization check
    public fun tambah_nilai(
        profile: &mut MahasiswaProfile,
        nilai: u8,
        sks: u64,
        ctx: &TxContext
    ) {
        // Cek ownership
        assert!(profile.owner == tx_context::sender(ctx), ENOT_AUTHORIZED);
        
        // Validasi nilai (0-100)
        assert!(nilai <= 100, ENILAI_INVALID);
        
        // Validasi SKS (1-6)
        assert!(sks >= 1 && sks <= 6, ESKS_INVALID);
        
        // Update data
        vector::push_back(&mut profile.nilai_list, nilai);
        profile.total_sks = profile.total_sks + sks;
    }
    
    // Fungsi dengan multiple return values dan control flow
    public fun analisis_performa(profile: &MahasiswaProfile): (u64, bool, String) {
        let jumlah_mk = vector::length(&profile.nilai_list);
        
        // Return early jika belum ada nilai
        if (jumlah_mk == 0) {
            return (0, false, string::utf8(b"Belum ada nilai"))
        };
        
        // Hitung rata-rata nilai
        let mut total_nilai = 0u64;
        let mut i = 0;
        
        while (i < jumlah_mk) {
            let nilai = *vector::borrow(&profile.nilai_list, i);
            total_nilai = total_nilai + (nilai as u64);
            i = i + 1;
        };
        
        let rata_rata = total_nilai / jumlah_mk;
        
        // Tentukan status dan pesan
        let (bisa_lulus, pesan) = if (rata_rata >= 60 && profile.total_sks >= 144) {
            (true, string::utf8(b"Bisa lulus"))
        } else if (rata_rata < 60) {
            (false, string::utf8(b"Nilai kurang"))
        } else {
            (false, string::utf8(b"SKS kurang"))
        };
        
        (rata_rata, bisa_lulus, pesan)
    }
    
    // Fungsi untuk cari nilai tertinggi
    public fun cari_nilai_tertinggi(profile: &MahasiswaProfile): u8 {
        let nilai_list = &profile.nilai_list;
        let len = vector::length(nilai_list);
        
        assert!(len > 0, 200); // Harus ada nilai
        
        let mut max_nilai = *vector::borrow(nilai_list, 0);
        let mut i = 1;
        
        while (i < len) {
            let nilai = *vector::borrow(nilai_list, i);
            if (nilai > max_nilai) {
                max_nilai = nilai;
            };
            i = i + 1;
        };
        
        max_nilai
    }
}