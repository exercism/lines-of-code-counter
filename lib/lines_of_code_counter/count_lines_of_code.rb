class CountLinesOfCode
  include Mandate

  initialize_with :submission

  def call
    {
      counts: {
        code:,
        blanks:,
        comments:
      },
      files:
    }
  end

  private
  memoize
  def report
    puts `tokei --files #{submission.efs_filepaths.join(' ')} --output json`
    JSON.parse(`tokei --files #{submission.efs_filepaths.join(' ')} --output json`, symbolize_names: true)
  end

  def code = report[:Total][:code]
  def blanks = report[:Total][:blanks]
  def comments = report[:Total][:comments]

  def files
    report[:Total][:children].values.
      flatten.
      map { |child| child[:name].delete_prefix("#{submission.efs_dir}/") }.
      sort.
      to_a
  end
end
