class User < ActiveRecord::Base

#### used to be in acts_as_authentable
## used in app/views/users/new.html.erb
## TODO move to ArchiveConfig
  LOGIN_LENGTH_MIN = 3
  LOGIN_LENGTH_MAX = 40

  validates_length_of :login, :within => LOGIN_LENGTH_MIN..LOGIN_LENGTH_MAX,
    :too_short => "is too short (minimum is #{LOGIN_LENGTH_MIN} characters)",
    :too_long => "is too long (maximum is #{LOGIN_LENGTH_MAX} characters)"

  PASSWORD_LENGTH_MIN = 6
  PASSWORD_LENGTH_MAX = 40

  # allow nil so can save existing users
  validates_length_of :password, :within => PASSWORD_LENGTH_MIN..PASSWORD_LENGTH_MAX, :allow_nil => true,
    :too_short => "is too short (minimum is #{PASSWORD_LENGTH_MIN} characters)",
    :too_long => "is too long (maximum is #{PASSWORD_LENGTH_MAX} characters)"

####


  # Allows other models to get the current user with User.current_user
  cattr_accessor :current_user

  # NO NO NO! BAD IDEA! AWOOOOGAH! attr_accessible should ONLY ever be used on NON-SECURE fields
  # attr_accessible :suspended, :banned, :translation_admin, :tag_wrangler, :archivist, :recently_reset

  # Authlogic gem
  acts_as_authentic do |config|
    config.transition_from_restful_authentication = true
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha1
    config.validates_length_of_password_field_options = {:on => :update, :minimum => 6, :if => :has_no_credentials?}
    config.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 6, :if => :has_no_credentials?}
  end

  def has_no_credentials?
    self.crypted_password.blank?
  end

  def is_translation_admin?
    translation_admin
  end

  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable

  # OpenID plugin
  attr_accessible :identity_url

  has_many :pseuds, :dependent => :destroy
  validates_associated :pseuds

  before_create :create_default_associateds

  has_many :comments, :through => :pseuds

  scope :alphabetical, :order => :login
  scope :starting_with, lambda {|letter| {:conditions => ['SUBSTR(login,1,1) = ?', letter]}}
  scope :valid, :conditions => {:banned => false, :suspended => false}

  validates_format_of :login,
    :with => /\A[A-Za-z0-9]\w*[A-Za-z0-9]\Z/
  #validates_uniqueness_of :login, :message => ('login_already_used', :default => 'must be unique')

  def to_param
    login
  end


  def self.for_claims(claims_ids)    
    joins(:request_claims).
    where("challenge_claims.id IN (?)", claims_ids)
  end

  ### AUTHENTICATION AND PASSWORDS
  def active?
    true
  end

  def suspended?
    false
  end

  def banned?
    false
  end

  def generate_password(length=8)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
    password = ''
    length.downto(1) { |i| password << chars[rand(chars.length - 1)] }
    password
  end

  # use update_all to force the update even if the user is invalid
  def reset_user_password
    temp_password = generate_password(20)
    User.update_all("activation_code = '#{temp_password}', recently_reset = 1, updated_at = '#{Time.now}'", "id = #{self.id}")
    UserMailer.reset_password(self.id, temp_password).deliver
  end

  def create_default_associateds
    p = Pseud.new()
    p.name = self.login
    p.is_default = true
    self.pseuds << p
  end

  protected
    def first_save?
      self.new_record?
    end

  public


  # Retrieve the current default pseud
  def default_pseud
    self.pseuds.where(:is_default => true).first
  end

  # Checks authorship of any sort of object
  def is_author_of?(item)
    if item.respond_to?(:user)
      self == item.user
    elsif item.respond_to?(:pseud)
      self.pseuds.include?(item.pseud)
    elsif item.respond_to?(:pseuds)
      !(self.pseuds & item.pseuds).empty?
    elsif item.respond_to?(:author)
      self == item.author
    else
      false
    end
  end

  public

  # Creates log item tracking changes to user
  def create_log_item(options = {})
    options.reverse_merge! :note => 'System Generated', :user_id => self.id
    LogItem.create(options)
  end

end
