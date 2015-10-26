class GamesController < ApplicationController
  include ApplicationHelper

  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :upvote]
  before_filter :check_admin_status, :only => [:edit, :update, :destroy]

  def index
    @games = Game.order("title")
  end

  def most_popular
    @games = Game.all.sort_by { |game| game.vote_count }.reverse
    render :index
  end

  def most_owned
    @games = Game.all.sort_by { |game| game.owners.count }.reverse
    render :index
  end

  def most_wanted
    @games = Game.all.sort_by { |game| game.wanters.count }.reverse
    render :index
  end

  def show
    @comments = @game.comments.order("created_at DESC")
    @comment = Comment.new
  end

  def new
    @game = Game.new
    @mechanics = Mechanic.all
  end

  def create
    @mechanics = Mechanic.all
    mechanic_traits = params[:game].delete(:mechanics)
    @game = Game.new(game_params)
    if @game.save
      mechanic_traits.each do |mechanic_trait|
        unless mechanic_trait == ""
          mechanic = Mechanic.find_by(trait: mechanic_trait)
          GameFeature.create(game_id: @game.id, mechanic_id: mechanic.id)
        end
      end
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def edit
    @mechanics = Mechanic.all
  end

  def update
    @mechanics = Mechanic.all
    mechanic_traits = params[:game].delete(:mechanics)
    if @game.update(game_params)
      @mechanics.each do |mechanic|
        if mechanic_traits.include?(mechanic.trait)
          GameFeature.find_or_create_by(game_id: @game.id, mechanic_id: mechanic.id)
        else
          game_feature = GameFeature.find_by(game_id: @game.id, mechanic_id: mechanic.id)
          game_feature.destroy if game_feature
        end
      end
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path
  end

  def upvote
    @game = Game.find(params[:id])
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Game", votable_id: @game.id)
    new_value = @vote.value + 1
    @vote.assign_attributes(value: new_value)
    @vote.save
    redirect_to game_path(@game)
  end

  def downvote
    @game = Game.find(params[:id])
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Game", votable_id: @game.id)
    new_value = @vote.value - 1
    @vote.assign_attributes(value: new_value)
    @vote.save
    redirect_to game_path(@game)
  end

  def search
    @games = Game.search(params[:search])
    render :search_results
  end

  def advanced_search_form
    @mechanics = Mechanic.all
  end

  def advanced_search
    @games = Game.advanced_search(params[:players], params[:game_time], params[:mechanics])
    render :search_results
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:title, :description, :min_players, :max_players, :average_time, :image_url, :mechanics)
  end


end
