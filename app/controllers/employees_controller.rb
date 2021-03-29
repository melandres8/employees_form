class EmployeesController < ApplicationController
  before_action :set_employee, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:new, :create, :edit]

  def index
    @employees = Employee.all
    respond_to do |format|
      format.html
      format.csv {
        send_data @employees.to_csv, filename: "employees-#{Date.today}.csv"
      }
    end
  end

  def import
    @import = Employee.import(params[:file])
    redirect_to root_path, notice: "Employees uploaded successfully."

    if @import == @employee
      redirect_to root_path, alert: "Email has already taken."
    end
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employees_path, notice: "Employee #{@employee.nombres} was successfully created."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Employee #{@employee.nombres} was successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: "Employee #{@employee.nombres} was successfully destroyed."
    end
  end

  private

  def set_options
    @options = Employee.options
  end

  def employee_params
    params.require(:employee).permit(:nombres, :apellidos, :telefono, :email, :cargo, :salario, :departamento)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
