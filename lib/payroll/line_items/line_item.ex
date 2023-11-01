defmodule Payroll.LineItems.LineItem do
  @moduledoc """
  A struct representing a line item in a payroll.
  """

  @type t :: %__MODULE__{amount: integer(), line_item_key: String.t()}
  @enforce_keys [:amount, :line_item_key]
  defstruct amount: 0, line_item_key: ""
end
