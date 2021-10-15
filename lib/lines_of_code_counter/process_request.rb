class ProcessRequest
  include Mandate

  initialize_with :event, :content

  def call
    File.write(ignore_file.filepath, ignore_file.content)
    counts = CountLinesOfCode.(exercise)
    File.write(counts_filepath, counts.to_json)
    # FileUtils.rm(ignore_file.filepath)
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

  def counts_filepath
    File.join(output_dir, "counts.json")
  end

  memoize
  def exercise
    Exercise.new(solution_dir)
  end

  memoize
  def ignore_file
    IgnoreFile.new(track, exercise)
  end
end
