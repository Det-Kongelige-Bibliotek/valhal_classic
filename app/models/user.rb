# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors. 
 include Hydra::User
  # Connects this user object to Hydra behaviors.
  include Hydra::User

  include CanCan::Ability
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :pid, :uid
  # attr_accessible :title, :body

  ROLES = %w[admin depositor guest]

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end

  def update_with_email(params, *options)
    if email.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end


  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    name
  end


  #environment includes a list of emails of users that should have admin privileges
  def admin?
    if APP_CONFIG['admin_emails']
      APP_CONFIG['admin_emails'].include?(email)
    else
      false
    end
  end

  #anybody that can login, is a depositor. No restrictions
  def depositor?
    !uid.blank?
  end
end
