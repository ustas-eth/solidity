contract C {
    function f() external pure {
        assembly {
            pop(tload(0))
        }
    }
}
// ====
// EVMVersion: >=cancun
// ----
// Warning 2394: (81-86): Transient storage as defined by EIP-1153 can break the composability of smart contracts: Since transient storage is cleared only at the end of the transaction and not at the end of the outermost call frame to the contract within a transaction, your contract may unintentionally misbehave when invoked multiple times in a complex transaction. To avoid this, be sure to clear all transient storage at the end of any call to your contract. The use of transient storage for reentrancy guards that are cleared at the end of the call is safe.
// TypeError 2527: (81-89): Function declared as pure, but this expression (potentially) reads from the environment or state and thus requires "view".
