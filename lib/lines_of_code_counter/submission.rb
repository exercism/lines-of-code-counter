class Submission
  include Mandate

  initialize_with :uuid, :filepaths, :track

  def efs_filepaths
    filepaths.map {|filepath| efs_path(filepath)}
  end

  private
  def efs_path(filename)
    "/mnt/submissions/#{uuid}/filename"
  end
end
