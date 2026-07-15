class ConversationsController < ApplicationController
  def index
    @partner = Partner.find(params[:partner_id])

    @conversations = Conversation.where(
      user: current_user,
      partner: @partner
    ).order(:created_at)
  end

  def create
    @partner = Partner.find(params[:partner_id])

    user_message = params[:message]

    # ユーザー発言を保存
    Conversation.create!(
      user: current_user,
      partner: @partner,
      message: user_message,
      speaker: "user"
    )

    # 会話履歴を取得
    conversations = Conversation.where(
      user: current_user,
      partner: @partner
    ).order(:created_at)

    # Geminiへ送信
    ai_message = GeminiService.chat(
      @partner,
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
