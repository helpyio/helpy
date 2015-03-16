class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Gravtastic


  # Relationships
  has_and_belongs_to_many :roles
  has_many :topics
  has_many :posts
  has_many :votes

  is_gravtastic

end
