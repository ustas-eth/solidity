contract C {
    constructor() payable {}

    function terminate() external {
        selfdestruct(payable(msg.sender));
    }
}

contract D {
    C public c;

    constructor() payable {
        c = new C{value: 1 ether, salt: hex"1234"}();
    }

    function destroy() external {
        assert(address(this).balance == 0);
        assert(address(c).balance == 1 ether);
        assert(exists());
        c.terminate();
    }

    function testSelfDestruct() external view {
        assert(exists()); // NOTE: the contract should still exists
        assert(address(this).balance == 1 ether);
        assert(address(c).balance == 0);
    }

    function exists() private view returns (bool) {
        return address(c).code.length != 0;
    }
}
// ====
// EVMVersion: >=cancun
// ----
// constructor(), 1 ether ->
// gas irOptimized: 186958
// gas legacy: 286289
// gas legacyOptimized: 178919
// destroy() ->
// testSelfDestruct() ->
