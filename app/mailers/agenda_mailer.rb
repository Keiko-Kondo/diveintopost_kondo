class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda)
    @agenda = agenda
    @agenda.team.users.each do |user|
      mail to: user.email, subject: "アジェンダ削除通知"
    end
  end
end
