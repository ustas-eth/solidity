contract C {
    constructor() payable {
        assert(address(this).balance == 1 ether);
        assert(address(msg.sender).balance == 0);
        selfdestruct(payable(msg.sender));
    }
}

contract D {
    C public c;

    constructor() payable {
        c = new C{value: 1 ether, salt: hex"1234"}();
        assert(address(c).code.length == 0); // NOTE: the contract should have been deleted
        assert(address(this).balance == 1 ether);
        assert(address(c).balance == 0);
    }
}
// ====
// EVMVersion: >=cancun
// ----
// constructor(), 1 ether ->
// gas irOptimized: 186958
// gas legacy: 286289
// gas legacyOptimized: 178919
