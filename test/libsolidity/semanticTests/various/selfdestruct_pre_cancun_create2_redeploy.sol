contract Factory {
    event Deployed(address, bytes32);

    constructor() payable {}

    function deploy(bytes32 _salt) external payable returns (address payable implAddr) {
        // NOTE: The bytecode of contract C is used here instead of `type(C).creationCode` since the address calculation depends on the precise init code
        // and that will change in our test framework between legacy and via-IR codegen and via optimized vs non-optimized.
        //contract C {
        //    constructor() payable {}
        //    function terminate() external {
        //        selfdestruct(payable(msg.sender));
        //    }
        //}
        bytes memory initCode = hex"6080806040526068908160108239f3fe6004361015600b575f80fd5b5f3560e01c630c08bf8814601d575f80fd5b34602e575f366003190112602e5733ff5b5f80fdfea2646970667358221220c3de57892a1c6056d22f0642a58c16b37fca8b686600d436a5c19ea1791ea2f664736f6c63430008180033";

        address target = address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            _salt,
            keccak256(abi.encodePacked(initCode))
        )))));

        assembly {
            implAddr := create2(callvalue(), add(initCode, 0x20), mload(initCode), _salt)
            if iszero(extcodesize(implAddr)) {
                revert(0, 0)
            }
        }
        assert(address(implAddr) == target);
        emit Deployed(implAddr, _salt);
    }
}

interface IC {
    function terminate() external;
}

contract D {
    Factory private factory;
    IC public c;

    constructor() payable {
        factory = new Factory();
    }

    function deploy() external payable {
        // NOTE: `create2` should be allowed to be used to redeploy a contract in the same place in order to make it upgradable.
        assert(!exists());
        c = IC(factory.deploy{value: 1 ether}(hex"1234"));
        assert(address(this).balance == 0);
        assert(address(c).balance == 1 ether);
    }

    function destroy() external {
        assert(exists());
        c.terminate();
    }

    function testSelfDestruct() external view {
        assert(!exists()); // NOTE: the contract should have been deleted
        assert(address(this).balance == 1 ether);
        assert(address(c).balance == 0);
    }

    function exists() private view returns (bool) {
        return address(c).code.length != 0;
    }
}
// ====
// EVMVersion: =shanghai
// ----
// constructor(), 1 ether ->
// gas irOptimized: 384624
// gas legacy: 643643
// gas legacyOptimized: 381002
// deploy() ->
// ~ emit Deployed(address,bytes32) from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a: 0xf53a5969c17e81c4c041a096cbf710b0c0d86c8e, 0x1234000000000000000000000000000000000000000000000000000000000000
// gas irOptimized: 113836
// gas legacy: 115596
// gas legacyOptimized: 113676
// destroy() ->
// testSelfDestruct() ->
// deploy() ->
// ~ emit Deployed(address,bytes32) from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a: 0xf53a5969c17e81c4c041a096cbf710b0c0d86c8e, 0x1234000000000000000000000000000000000000000000000000000000000000
