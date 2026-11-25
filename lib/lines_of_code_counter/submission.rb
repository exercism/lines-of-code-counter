class Submission
  include Mandate

  initialize_with :dir, :filepaths, :track

  attr_reader :dir

  # The paths to give to tokei, in the temporary directory.
  def tokei_filepaths
    filepaths.reject { |filepath| ignore_filepath?(filepath) }.map { |filepath| "#{dir}/#{tokei_filepath(filepath)}" }
  end

  # The path to write a submitted file to, so that tokei picks the right language for it.
  # Files with an extension listed in the track's `.extensions` file get an extra extension added.
  def tokei_filepath(filepath)
    new_extension = extensions[File.extname(filepath).delete_prefix(".")]
    new_extension ? "#{filepath}.#{new_extension}" : filepath
  end

  # The student's file name for a path that tokei reported.
  def original_filepath(path) = filepaths.find { |filepath| tokei_filepath(filepath) == path } || path

  private
  def ignore_filepath?(filepath) = ignore_rules.any? { |rule| File.fnmatch(rule, filepath) }

  memoize
  def ignore_rules
    return [] unless File.exist?(ignore_rules_filepath)

    File.readlines(ignore_rules_filepath, chomp: true)
  end

  def ignore_rules_filepath = "tracks/#{track}.ignore"

  # Maps an extension to the one that tokei should see instead, e.g. { "ex" => "e" }.
  memoize
  def extensions
    return {} unless File.exist?(extensions_filepath)

    File.readlines(extensions_filepath, chomp: true).
      reject { |line| line.strip.empty? || line.start_with?("#") }.
      to_h { |line| line.split("=", 2).map(&:strip) }
  end

  def extensions_filepath = "tracks/#{track}.extensions"
end
