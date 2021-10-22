#!/usr/bin/env ruby

require("./lib/lines_of_code_counter")

event = JSON.parse(ARGV[0])
response = LinesOfCodeCounter.process(event: event, context: {})
puts response.to_json
