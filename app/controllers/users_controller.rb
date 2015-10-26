class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def index
    @user = User.search(params[:search])
    if @user
      redirect_to user_path(@user)
    else
      @error = "User not found"
      redirect_to user_path(current_user)
    end
  end


  def show
    partial = params[:query]
    @user = User.find(params[:id])

    if current_user == nil
      redirect_to new_user_session_path
    else
      case partial
      when 'games'
        render :'users/_user_games'
      when 'wanted games'
        render :'users/_user_wanted_games'
      when 'comments'
        render :'users/_comments'
      when 'buddies'
        render :'users/_buddies'
      else
        render :'users/show'
      end
    end
  end

  def buddies
    @user = User.find(params[:id])
    @buddy = User.find(params[:buddy])

    if @user.id == @buddy.id
      @error = "You're not able to add yourself as a buddy"
    elsif Relationship.find_by(user_id: @user.id, buddy_id: @buddy.id)
      @error = "This user is already your buddy"
    else
      Relationship.create!(user_id: @user.id, buddy_id: @buddy.id)
      redirect_to user_path(@user)
    end
  end

  def owned_games
    @user = User.find(params[:id])
    @game = Game.find(params[:game])

    if OwnedGame.find_by(owner_id: @user.id, game_id: @game.id)
      @error = "You already own this game"
      render :"games/index"
    else
      OwnedGame.create!(owner_id: @user.id, game_id: @game.id)
      redirect_to :back
    end
  end

  def wanted_games
    @user = User.find(params[:id])
    @game = Game.find(params[:wanted_game])

    if DesiredGame.find_by(wanter_id: @user.id, wanted_game_id: @game.id)
      @error = "You already have this game in your wishlist"
      render :"games/index"
    else
      DesiredGame.create!(wanter_id: @user.id, wanted_game_id: @game.id)
      redirect_to :back
    end
  end

  def change_status
    relationship = Relationship.find_by(user_id: params[:id], buddy_id: params[:buddy_id])
    relationship.status = 1
    p relationship
    @user = User.find(params[:buddy_id])
    redirect_to user_path(@user)
  end

end

