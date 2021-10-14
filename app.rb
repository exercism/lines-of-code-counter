require "mandate"
require "json"
require "fileutils"

module Exercism
  class CountLinesOfCode
    include Mandate

    initialize_with :event, :content

    def call
      File.write(output_ignore_file, output_ignore)       
      report = JSON.parse(`tokei #{solution_dir} --output json`, symbolize_names: true)
      output = {
        code: report[:Total][:code],
        blanks: report[:Total][:blanks],
        comments: report[:Total][:comments],
        files: report[:Total][:children].each_value.map(&:size).sum
      }
      File.write(output_counts_file, output.to_json) 
      FileUtils.rm(output_ignore_file)
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

    def track_file
      "tracks/#{track}.ignore"
    end
    
    def exercise_config_file
      File.join(solution_dir, ".meta", "config.json")
    end

    memoize
    def exercise_config
      JSON.parse(File.read(exercise_config_file), symbolize_names: true)
    end

    def output_ignore

      i = File.read(track_file)

      [
        *exercise_config[:files][:test].to_a,
        *exercise_config[:files][:example].to_a,
        *exercise_config[:files][:exemplar].to_a,
        *exercise_config[:files][:editor].to_a
      ].compact.each do |j|
        i += "#{j}\n"
      end

      i
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