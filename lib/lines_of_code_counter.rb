require "json"
require "mandate"
require "fileutils"
require "./lib/lines_of_code_counter/count_lines_of_code"
require "./lib/lines_of_code_counter/ignore_file"
require "./lib/lines_of_code_counter/process_request"
require "./lib/lines_of_code_counter/submission"

module LinesOfCodeCounter
  def self.process(event:, context:)
    ProcessRequest.(event, context)
  end
end
