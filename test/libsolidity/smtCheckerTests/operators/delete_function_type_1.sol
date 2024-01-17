struct S {
    function() e;
}

contract C {
    S s;
    function() f;

    constructor() {
        delete s.e;
        assert(s.e == f); // should fail for now because function pointer comparisons are not supported
    }
}
// ----
// Warning 3075: (128-136): Comparison of internal function pointers can yield unexpected results in the legacy pipeline with the optimizer enabled, and will be disallowed entirely in the next breaking release.
// Warning 7229: (128-136): Assertion checker does not yet implement the type function () for comparisons
// Warning 6328: (121-137): CHC: Assertion violation happens here.

