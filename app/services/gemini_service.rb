require "httparty"

class GeminiService
  include HTTParty

  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent"

  def self.chat(partner, user_partner, conversations)
    api_key = ENV["GEMINI_API_KEY"]

    system_prompt = <<~PROMPT
    #{partner.personality}

    ## 現在の状態
    好感度: #{user_partner.affection}
    関係性: #{user_partner.status}

    ## 会話ルール
    ・好感度が低いうちは距離感を保って話してください。
    ・好感度が高くなるほど親しみを込めた話し方にしてください。
    ・関係性に応じた自然な態度で会話してください。
    PROMPT

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