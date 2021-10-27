class ProcessRequest
  include Mandate

  initialize_with :event, :content

  def call
    counts = CountLinesOfCode.(submission)

    {
      statusCode: 200,
      statusDescription: "200 OK",
      isBase64Encoded: false,
      headers: {
        'Content-Type': 'application/json'
      },
      body: counts.to_json
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
