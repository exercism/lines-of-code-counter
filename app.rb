require "mandate"
require "json"

module Exercism
  class CountLinesOfCode
    include Mandate

    initialize_with :event, :content

    def call
      system("tokei #{solution_dir}")
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

    def ignore_file
      File.read("tracks/#{track}.tokeignore")
    end

    memoize
    def body
      JSON.parse(event['body'], symbolize_names: true)
    end
  end
end    