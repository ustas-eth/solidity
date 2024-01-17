contract C {
    event Terminated();

    constructor() payable {
        assert(address(this).balance == 1 ether);
        assert(address(msg.sender).balance == 0);
        emit Terminated();
        selfdestruct(payable(msg.sender));
    }
}

contract D {
    C public c;

    constructor() payable {
        c = new C{value: 1 ether}();
    }

    function exists() external view returns (bool) {
        return address(c).code.length != 0;
    }
}
// ====
// EVMVersion: >=cancun
// ----
// constructor(), 1 ether ->
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// c() -> 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance: 0x137aa4dfc0911524504fcd4d98501f179bc13b4a -> 0
// balance -> 1000000000000000000
// exists() -> false
