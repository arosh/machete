{
  anyOf: function(func, arr)
    std.foldl(function(x, y) x || func(y), arr, false),

  allOf: function(func, arr)
    std.foldl(function(x, y) x && func(y), arr, true),

  mergeByKey: function(arr, key, value, obj)
    std.map(function(x) if x[key] == value then x + obj else x, arr),
}
