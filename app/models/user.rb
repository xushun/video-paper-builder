class User < ActiveRecord::Base
  
  ###################################
  # AR Plugins/gems
  ###################################
  
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :invitable

  ###################################
  # Associations
  ###################################
  
  has_many :video_papers, :foreign_key => 'owner_id'
  has_many :video_papers, :through=> :shared_papers, :uniq=>true
  has_many :shared_papers
  has_many :wysihat_files
  
  ###################################
  # Validations
  ###################################
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_associated :shared_papers

  ##################################
  # instance methods
  ##################################
  
  #Public Methods
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name,:invitation_token  
  
  def name
    "#{self.first_name.titlecase} #{self.last_name.titlecase}"
  end
  
  def generate_reset_password_token!
    generate_reset_password_token && save(false)
    self.reset_password_token
  end
  
  
  ##################################
  # Class Methods
  ##################################
  class << self
    ##
    # This is a bit of an ugly hack.  The deal is this.  The devise invitable method
    # creates a new user account with just the email.  We need it to create with a first/last name
    # too.  So here you are.
    def send_invitation(attributes={})
      invitable = self.find_or_initialize_by_email(attributes[:email])

      if invitable.new_record?
        invitable.first_name = attributes[:first_name]
        invitable.last_name = attributes[:last_name]
        invitable.errors.add(:email, :blank) if invitable.email.blank?
        invitable.errors.add(:email, :invalid) unless invitable.email.match /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
      else
        invitable.errors.add(:email, :taken) unless invitable.invited?
      end

      invitable.resend_invitation! if invitable.errors.empty?
      invitable
    end
  end
end
