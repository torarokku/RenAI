require "httparty"

class GeminiService
  include HTTParty

  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent"

  def self.chat(partner, conversations)
    api_key = ENV["GEMINI_API_KEY"]

    system_prompt = partner.personality

    # ConversationをGemini APIの形式に変換
    contents = conversations
      .where.not(message: nil)
      .map do |conversation|
        {
          role: conversation.speaker == "user" ? "user" : "model",
          parts: [
            {
              text: conversation.message
            }
          ]
        }
      end

    response = post(
      "#{BASE_URL}?key=#{api_key}",
      headers: {
        "Content-Type" => "application/json"
      },
      body: {
        systemInstruction: {
          parts: [
            {
              text: system_prompt
            }
          ]
        },
        contents: contents
      }.to_json
    )

    if response.success?
      response.parsed_response.dig(
        "candidates",
        0,
        "content",
        "parts",
        0,
        "text"
      )
    else
      Rails.logger.error(response.parsed_response)
      nil
    end
  end
end