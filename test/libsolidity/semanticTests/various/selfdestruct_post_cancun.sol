contract C {
    event Terminated();

    constructor() payable {}

    function terminate() external {
        emit Terminated();
        // NOTE: The contract `c` should still exists in the test below,
        // since the call to the selfdestruct method was done in a tx that is
        // not the same tx that the contract was created.
        // However, it should send all Ether in `c` to the beneficiary.
        selfdestruct(payable(msg.sender));
    }
}

contract D {
    C public c;

    constructor() payable {
        c = new C{value: 1 ether}();
    }

    function f() external {
        c.terminate();
    }

    function exists() external view returns (bool) {
        return address(c).code.length != 0;
    }
}
// ====
// EVMVersion: >=cancun
// ----
// constructor(), 1 ether ->
// gas irOptimized: 186958
// gas legacy: 255973
// gas legacyOptimized: 178919
// c() -> 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance: 0x137aa4dfc0911524504fcd4d98501f179bc13b4a -> 1000000000000000000
// balance -> 0
// exists() -> true
// f() ->
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance: 0x137aa4dfc0911524504fcd4d98501f179bc13b4a -> 0
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance -> 1000000000000000000
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// exists() -> true
