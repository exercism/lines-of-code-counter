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
    puts event
    puts event["submission_uuid"]
    puts event["submission_filepaths"]
    puts event["track_slug"])
    Submission.new(event["submission_uuid"], event["submission_filepaths"], event["track_slug"])
  end
end
