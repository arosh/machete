{
  anyOf(func, arr)::
    std.foldl(function(x, y) x || func(y), arr, false),

  allOf(func, arr)::
    std.foldl(function(x, y) x && func(y), arr, true),

  mergeByKey(arr, key, value, obj)::
    std.map(function(x) if x[key] == value then x + obj else x, arr),

  takeWhile(func, arr)::
    local length = std.length(arr);
    local end = std.foldl(function(x, y) if x == y - 1 && func(arr[y]) then y else x, std.range(0, length - 1), -1) + 1;
    arr[:end],

  dropWhile(func, arr)::
    local length = std.length(arr);
    local begin = std.foldl(function(x, y) if x == y - 1 && func(arr[y]) then y else x, std.range(0, length - 1), -1) + 1;
    arr[begin:],

  deepFlattenArrays(arr)::
    std.flatMap(function(x) if std.isArray(x) then self.deepFlattenArrays(x) else [x], arr),

  hashObject(obj)::
    local marshal = self.manifestJsonMinified(obj);
    local digest = std.md5(marshal);
    // https://github.com/kubernetes/kubernetes/blob/de40aa59f31282a8f8c033d2bd4d78b9645d8f23/staging/src/k8s.io/kubectl/pkg/util/hash/hash.go#L97-L104
    local rule = { '0': 'g', '1': 'h', '3': 'k', a: 'm', e: 't' };
    local replacer(c) = if std.objectHas(rule, c) then rule[c] else c;
    std.join('', [replacer(c) for c in std.stringChars(digest[:10])]),

  // Backport until go-jsonnet 0.18.0 is released.
  // https://github.com/google/jsonnet/blob/2ac965472e9b7229d4ffca4c546025ac88a01add/stdlib/std.jsonnet#L1005
  manifestJsonMinified(value):: std.manifestJson(value),

  // generate integer from 0 to m-1 based on string s
  hashModulo(s, m)::
    local h = std.md5(s);
    local xs = [std.parseHex(c) for c in std.stringChars(h)];
    std.foldl(function(x, y) (x * 16 + y) % m, xs, 0),
}
