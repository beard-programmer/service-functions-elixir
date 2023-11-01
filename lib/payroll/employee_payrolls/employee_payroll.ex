defmodule Payroll.EmployeePayrolls.EmployeePayroll do
  @moduledoc """
  A struct representing an employee payroll.
  """

  @type t :: %__MODULE__{employee_id: integer(), line_items: list(Payroll.LineItems.LineItem.t())}
  @enforce_keys [:employee_id, :line_items]
  defstruct employee_id: 0, line_items: []
end
