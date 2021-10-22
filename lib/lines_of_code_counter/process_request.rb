class ProcessRequest
  include Mandate

  initialize_with :event, :content

  def call
    counts = CountLinesOfCode.(submission)
    counts_json = counts.to_json

    {
      statusCode: 200,
      headers: {
        'Content-Length': counts_json.bytesize,
        'Content-Type': 'application/json; charset=utf-8'
      },
      isBase64Encoded: false,
      body: counts_json
    }
  end

  def submission
    Submission.new(event["submission_uuid"], event["submission_files"], event["track_slug"])
  end
end
