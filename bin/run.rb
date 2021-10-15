#!/usr/bin/env ruby

require("./lib/lines_of_code_counter")

event = {
  "track" => ARGV[0],
  "exercise" => ARGV[1],
  "solution" => ARGV[2],
  "output" => ARGV[3]
}
LinesOfCodeCounter.process(event: event, context: {})
