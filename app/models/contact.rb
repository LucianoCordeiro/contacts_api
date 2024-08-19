class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :address, :phone, presence: true
  validates :cpf, presence: true, uniqueness: true

  validate :valid_cpf?

  geocoded_by :address

  after_validation :geocode

  def valid_cpf?
    errors.add(:base, "CPF deve ser válido") unless CPF.valid?(cpf)
  end

  scope :with_name,
  lambda { |name|
    s = "%#{name}%"
    where("name ilike ?", s) if name.present?
  }

  scope :with_cpf,
  lambda { |cpf|
    return unless cpf.present?
    where(cpf: cpf)
  }
end
