actor Counter
  var _count: U32

  new create() =>
    _count = 0

  be increment() =>
    _count = _count + 1
