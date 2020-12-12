class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy ]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  # def edit; end

  def edit
    @working_team = @team
    if @team.owner_id == current_user.id
      render "edit"
    else
      redirect_to @team, notice: 'あなたは編集権限がありません'
    end
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    # if current_user.id == @team.owner_id
      if @team.update(team_params)
        redirect_to @team, notice: I18n.t('views.messages.update_team')
      else
        flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
        render :edit
      end
    # else
    #   # flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
    #   # render :edit
    #   redirect_to @team, notice: 'あなたには編集'
    # end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def owner_change
    @assign = Assign.find(params[:assign_user_id])
    @team = Team.find(params[:id])
    @team.update(owner_id: @assign.user.id)

    TeamMailer.team_mail(@team).deliver
    redirect_to team_url, notice: 'リーダー権限を移動しました！'
  end


  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

end
