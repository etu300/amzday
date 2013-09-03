class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  
  extend FriendlyId
  friendly_id :name, use: :slugged

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },

                   uniqueness: { case_sensitive: false }

    validates :password, length: { minimum: 6 }

    has_secure_password
      
      def feed
        # This is preliminary. See "Following users" for the full implementation.
        Post.where("user_id = ?", id)
      end

      def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	  end

      def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
      end  

      private

	  def create_remember_token
	    # Create the token.
      self.remember_token = User.encrypt(User.new_remember_token)
	  end      
end
