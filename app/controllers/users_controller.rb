class UsersController < ApplicationController
  # these routes should only be seen by logged in users
  def show
    @user = User.find(params[:id])

    if current_user == nil
      redirect_to new_user_session_path
    elsif current_user.id == @user.id
      render :'users/show'
    elsif @user.relationships.find_by(buddy_id: current_user.id)
      render :'users/show'
    else
      redirect_to root_path
    end
  end

  def buddies
    @user = User.find(params[:id])
    @buddy = User.find(params[:buddies])

    if @user.id == @buddy.id
      @error = "You're not able to add yourself as a buddy"
    elsif Relationship.find_by(user_id: @user.id, buddy_id: @buddy.id)
      @error = "This user is already your buddy"
    else
      Relationship.create!(user_id: @user.id, buddy_id: @buddy.id)
    end
  end

  def owned_games
    @user = User.find(params[:id])
    @game = Game.find(params[:game])

    if OwnedGame.find_by(user_id: @user.id, game_id: @game.id)
      @error = "You already own this game"
    else
      OwnedGame.create!(user_id: @user.id, game_id: @game.id)
    end
  end

  def wanted_games
    @user = User.find(params[:id])
    @game = Game.find(params[:wanted_game])

    if DesiredGame.find_by(user_id: @user.id, game_id: @game.id)
      @error = "You already have this game in your wishlist"
    else
      DesiredGame.create!(user_id: @user.id, game_id: @game.id)
    end
  end

end

