local machete = import '../machete.libsonnet';

// anyOf

assert !machete.anyOf(function(x) true, []);
assert !machete.anyOf(function(x) x % 2 == 0, [1, 3, 5, 7]);
assert machete.anyOf(function(x) x % 2 == 0, [1, 2, 3, 5, 7]);

// allOf
assert machete.allOf(function(x) false, []);
assert machete.allOf(function(x) x % 2 == 0, [2, 4, 6, 8]);
assert !machete.allOf(function(x) x % 2 == 0, [2, 4, 5, 6, 8]);

{}
