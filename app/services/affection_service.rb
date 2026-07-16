class AffectionService
  SCORE_RULES = {
    "好き" => 3,
    "かわいい" => 3,
    "ありがとう" => 2,
    "嬉しい" => 2,
    "最高" => 2,

    "嫌い" => -5,
    "うざい" => -5,
    "きもい" => -5,
    "最低" => -3
  }.freeze

  MAX_AFFECTION = 100
  MIN_AFFECTION = -100

  def self.update(user_partner, message)
    score = calculate_score(message)

    return if score.zero?

    update_affection(user_partner, score)
    update_status(user_partner)
  end

  def self.update_affection(user_partner, score)
    new_affection = user_partner.affection + score

    # 好感度を -100 ～ 100 に制限
    new_affection = [[new_affection, MIN_AFFECTION].max, MAX_AFFECTION].min

    user_partner.update!(
      affection: new_affection
    )
  end

  private_class_method :update_affection

  def self.update_status(user_partner)
    status =
      case user_partner.affection
      when 0..9
        "知り合い"
      when 10..29
        "友達"
      when 30..59
        "仲良し"
      when 60..89
        "恋人候補"
      else
        if user_partner.affection < 0
          "知り合い"
        else
          "恋人"
        end
      end

    user_partner.update!(status: status)
  end

  private_class_method :update_status

  def self.calculate_score(message)
    SCORE_RULES.sum do |word, point|
      message.include?(word) ? point : 0
    end
  end

  private_class_method :calculate_score
end
