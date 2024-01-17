
{
	selfdestruct(0x02)
}
// ====
// EVMVersion: <=shanghai
// ----
// Warning 6926: (4-16): "selfdestruct" has been deprecated. Since the VM version Cancun, "selfdestruct" functionality changed as defined by EIP-6780. The new functionality only transfers all Ether in the account to the beneficiary and does not delete any contract's data. However, the previous behavior is preserved when "selfdestruct" is called in the same transaction in which a contract was created. See https://eips.ethereum.org/EIPS/eip-6780 for more information. The use of "selfdestruct" is still not recommended.
