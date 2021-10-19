class IgnoreFile
  include Mandate

  initialize_with :exercise

  def filepath
    File.join(exercise.dir, ".tokeignore")
  end

  def content
    rules = track_specific_rules? ? track_specific_rules : default_rules
    rules.compact.join("\n")
  end

  memoize
  def track_specific_rules?
    File.exist?(track_include_filepath)
  end

  def track_specific_rules
    [
      "*",
      *File.readlines(track_include_filepath).map { |rule| include_to_exclude(rule) },
      *exercise.test_files,
      *exercise.example_files,
      *exercise.exemplar_files,
      *exercise.editor_files,
      *test_file_rules
    ]
  end

  def default_rules
    [
      "*",
      *exercise.solution_files.map { |rule| include_to_exclude(rule) }
    ]
  end

  def test_file_rules
    [
      "response.json",
      "expected_response.json"
    ]
  end

  private
  def track_include_filepath
    "tracks/#{exercise.track}.include"
  end

  def include_to_exclude(rule)
    rule.strip!

    return rule if rule.empty? || rule.start_with?('#')

    rule.start_with?('!') ? rule.delete_prefix('!') : "!#{rule}"
  end
end
