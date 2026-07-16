class EventService
  EVENT_RULES = {
    "walk_home" => 30,
    "confession" => 90
  }.freeze

  def self.check(user, partner, user_partner)
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