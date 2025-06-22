class Submission
  include Mandate

  initialize_with :job_dir, :filepaths, :track

  attr_reader :job_dir

  def efs_filepaths
    filepaths.map do |filepath|
      next if ignore_filepath?(filepath)

      "#{efs_dir}/#{filepath}"
    end.compact
  end

  memoize
  def efs_dir = "/mnt/tooling_jobs/#{job_dir}"

  private
  def ignore_filepath?(filepath)
    ignore_rules.any? { |rule| File.fnmatch(rule, filepath) }
  end

  memoize
  def ignore_rules
    return [] unless File.exist?(ignore_rules_filepath)

    File.readlines(ignore_rules_filepath, chomp: true)
  end

  def ignore_rules_filepath
    "tracks/#{track}.ignore"
  end
end
