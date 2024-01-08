contract C {
    function expansion_on_write_only() public returns (uint newMsize) {
        assembly {
            mcopy(0xfff0, 0, 1)
            newMsize := msize()
        }
    }

    function expansion_on_read_only() public returns (uint newMsize) {
        assembly {
            mcopy(0, 0xfff0, 1)
            newMsize := msize()
        }
    }

    function expansion_on_read_write() public returns (uint newMsize) {
        assembly {
            mcopy(0xfff0, 0xfff0, 1)
            newMsize := msize()
        }
    }

    function expansion_on_zero_size() public returns (uint newMsize) {
        assembly {
            mcopy(0xfff0, 0xfff0, 0)
            newMsize := msize()
        }
    }
}
// ====
// EVMVersion: >=cancun
// ----
// expansion_on_write_only() -> 0x010000
// expansion_on_read_only() -> 0x010000
// expansion_on_read_write() -> 0x010000
// expansion_on_zero_size() -> 0x60
