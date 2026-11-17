class ProcessRequest
  class InvalidRequest < StandardError; end

  include Mandate

  initialize_with :event, :content

  def call
    write_output_to_file if output_filepath
    response
  end

  private
  memoize
  def response
    {
      statusCode: 200,
      statusDescription: "200 OK",
      headers: { 'Content-Type': 'application/json' },
      isBase64Encoded: false,
      body: counts.to_json
    }
  rescue InvalidRequest => e
    {
      statusCode: 400,
      statusDescription: "400 Bad Request",
      headers: { 'Content-Type': 'application/json' },
      isBase64Encoded: false,
      body: { error: e.message }.to_json
    }
  end

  def counts
    # Requests with a "files" key send the file contents in the body.
    # Requests without it are the legacy format, where the files are on EFS.
    return count_files_in_body if body.key?(:files)

    CountLinesOfCode.(Submission.new(legacy_dir, body[:submission_filepaths], body[:track_slug]))
  end

  def count_files_in_body
    files = body[:files]
    raise InvalidRequest, "files must be an object of paths to string contents" unless files.is_a?(Hash) && files.values.all?(String)

    Dir.mktmpdir("lines-of-code-counter") do |dir|
      filepaths = files.keys.map(&:to_s)
      filepaths.each { |filepath| validate_filepath!(filepath) }

      files.each do |filepath, file_content|
        path = File.join(dir, filepath.to_s)
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, file_content)
      end

      CountLinesOfCode.(Submission.new(dir, filepaths, body[:track_slug]))
    end
  end

  def validate_filepath!(filepath)
    return unless filepath.empty? || filepath.include?("\0") || filepath.start_with?("/") || filepath.split("/").include?("..")

    raise InvalidRequest, "invalid file path: #{filepath.inspect}"
  end

  def legacy_dir = "#{ENV.fetch('EFS_DIR', '/mnt/tooling_jobs')}/#{body[:job_dir]}"
  def write_output_to_file = File.write(output_filepath, response.to_json)

  def output_filepath
    return if body[:output_dir].nil?

    "#{body[:output_dir]}/response.json"
  end

  memoize
  def body = JSON.parse(event["body"], symbolize_names: true)
end
