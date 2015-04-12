class BattlesController < ApplicationController
  before_action :set_battle, only: [:show, :download, :star, :destroy]
  before_action :actived_user, only: [:create, :destroy]
  before_action :admin_user, except: [:create, :download, :index, :show]
  before_action :signed_in_user, only: [:star, :create, :destroy]

  def index
    @battles = Battle.page(params[:page]).per(5)
  end

  def new
  end

  def create
    defender = Mech.find(params['defender_id'])
    attacker = Mech.find(params['attacker_id'])
    store_location

    if defender.state == "SUCCESS" && attacker.state == "SUCCESS"
      @battle = Battle.new(:defender_id => defender._id,
                           :attacker_id => attacker._id,
                           :time => Time.now)
    end
    
    respond_to do |format|
      if @battle && !defender.nil? && !attacker.nil? && @battle.battle && @battle.save
        defender.battles << @battle
        attacker.battles << @battle

        defender.user.battles << @battle
        attacker.user.battles << @battle

        
        format.html { redirect_to @battle, notice: '战斗成功，观看战斗结果！' }
        format.json { render :show, status: :created, location: @battle }
      else
        flash[:danger] = "战斗失败"
        format.html { redirect_back_or(root_path)}
        format.json { render json: @battle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  def edit
  end

  def update
  end

  def show
  end

  def star
    respond_to do |format|
      if !@battle.starers.include?(current_user)
        @battle.starers << current_user
        format.js
      else
        format.js do 
          render js:"alert('点赞失败')"
        end
      end
    end
  end

  def download
    send_file "battle/result/#{@battle._id}.txt", :type => 'application/txt'
  end

  private

    def set_battle
       @battle = Battle.find(params[:id])
    end
    # def battle_params
    #   params.require(:battle).permit(:attacker_id,
    #                                  :defender_id)
    # end
end
