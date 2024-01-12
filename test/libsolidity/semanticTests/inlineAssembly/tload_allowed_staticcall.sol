contract D {
    function f() external returns (uint x) {
        assembly {
            x := tload(0)
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
        (bool success, bytes memory result) = address(d).staticcall(abi.encodeWithSignature("f()"));
        require(success);
        y = abi.decode(result, (uint));
    }
}
// ====
// EVMVersion: >=cancun
// ----
// test() -> 0
