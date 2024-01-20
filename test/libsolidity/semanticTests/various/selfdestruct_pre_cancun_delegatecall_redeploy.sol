library L {
    event Deployed(address, bytes32);

    function deploy(bytes32 _salt) external returns (address implAddr) {
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

    constructor() payable {}

    function deploy() external {
        (bool success, bytes memory result) = address(L).delegatecall(
            abi.encodeWithSignature("deploy(bytes32)", hex"1234")
        );
        assert(success);

        c = IC(abi.decode(result, (address)));
        payable(address(c)).transfer(1 ether);

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
// library: L
// constructor(), 1 ether ->
// gas irOptimized: 204339
// gas legacy: 633310
// gas legacyOptimized: 223980
// deploy() ->
// ~ emit Deployed(address,bytes32): 0x3b3b9d58991d62925621b917548f1f67d3b0886f, 0x20
// gas irOptimized: 110274
// gas legacyOptimized: 110512
// destroy() ->
// testSelfDestruct() ->
// deploy() ->
// ~ emit Deployed(address,bytes32): 0x3b3b9d58991d62925621b917548f1f67d3b0886f, 0x20
