class TeamMailer < ApplicationMailer
  def team_mail(team)
    @team = team
    @user = User.find(@team.owner_id)
    mail to: @user.email, subject: "チームリーダー権限が付与されました"
  end
end
