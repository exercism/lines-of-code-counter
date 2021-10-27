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
    puts body[:submission_uuid]
    puts body[:submission_filepaths]
    puts body[:track_slug]
    puts content
    Submission.new(body[:submission_uuid], body[:submission_filepaths], body[:track_slug])
  end

  memoize
  def body
    JSON.parse(event["body"], symbolize_names: true)
  end
end
