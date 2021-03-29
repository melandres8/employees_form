class Employee < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :nombres, presence: true
  validates :apellidos, presence: true

  JUST_NUMBERS = /\A^[0-9]*$\z/i
  validates :telefono, presence: true, numericality: true, format: { with: JUST_NUMBERS }, length: {is: 10}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { maximum: 105 },
                      format: { with: VALID_EMAIL_REGEX }

  validates :cargo, presence: true
  validates :salario, presence: true
  validates :departamento, presence: true

  def self.options
    ["Contabilidad", "Finanzas", "Operaciones", "Seguridad", "Recursos Humanos"]
  end

  def self.to_csv
    attrs = %w{nombres apellidos telefono email cargo salario departamento}
    CSV.generate(headers: true) do |csv|
      csv << attrs
      all.find_each do |employee|
        csv << attrs.map{ |attr| employee.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      employees_hash = row.to_hash
      employee = find_or_create_by(
        nombres: employees_hash['nombres'],
        apellidos: employees_hash['apellidos'],
        email: employees_hash['email'],
        telefono: employees_hash['telefono'],
        cargo: employees_hash['cargo'],
        salario: employees_hash['salario'],
        departamento: employees_hash['departamento']
      )
      employee.update(employees_hash)
    end
  end
end
