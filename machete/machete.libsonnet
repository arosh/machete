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

  hashObject(obj)::
    local marshal = self.manifestJsonMinified(obj);
    local digest = std.md5(marshal);
    // https://github.com/kubernetes/kubernetes/blob/de40aa59f31282a8f8c033d2bd4d78b9645d8f23/staging/src/k8s.io/kubectl/pkg/util/hash/hash.go#L97-L104
    local rule = { '0': 'g', '1': 'h', '3': 'k', a: 'm', e: 't' };
    local replacer(c) = if std.objectHas(rule, c) then rule[c] else c;
    std.join('', [replacer(c) for c in std.stringChars(digest[:10])]),
  
  
  // Backport until go-jsonnet 0.18.0 is released.
  // https://github.com/google/jsonnet/blob/2ac965472e9b7229d4ffca4c546025ac88a01add/stdlib/std.jsonnet#L1005-L1042
  manifestJsonMinified(value):: self.manifestJsonEx(value, '', '', ':'),

  manifestJsonEx(value, indent, newline='\n', key_val_sep=': ')::
    local aux(v, path, cindent) =
      if v == true then
        'true'
      else if v == false then
        'false'
      else if v == null then
        'null'
      else if std.isNumber(v) then
        '' + v
      else if std.isString(v) then
        std.escapeStringJson(v)
      else if std.isFunction(v) then
        error 'Tried to manifest function at ' + path
      else if std.isArray(v) then
        local range = std.range(0, std.length(v) - 1);
        local new_indent = cindent + indent;
        local lines = ['[' + newline]
                      + std.join([',' + newline],
                                 [
                                   [new_indent + aux(v[i], path + [i], new_indent)]
                                   for i in range
                                 ])
                      + [newline + cindent + ']'];
        std.join('', lines)
      else if std.isObject(v) then
        local lines = ['{' + newline]
                      + std.join([',' + newline],
                                 [
                                   [cindent + indent + std.escapeStringJson(k) + key_val_sep
                                    + aux(v[k], path + [k], cindent + indent)]
                                   for k in std.objectFields(v)
                                 ])
                      + [newline + cindent + '}'];
        std.join('', lines);
    aux(value, [], ''),
}
