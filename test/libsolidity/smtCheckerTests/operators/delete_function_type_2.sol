contract C {
    mapping (uint => function()) m;
    function() f;

    constructor() {
        m[2] = f;
        delete m[2];
        assert(m[2] == f); // should fail for now because function pointer comparisons are not supported
    }
}
// ----
// Warning 3075: (142-151): Comparison of internal function pointers can yield unexpected results in the legacy pipeline with the optimizer enabled, and will be disallowed entirely in the next breaking release.
// Warning 7229: (142-151): Assertion checker does not yet implement the type function () for comparisons
// Warning 6328: (135-152): CHC: Assertion violation happens here.
