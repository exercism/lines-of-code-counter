class Submission
  include Mandate

  initialize_with :uuid, :filepaths, :track

  def efs_filepaths
    filepaths.map do |filepath|
      next if ignore_filepath?(filepath)

      "#{efs_dir}/#{filepath}"
    end.compact
  end

  def efs_dir = "#{efs_submissions_dir}/#{uuid}"

  # TODO: get this from the config gem
  def efs_submissions_dir = ENV.fetch("EFS_DIR", "/mnt/submissions")

  private
  def ignore_filepath?(filepath) = ignore_rules.any? { |rule| File.fnmatch(rule, filepath) }

  memoize
  def ignore_rules
    return [] unless File.exist?(ignore_rules_filepath)

    File.readlines(ignore_rules_filepath, chomp: true)
  end

  def ignore_rules_filepath = "tracks/#{track}.ignore"
end
