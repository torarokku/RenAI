require "httparty"

class GeminiService
  include HTTParty

  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent"

  def self.chat(message)
    api_key = ENV["GEMINI_API_KEY"]

    response = post(
      "#{BASE_URL}?key=#{api_key}",
      headers: {
        "Content-Type" => "application/json"
      },
      body: {
        contents: [
          {
            parts: [
              {
                text: message
              }
            ]
          }
        ]
      }.to_json
    )

    response.parsed_response.dig(
  "candidates",
  0,
  "content",
  "parts",
  0,
  "text"
)
  end
end