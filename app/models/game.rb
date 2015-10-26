class Game < ActiveRecord::Base
  validates :title, presence: true
  validates :image_url, presence: true

  before_validation :set_image, on: :create

  has_many :comments
  has_many :votes, :as => :votable
  has_many :game_features
  has_many :mechanics, through: :game_features
  has_many :owned_games
  has_many :owners, through: :owned_games
  has_many :desired_games, foreign_key: "wanted_game_id"
  has_many :wanters, through: :desired_games

  def self.search(query)
    if query == ""
      Game.all
    else
      exact = Game.where('lower(title) = ?', query.downcase)
      fuzzy = Game.where('lower(title) LIKE ?', "%#{query.downcase}%")
      (exact + fuzzy).uniq
    end
  end

  def self.advanced_search(players, time, feature)
    results = []
    unless players == ""
      results = Game.where('min_players <= ? AND max_players >= ?', players, players)
    end
    unless time == ""
      results = results.where('average_time >= ? AND average_time <= ?', time.to_i - 15, time.to_i + 15)
    end
    unless feature == ""
      results = results.select { |game| game.mechanics.map { |mechanic| mechanic.trait }.include?(feature)}
    end
    results
  end

  def vote_count
    self.votes.inject(0) { |total, vote| total += vote.value }
  end

  private

  def set_image
    if self.image_url == ""
      self.image_url = "/images/sorry.jpg"
    end
    self.image_url ||= "/images/sorry.jpg"
  end
end
