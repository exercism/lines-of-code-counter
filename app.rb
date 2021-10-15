require "mandate"
require "json"
require "fileutils"

module Exercism
  # TODO: refactor (extract classes, rename to handler)
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
        files: report[:Total][:children].values.
          flatten.
          map do |c|
                 c[:name].
                   delete_prefix("#{solution_dir}/")
               end.
          sort.
          to_a
      }
      File.write(output_counts_file, output.to_json)
      FileUtils.rm(output_ignore_file)
    end

    def self.process(event:, context:)
      Exercism::CountLinesOfCode.(event, context)
    end

    private
    def track
      event["track"]
    end

    def solution_dir
      event["solution"]
    end

    def output_dir
      event["output"]
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
      if File.exist?(track_file)
        [
          *File.readlines(track_file),
          *exercise_config[:files][:test].to_a,
          *exercise_config[:files][:example].to_a,
          *exercise_config[:files][:exemplar].to_a,
          *exercise_config[:files][:editor].to_a,
          "counts.json",
          "expected_counts.json"
        ].compact.join("\n")
      else
        [
          "*",
          *exercise_config[:files][:solution].to_a.map {|s|"!#{s}"},
          "counts.json",
          "expected_counts.json"
        ].compact.join("\n")
      end
    end

    def output_ignore_file
      File.join(solution_dir, ".tokeignore")
    end
  end
end
