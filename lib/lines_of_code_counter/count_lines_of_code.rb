class CountLinesOfCode
  include Mandate

  initialize_with :exercise

  def call
    File.write(ignore_file.filepath, ignore_file.content)
    {
      code: code,
      blanks: blanks,
      comments: comments,
      files: files
    }
  ensure
    FileUtils.rm(ignore_file.filepath)
  end

  private
  memoize
  def report
    JSON.parse(`tokei #{exercise.dir} --output json`, symbolize_names: true)
  end

  def code
    report[:Total][:code]
  end

  def blanks
    report[:Total][:blanks]
  end

  def comments
    report[:Total][:comments]
  end

  def files
    report[:Total][:children].values.
      flatten.
      map { |child| child[:name].delete_prefix("#{exercise.dir}/") }.
      sort.
      to_a
  end

  memoize
  def ignore_file
    IgnoreFile.new(exercise)
  end
end
