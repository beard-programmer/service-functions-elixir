defmodule Payroll.LineItems.CalculatedLineItem do
  @moduledoc """
  A struct representing line item with calculated amounts in a payroll.
  """

  @type t :: %__MODULE__{amount: integer(), taxable: integer(), exempt: integer()}
  @enforce_keys [:amount, :taxable, :exempt]
  defstruct amount: 0, taxable: 0, exempt: 0
end
