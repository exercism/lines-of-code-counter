require "mandate"
require "json"
require "fileutils"

module Exercism
  class CountLinesOfCode
    include Mandate

    initialize_with :event, :content

    def call
      FileUtils.cp(track_ignore_file, output_ignore_file) if File.exist?(track_ignore_file)
      output = JSON.parse(`tokei #{solution_dir} --output json`, symbolize_names: true)
      puts output[:Total][:code]
      FileUtils.rm(output_ignore_file) if track_ignore_file if File.exist?(output_ignore_file)
    end

    def self.process(event:,context:)
      Exercism::CountLinesOfCode.(event, context)
    end

    private
    def track
      body[:track]
    end

    def solution_dir
      body[:solution]
    end

    def output_dir
      body[:output]
    end

    def output_counts_file
      File.join(output_dir, "counts.json")
    end

    def track_ignore_file
      "tracks/#{track}.tokeignore"
    end

    def output_ignore_file 
      File.join(solution_dir, ".tokeignore")      
    end

    memoize
    def body
      JSON.parse(event['body'], symbolize_names: true)
    end
  end
end    