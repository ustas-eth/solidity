contract C {
    function f() public {
        payable(this).transfer(1);
        require(payable(this).send(2));
        selfdestruct(payable(this)); // NOTE: selfdestruct semantics changed in cancun.
        (bool success,) = address(this).delegatecall("");
        require(success);
		(success,) = address(this).call("");
        require(success);
    }
    function g() pure public {
        bytes32 x = keccak256("abc");
        bytes32 y = sha256("abc");
        address z = ecrecover(bytes32(uint256(1)), uint8(2), bytes32(uint256(3)), bytes32(uint256(4)));
        require(true);
        assert(true);
        x; y; z;
    }
    receive() payable external {}
}
// ----
// Warning 1249: (122-134): "selfdestruct" has been deprecated. Since the VM version Cancun, "selfdestruct" functionality changed as defined by EIP-6780. The new functionality only transfers all Ether in the account to the beneficiary. However, the previous behavior is preserved when "selfdestruct" is called in the same transaction in which a contract was created. See https://eips.ethereum.org/EIPS/eip-6780 for more information. The use of "selfdestruct" is still not recommended.
