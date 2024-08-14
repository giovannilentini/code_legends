class Challenge < ApplicationRecord
  belongs_to :player_1, class_name: 'Player'
  belongs_to :player_2, class_name: 'Player'
  
  has_one :room, dependent: :destroy 
  
  after_create :create_room
  
  private
  
  def create_room
    self.create_room!(uuid: SecureRandom.uuid)
  end
end
