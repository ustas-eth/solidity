contract D {
    function f() external {
        assembly {
            let x:= tload(0)
            tstore(0, add(x, 1))
        }
    }
}

contract C {
    function set(uint x) external {
        assembly {
            tstore(0, x)
        }
    }

    function get() external view returns (uint x) {
        assembly {
            x := tload(0)
        }
    }

    function test() external returns (uint y) {
        this.set(5);
        D d = new D();
        // Caller contract is the owner of the transient storage
        address(d).delegatecall(abi.encodeWithSignature("f()"));
        y = this.get();
    }
}
// ====
// EVMVersion: >=cancun
// ----
// test() -> 6
