local anyOf = function(func, arr) std.foldl(function(x, y) x || func(y), arr, false);
local allOf = function(func, arr) std.foldl(function(x, y) x && func(y), arr, true);

{
  anyOf: anyOf,
  allOf: allOf,
}
