contract Factory {
    event Deployed(address, bytes32);

    function deploy(bytes32 _salt) external payable returns (address implAddr) {
        // NOTE: The bytecode of contract C is used here instead of `type(C).creationCode` since the address calculation depends on the precise init code
        // and that will change in our test framework between legacy and via-IR codegen and via optimized vs non-optimized.
        //contract C {
        //    constructor() payable {}
        //    receive() external payable {}
        //    function terminate() external {
        //        selfdestruct(payable(msg.sender));
        //    }
        //}
        bytes memory initCode =
            hex"608080604052606c908160108239f3fe60043610156013575b36156011575f80"
            hex"fd5b005b5f3560e01c630c08bf8803600857346032575f366003190112603257"
            hex"33ff5b5f80fdfea26469706673582212206e19160634438b12a36d2fa77cda05"
            hex"0e2c46846d03e41b19aab5a6207d18356564736f6c63430008180033";

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
    IC public c;
    Factory private factory;

    constructor() payable {
        factory = new Factory();
    }

    function deploy() external {
        (bool success, bytes memory result) = address(factory).call{value: 1 ether}(
            abi.encodeCall(factory.deploy, hex"1234")
        );
        assert(success);
        c = IC(abi.decode(result, (address)));

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
// EVMVersion: <=shanghai
// ----
// constructor(), 1 ether ->
// gas irOptimized: 398686
// gas legacy: 633310
// gas legacyOptimized: 395121
// deploy() ->
// ~ emit Deployed(address,bytes32) from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a: 0x9362661c5c9e254674ecdac2a2b94b3c97048dd3, 0x1234000000000000000000000000000000000000000000000000000000000000
// gas irOptimized: 112076
// gas legacyOptimized: 112201
// destroy() ->
// testSelfDestruct() ->
// deploy() ->
// ~ emit Deployed(address,bytes32) from 0x137aa4dfc0911524504fcd4d98501f179bc13b4a: 0x9362661c5c9e254674ecdac2a2b94b3c97048dd3, 0x1234000000000000000000000000000000000000000000000000000000000000
