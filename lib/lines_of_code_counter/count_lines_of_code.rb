require "open3"

class CountLinesOfCode
  include Mandate

  EMPTY_REPORT = { Total: { code: 0, blanks: 0, comments: 0, children: {} } }.freeze

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
    # With no paths, tokei would scan the working directory.
    return EMPTY_REPORT if submission.tokei_filepaths.empty?

    output, = Open3.capture2("tokei", "--files", *submission.tokei_filepaths, "--output", "json")
    JSON.parse(output, symbolize_names: true)
  end

  def code = report[:Total][:code]
  def blanks = report[:Total][:blanks]
  def comments = report[:Total][:comments]

  def files
    report[:Total][:children].values.
      flatten.
      map { |child| submission.original_filepath(child[:name].delete_prefix("#{submission.dir}/")) }.
      sort.
      to_a
  end
end
