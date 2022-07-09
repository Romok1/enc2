class User < ApplicationRecord
  has_many :portfolios
  belongs_to :organisation_type, optional: true
  belongs_to :country, optional: true
  has_many :alignment_options, through: :organisation_type

  # Include default devise modules. Others available are:
  # :lockable,
  # :omniauthable,
  # :timeoutable,
  # :trackable,
  devise :confirmable,
         :database_authenticatable,
         :recoverable,
         :registerable,
         :rememberable,
         :validatable

  validates :password, confirmation: true, length: { in: 8..128 }, if: -> { created_at.blank? }
  validates :password, format: { with: /\A.*\d.*\z/, message: I18n.t('validation.digit_character') }, if: -> { created_at.blank? }
  validates :password, format: { with: /\A.*[a-z].*\z/, message: I18n.t('validation.lowercase_character') }, if: -> { created_at.blank? }
  validates :password, format: { with: /\A.*[!@#$%^&*].*\z/, message: I18n.t('validation.special_character') }, if: -> { created_at.blank? }
  validates :password, format: { with: /\A.*[A-Z].*\z/, message: I18n.t('validation.uppercase_character') }, if: -> { created_at.blank? }

  validates :organisation_type, presence: true
  validates :organisation, presence: true
  validates :country, presence: true

  validates_acceptance_of :terms, on: :create
  validates_presence_of :name, :email
  validates_uniqueness_of :email

  def as_json(options = {})
    super(default_json_options(options))
  end

  def to_json(options = {})
    super(default_json_options(options))
  end

  private

  def default_json_options(options)
    {
      except: %i[
        id
        created_at
        updated_at
      ],
      methods: %i[
        reset_password_sent_at
        confirmed_at
        confirmation_sent_at
        unconfirmed_email
      ]
    }.merge(options)
  end
end
