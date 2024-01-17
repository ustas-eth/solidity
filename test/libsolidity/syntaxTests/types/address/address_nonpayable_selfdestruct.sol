contract C {
    function f(address a) public {
        selfdestruct(a);
    }
}
// ----
// Warning 1249: (56-68): "selfdestruct" has been deprecated. Since the VM version Cancun, "selfdestruct" functionality changed as defined by EIP-6780. The new functionality only transfers all Ether in the account to the beneficiary. However, the previous behavior is preserved when "selfdestruct" is called in the same transaction in which a contract was created. See https://eips.ethereum.org/EIPS/eip-6780 for more information. The use of "selfdestruct" is still not recommended.
// TypeError 9553: (69-70): Invalid type for argument in function call. Invalid implicit conversion from address to address payable requested.
