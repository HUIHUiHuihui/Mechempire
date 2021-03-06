class WeaponsController < ApplicationController
  before_action :set_weapon, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :destroy, :edit, :create, :edit, :update]
  before_action :locked_user 

  def index
    @weapons = Weapon.all
  end

  def show
  end

  def edit
  end

  def create
    @weapon = Weapon.new(weapon_params)

    respond_to do |format|
      if @weapon.save
        format.html { redirect_to @weapon, notice: 'Weapon was successfully created.' }
        format.json { render :show, status: :created, location: @weapon }
      else
        format.html { render :new }
        format.json { render json: @weapon.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @weapon.update(weapon_params)
        format.html { redirect_to @weapon, notice: '更新成功' }
        format.json { render :show, status: :ok, location: @weapon }
      else
        format.html { render :edit }
        format.json { render json: @weapon.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @weapon.destroy
    respond_to do |format|
      format.html { redirect_to weapons_url, notice: '删除成功!' }
      format.json { head :no_content }
    end
  end

  def new
    @weapon = Weapon.new
  end

  private

    def set_weapon
      @weapon = Weapon.find(params[:id])
      if @weapon.nil?
        render :file => 'public/404.html'
      end
    end

    def weapon_params
      params.require(:weapon).permit(:name,
                                   :introduce,
                                   :samplepic,
                                   :iden)
    end
end
