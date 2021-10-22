class ProcessRequest
  include Mandate

  initialize_with :event, :content

  def call
    counts = CountLinesOfCode.(submission)
    {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      isBase64Encoded: false,
      body: counts
    }
  end

  def submission
    Submission.new(event["submission_uuid"], event["submission_filepaths"], event["track_slug"])
  end
end
