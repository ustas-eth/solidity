{
    mstore(0x00, 0x1111111111111111111111111111111122222222222222222222222222222222)
    mstore(0x20, 0x3333333333333333333333333333333344444444444444444444444444444444)
    mstore(0x40, 0x5555555555555555555555555555555566666666666666666666666666666666)

    mcopy(0, 0, 32)      // No-op
    mcopy(0x60, 0, 32)   // Append a duplicate of the first word past msize
    mcopy(0x90, 0x30, 1) // Copy the 0x44 byte from the middle of second word past msize
    mcopy(0, 0, 0)       // No-op
    mcopy(0x2f, 0x90, 2) // Copy the 0x4400 straddling msize back into the the middle of second word
    mcopy(0xa0, 0, 160)  // Duplicate the whole thing
}
// ====
// EVMVersion: >=cancun
// ----
// Trace:
//   MCOPY(0, 0, 32)
//   MCOPY(96, 0, 32)
//   MCOPY(144, 48, 1)
//   MCOPY(0, 0, 0)
//   MCOPY(47, 144, 2)
//   MCOPY(160, 0, 160)
// Memory dump:
//      0: 1111111111111111111111111111111122222222222222222222222222222222
//     20: 3333333333333333333333333333334400444444444444444444444444444444
//     40: 5555555555555555555555555555555566666666666666666666666666666666
//     60: 1111111111111111111111111111111122222222222222222222222222222222
//     80: 0000000000000000000000000000000044000000000000000000000000000000
//     A0: 1111111111111111111111111111111122222222222222222222222222222222
//     C0: 3333333333333333333333333333334400444444444444444444444444444444
//     E0: 5555555555555555555555555555555566666666666666666666666666666666
//    100: 1111111111111111111111111111111122222222222222222222222222222222
//    120: 0000000000000000000000000000000044000000000000000000000000000000
// Storage dump:
