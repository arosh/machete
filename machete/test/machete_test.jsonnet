local machete = import '../machete.libsonnet';

{
  anyOf: {
    assert !machete.anyOf(function(x) true, []),
    assert !machete.anyOf(function(x) x % 2 == 0, [1, 3, 5, 7]),
    assert machete.anyOf(function(x) x % 2 == 0, [1, 2, 3, 5, 7]),
  },
  allOf: {
    assert machete.allOf(function(x) false, []),
    assert machete.allOf(function(x) x % 2 == 0, [2, 4, 6, 8]),
    assert !machete.allOf(function(x) x % 2 == 0, [2, 4, 5, 6, 8]),
  },
  mergeByKey: {
    local source = [
      {
        name: 'foo',
        image: 'busybox',
        command: ['sh', '-c', 'echo Foo && sleep 3600'],
        imagePullPolicy: 'IfNotPresent',
      },
      {
        name: 'bar',
        image: 'busybox',
        command: ['sh', '-c', 'echo Bar && sleep 3600'],
      },
    ],
    local got = machete.mergeByKey(source, 'name', 'foo', {
      command: ['sh', '-c', 'echo FooFoo && sleep 3600'],
      imagePullPolicy:: self.imagePullPolicy,
    }),
    local want = [
      {
        name: 'foo',
        image: 'busybox',
        command: ['sh', '-c', 'echo FooFoo && sleep 3600'],
      },
      {
        name: 'bar',
        image: 'busybox',
        command: ['sh', '-c', 'echo Bar && sleep 3600'],
      },
    ],

    assert std.assertEqual(want, got),
  },
  takeWhile: {
    local arr = [1, 2, 3, 4, 2, 0, -2],
    assert std.assertEqual([1, 2, 3], machete.takeWhile(function(x) x <= 3, arr)),
    assert std.assertEqual([], machete.takeWhile(function(x) x <= 0, arr)),
    assert std.assertEqual([1, 2, 3, 4, 2, 0, -2], machete.takeWhile(function(x) x <= 4, arr)),
  },
  dropWhile: {
    local arr = [1, 2, 3, 4, 2, 0, -2],
    assert std.assertEqual([4, 2, 0, -2], machete.dropWhile(function(x) x <= 3, arr)),
    assert std.assertEqual([], machete.dropWhile(function(x) x <= 4, arr)),
    assert std.assertEqual([1, 2, 3, 4, 2, 0, -2], machete.dropWhile(function(x) x <= 0, arr)),
  },
  hashObject: {
    local one = { foo: 1, bar: [2, 3] },
    local two = { bar: [2, 3], foo: 1 },
    local three = { foo: 1, bar: [2, 4] },
    assert machete.hashObject(one) == machete.hashObject(two),
    assert machete.hashObject(one) != machete.hashObject(three),
  },
}
