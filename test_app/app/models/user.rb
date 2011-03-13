class User < ActiveRecord::Base

  # Allows other models to get the current user with User.current_user
  cattr_accessor :current_user

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

  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable

  def to_param
    login
  end


  public

  # Retrieve the current default pseud
  def default_pseud
    self.pseuds.where(:is_default => true).first
  end

  def is_translation_admin?
    translation_admin
  end

end
