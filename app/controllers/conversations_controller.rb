class ConversationsController < ApplicationController
  def index
    @partner = Partner.find(params[:partner_id])

    @user_partner = UserPartner.find_or_create_by!(
      user: current_user,
      partner: @partner
    ) do |up|
      up.affection = 0
      up.status = "知り合い"
    end

    @conversations = Conversation.where(
      user: current_user,
      partner: @partner
    ).order(:created_at)

    # イベント情報を受け取る
    @event = flash[:event]
  end

  def create
    @partner = Partner.find(params[:partner_id])

    # 関係
    @user_partner = UserPartner.find_or_create_by!(
      user: current_user,
      partner: @partner
    ) do |up|
      up.affection = 0
      up.status = "知り合い"
    end

    user_message = params[:message]

    # ユーザー発言を保存
    Conversation.create!(
      user: current_user,
      partner: @partner,
      message: user_message,
      speaker: "user"
    )

    # 感情分析
    AffectionService.update(
      @user_partner,
      user_message
    )

    # 会話履歴を取得
    conversations = Conversation.where(
      user: current_user,
      partner: @partner
    ).order(:created_at)

    # Geminiへ送信
    ai_message = GeminiService.chat(
      @partner,
      @user_partner,
      conversations
    )

    if ai_message.present?
      Conversation.create!(
        user: current_user,
        partner: @partner,
        message: ai_message,
        speaker: "partner"
      )
    else
      flash[:alert] = "AIとの通信に失敗しました。時間をおいて再度お試しください。"
    end

    # イベント判定
    event = EventService.check(
      current_user,
      @partner,
      @user_partner
    )

    # redirect後もイベント情報を保持
    flash[:event] = event if event.present?

    redirect_to conversations_path(partner_id: @partner.id)
  end

  def destroy_all
    partner = Partner.find(params[:partner_id])

    Conversation.where(
      user: current_user,
      partner: partner
    ).destroy_all

    redirect_to conversations_path(partner_id: partner.id),
                notice: "会話履歴を削除しました。"
  end
end