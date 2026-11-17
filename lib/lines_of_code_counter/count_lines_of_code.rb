require "open3"

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
    output, = Open3.capture2("tokei", "--files", *submission.tokei_filepaths, "--output", "json")
    JSON.parse(output, symbolize_names: true)
  end

  def code = report[:Total][:code]
  def blanks = report[:Total][:blanks]
  def comments = report[:Total][:comments]

  def files
    report[:Total][:children].values.
      flatten.
      map { |child| child[:name].delete_prefix("#{submission.dir}/") }.
      sort.
      to_a
  end
end
