actor Main
  var _env: Env

  new create(env: Env) =>
    _env = env

    var count: U32 = try env.args(1)?.u32()? else 10 end
    var counter = Counter

    for i in Range[U32](0, count) do
      counter.increment()
    end

    counter.get_and_reset(this)

  be display(result: U32) =>
    _env.out.print(result.string())