contract D {
    function f() external returns (uint x) {
        assembly {
            tstore(0, 42)
        }
    }
}

contract C {
    function test() external returns (bool) {
        D d = new D();
        (bool success, ) = address(d).staticcall(abi.encodeWithSignature("f()"));
        require(!success);
        return true;
    }
}
// ====
// EVMVersion: >=cancun
// ----
// test() -> true
