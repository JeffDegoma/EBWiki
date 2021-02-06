# frozen_string_literal: true

require 'observer'

# EBWiki site user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: { message: 'Please add a name.' }

  has_many :cases
  has_many :comments
  acts_as_follower
  acts_as_messageable
  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders]

  STRIPPED_ATTRIBUTES = %w[
    email
    name
    description city
    facebook_url
    twitter_url
    linkedin
  ].freeze

  auto_strip_attributes(*STRIPPED_ATTRIBUTES)

  def mailboxer_name
    name
  end

  def mailboxer_email(_object)
    email
  end

  def slug_candidates
    [
      :name,
      %i[name id]
    ]
  end

  def mailchimp_status
    case mailchimp_user
    when Array
      nil
    when Hash
      mailchimp_user['status']
    end
  end

  private

  def mailchimp_user
    gb = Gibbon::Request.new
    gb.lists(ENV['MAILCHIMP_LIST_ID']).members(Digest::MD5.hexdigest(email.downcase.to_s)).retrieve
  rescue Gibbon::MailChimpError => e
    [nil, { flash: { error: e.message } }]
  end
end
