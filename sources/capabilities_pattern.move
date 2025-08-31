module hello_sui::capabilities_pattern {
    use std::string::String;
    
    // Admin capability - hanya admin yang punya
    public struct AdminCap has key, store {
        id: UID,
    }
    
    // Dosen capability - hanya dosen yang punya
    public struct DosenCap has key, store {
        id: UID,
        mata_kuliah: String,
    }
    
    // Struct untuk sistem nilai
    public struct SistemNilai has key {
        id: UID,
        total_mahasiswa: u64,
    }
    
    // Struct untuk nilai mahasiswa
    public struct NilaiMahasiswa has key, store {
        id: UID,
        nim: u32,
        mata_kuliah: String,
        nilai: u8,
        dosen_pemberi: address,
    }
    
    // Init function - jalan sekali saat deploy
    fun init(ctx: &mut TxContext) {
        // Buat admin capability
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        
        // Buat sistem nilai
        let sistem = SistemNilai {
            id: object::new(ctx),
            total_mahasiswa: 0,
        };
        
        // Transfer admin cap ke deployer
        transfer::transfer(admin_cap, tx_context::sender(ctx));
        
        // Share sistem nilai
        transfer::share_object(sistem);
    }
    
    // Hanya admin yang bisa buat dosen capability
    public fun buat_dosen_cap(
        _: &AdminCap, // Admin capability sebagai "kunci"
        mata_kuliah: String,
        dosen_address: address,
        ctx: &mut TxContext
    ) {
        let dosen_cap = DosenCap {
            id: object::new(ctx),
            mata_kuliah,
        };
        
        transfer::transfer(dosen_cap, dosen_address);
    }
    
    // Hanya dosen yang bisa kasih nilai
    public fun beri_nilai(
        dosen_cap: &DosenCap,
        sistem: &mut SistemNilai,
        nim: u32,
        nilai: u8,
        mahasiswa_address: address,
        ctx: &mut TxContext
    ) {
        // Validasi nilai
        assert!(nilai <= 100, 1);
        
        let nilai_obj = NilaiMahasiswa {
            id: object::new(ctx),
            nim,
            mata_kuliah: dosen_cap.mata_kuliah,
            nilai,
            dosen_pemberi: tx_context::sender(ctx),
        };
        
        // Update sistem
        sistem.total_mahasiswa = sistem.total_mahasiswa + 1;
        
        // Transfer ke mahasiswa
        transfer::transfer(nilai_obj, mahasiswa_address);
    }
}