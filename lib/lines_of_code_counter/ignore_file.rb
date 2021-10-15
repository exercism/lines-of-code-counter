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
    File.exist?(track_ignore_filepath)
  end

  def track_specific_rules
    [
      *File.readlines(track_ignore_filepath),
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
      *exercise.solution_files.map {|s|"!#{s}"}
    ]    
  end

  def test_file_rules
    [
      "response.json",
      "expected_response.json"
    ]    
  end

  private
  def track_ignore_filepath
    "tracks/#{exercise.track}.ignore"
  end  
end
