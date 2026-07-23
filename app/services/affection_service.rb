class AffectionService
  SCORE_RULES = {
    #超高感度アップ
    "愛してる" => 60,
    "結婚" => 50,
    "付き合って" => 50,
    "一生一緒" => 50,
    "運命" => 40,
    "大好き" => 45,
    "大切" => 40,
    "君だけ" => 40,
    "幸せ" => 40,
    # 好感度アップ
    "好き" => 30,
    "かわいい" => 30,
    "かっこいい" => 30,
    "美人" => 25,
    "素敵" => 25,
    "優しい" => 25,
    "尊敬" => 25,
    "ありがとう" => 20,
    "嬉しい" => 20,
    "最高" => 20,
    "すごい" => 20,
    "頑張って" => 20,
    "応援" => 20,
    "会いたい" => 30,
    "会えて" => 20,
    "楽しい" => 25,
    "面白い" => 20,
    "癒される" => 30,
    "安心" => 25,
    "笑顔" => 20,
    # 少しうれしい
    "おはよう" => 5,
    "こんにちは" => 5,
    "こんばんは" => 5,
    "お疲れ" => 10,
    "お疲れ様" => 10,
    "よろしく" => 10,
    "よろしくね" => 10,
    "またね" => 10,
    "久しぶり" => 10,
    "元気" => 10,
    "笑" => 5,
    "楽しかった" => 15,
    "すき" => 30,
    "可愛い" => 30,
    "綺麗" => 20,
    "天才" => 20,
    "頼りになる" => 20,
    "一緒" => 15,
    "デート" => 25,
    "遊ぼう" => 20,
    "映画" => 10,
    "旅行" => 15,
    "プレゼント" => 20,
    # 恥ずかしい・照れる
    "照れる" => 15,
    "ドキドキ" => 20,
    "胸キュン" => 25,
    "ハート" => 15,
    "ぎゅ" => 25,
    "ハグ" => 25,
    "キス" => 30,
    # マイナス
    "最低" => -30,
    "つまらない" => -20,
    "面倒" => -15,
    "疲れる" => -15,
    "うるさい" => -20,
    "しつこい" => -20,
    "無理" => -20,
    "帰る" => -10,
    "邪魔" => -30,
    "嘘" => -15,
    "嫌だ" => -20,
    "残念" => -10,
    "がっかり" => -20,
    # 大きく下がる
    "嫌い" => -50,
    "大嫌い" => -80,
    "うざい" => -50,
    "きもい" => -70,
    "ブス" => -70,
    "最悪" => -40,
    "浮気" => -60,
    "裏切り" => -60,
    "別れる" => -80,
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
