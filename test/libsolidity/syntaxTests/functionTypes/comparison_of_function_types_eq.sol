contract C {
    function f() public returns (bool ret) {
        return f == f;
    }
    function g() public returns (bool ret) {
        return f != f;
    }
}
// ----
// Warning 3075: (73-79): Comparison of internal function pointers can yield unexpected results in the legacy pipeline with the optimizer enabled, and will be disallowed entirely in the next breaking release.
// Warning 3075: (147-153): Comparison of internal function pointers can yield unexpected results in the legacy pipeline with the optimizer enabled, and will be disallowed entirely in the next breaking release.
// Warning 2018: (17-86): Function state mutability can be restricted to pure
// Warning 2018: (91-160): Function state mutability can be restricted to pure
