class CountLinesOfCode
  include Mandate

  initialize_with :submission

  def call
    {
      counts: {
        code: code,
        blanks: blanks,
        comments: comments
      },
      files: files
    }
  end

  private
  memoize
  def report
    puts `tokei --files #{submission.efs_filepaths.join(' ')} --output json`
    JSON.parse(`tokei --files #{submission.efs_filepaths.join(' ')} --output json`, symbolize_names: true)
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
      map { |child| child[:name].delete_prefix("#{submission.efs_dir}/") }.
      sort.
      to_a
  end
end
