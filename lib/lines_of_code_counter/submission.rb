class Submission
  include Mandate

  initialize_with :dir, :filepaths, :track

  attr_reader :dir

  def tokei_filepaths
    filepaths.map do |filepath|
      next if ignore_filepath?(filepath)

      "#{dir}/#{filepath}"
    end.compact
  end

  private
  def ignore_filepath?(filepath) = ignore_rules.any? { |rule| File.fnmatch(rule, filepath) }

  memoize
  def ignore_rules
    return [] unless File.exist?(ignore_rules_filepath)

    File.readlines(ignore_rules_filepath, chomp: true)
  end

  def ignore_rules_filepath = "tracks/#{track}.ignore"
end
