defmodule Payroll.EmployeePayrolls.CalculatedEmployeePayroll do
  @moduledoc """
  A struct representing an employee payroll that has been calculated.
  """

  @type t :: %__MODULE__{employee_id: integer(), total: integer(), taxable: integer(), exempt: integer()}
  @enforce_keys [:employee_id, :total, :taxable, :exempt]
  defstruct employee_id: 0, total: 0, taxable: 0, exempt: 0
end
