{
    calldatacopy(0, 0, 0x20)

    mcopy(0, 0, 0x20) // Redundant. Does not change any values (only affects MSIZE).

    return(0, 0x20)
}
// ====
// EVMVersion: >=cancun
// ----
// step: fullSuite
//
// {
//     {
//         calldatacopy(0, 0, 0x20)
//         mcopy(0, 0, 0x20)
//         return(0, 0x20)
//     }
// }
