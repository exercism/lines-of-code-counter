class Exercise
  include Mandate

  attr_reader :track, :dir

  def initialize(track, dir)
    @track = track
    @dir = dir
  end

  def solution_files
    config[:files][:solution].to_a
  end

  def test_files
    config[:files][:test].to_a
  end

  def editor_files
    config[:files][:editor].to_a
  end

  def exemplar_files
    config[:files][:exemplar].to_a
  end

  def example_files
    config[:files][:example].to_a
  end
  
  private
  memoize
  def config
    filepath = File.join(dir, ".meta", "config.json")
    JSON.parse(File.read(filepath), symbolize_names: true)
  end
end
