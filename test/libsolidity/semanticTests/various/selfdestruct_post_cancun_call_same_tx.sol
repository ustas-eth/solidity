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
    event Deployed(address);

    C public c;

    constructor() payable {}

    function deploy() external payable {
        c = new C{value: msg.value}();
        emit Deployed(address(c));
    }

    function test() external payable {
        (bool success, ) = address(this).call{value: 1 ether}(
            abi.encodeCall(this.deploy, ())
        );
        assert(success);
    }

    function exists() external view returns (bool) {
        return address(c).code.length != 0;
    }
}
// ====
// EVMVersion: >=cancun
// ----
// constructor(), 1 ether ->
// gas irOptimized: 398686
// gas legacy: 633310
// gas legacyOptimized: 395121
// test() ->
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// ~ emit Deployed(address): 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance: 0x16c1f046f11a146d1afa3c5894ad19c9dc55d086 -> 0
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// ~ emit Deployed(address): 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// balance -> 1000000000000000000
// ~ emit Terminated() from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// ~ emit Deployed(address): 0x137aa4dfc0911524504fcd4d98501f179bc13b4a
// exists() -> false
