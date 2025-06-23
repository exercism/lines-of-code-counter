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

  def efs_dir = "#{efs_tooling_jobs_dir}/#{job_dir}"
  def efs_tooling_jobs_dir = ENV.fetch("EFS_DIR", "/mnt/tooling_jobs")

  private
  def ignore_filepath?(filepath) = ignore_rules.any? { |rule| File.fnmatch(rule, filepath) }

  memoize
  def ignore_rules
    return [] unless File.exist?(ignore_rules_filepath)

    File.readlines(ignore_rules_filepath, chomp: true)
  end

  def ignore_rules_filepath = "tracks/#{track}.ignore"
end
