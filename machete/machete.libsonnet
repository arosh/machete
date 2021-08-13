{
  anyOf: function(func, arr)
    std.foldl(function(x, y) x || func(y), arr, false),

  allOf: function(func, arr)
    std.foldl(function(x, y) x && func(y), arr, true),

  mergeByKey: function(arr, key, value, obj)
    std.map(function(x) if x[key] == value then x + obj else x, arr),

  takeWhile: function(func, arr) (
    local length = std.length(arr);
    local end = std.foldl(function(x, y) if x == y - 1 && func(arr[y]) then y else x, std.range(0, length - 1), -1) + 1;
    arr[:end]
  ),

  dropWhile: function(func, arr) (
    local length = std.length(arr);
    local begin = std.foldl(function(x, y) if x == y - 1 && func(arr[y]) then y else x, std.range(0, length - 1), -1) + 1;
    arr[begin:]
  ),
}
