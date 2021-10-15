#!/usr/bin/env ruby

require("./lib/app")

event = {
  "track" => ARGV[0],
  "exercise" => ARGV[1],
  "solution" => ARGV[2],
  "output" => ARGV[3]
}
Exercism::CountLinesOfCode.process(event: event, context: {})
