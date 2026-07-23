class EventService
  EVENT_RULES = {
    "walk_home" => 30,
    "confession" => 90,
    "clear" => 100
  }.freeze

  def self.check(user, partner, user_partner)
    # クリアを最優先で判定
    if user_partner.affection >= 100
      already = UserEvent.exists?(
        user: user,
        partner: partner,
        event_key: "clear"
      )

      unless already
        UserEvent.create!(
          user: user,
          partner: partner,
          event_key: "clear"
        )

        puts "★★★★★ バッジ保存 ★★★★★"

        UserBadge.find_or_create_by!(
          user: user,
          partner: partner
        )

        return "clear"
      end
    end

    EVENT_RULES.each do |event_key, affection|

      next unless user_partner.affection >= affection

      already = UserEvent.exists?(
        user: user,
        partner: partner,
        event_key: event_key
      )

      next if already

      UserEvent.create!(
        user: user,
        partner: partner,
        event_key: event_key
      )


      return event_key
    end

    nil
  end
end