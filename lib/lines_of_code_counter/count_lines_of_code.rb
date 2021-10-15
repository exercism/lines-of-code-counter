class CountLinesOfCode
  include Mandate

  initialize_with :exercise

  def call
    {
      code: code,
      blanks: blanks,
      comments: comments,
      files: files
    }
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
      map {|child| child[:name].delete_prefix("#{exercise.dir}/") }.
      sort.
      to_a
  end
end
