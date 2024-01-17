contract C {
    function f() view public {
        payable(this).transfer(1);
    }
    function g() view public {
        require(payable(this).send(2));
    }
    function h() view public {
        selfdestruct(payable(this));
    }
    function i() view public {
        (bool success,) = address(this).delegatecall("");
        require(success);
    }
    function j() view public {
        (bool success,) = address(this).call("");
        require(success);
    }
    receive() payable external {
    }
}
// ====
// EVMVersion: >=cancun
// ----
// Warning 1249: (201-213): "selfdestruct" has been deprecated. Since the VM version Cancun, "selfdestruct" functionality changed as defined by EIP-6780. The new functionality only transfers all Ether in the account to the beneficiary. However, the previous behavior is preserved when "selfdestruct" is called in the same transaction in which a contract was created. See https://eips.ethereum.org/EIPS/eip-6780 for more information. The use of "selfdestruct" is still not recommended.
// TypeError 8961: (52-77): Function cannot be declared as view because this expression (potentially) modifies the state.
// TypeError 8961: (132-153): Function cannot be declared as view because this expression (potentially) modifies the state.
// TypeError 8961: (201-228): Function cannot be declared as view because this expression (potentially) modifies the state.
// TypeError 8961: (293-323): Function cannot be declared as view because this expression (potentially) modifies the state.
// TypeError 8961: (414-436): Function cannot be declared as view because this expression (potentially) modifies the state.
