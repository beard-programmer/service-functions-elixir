defmodule Payroll.LineItems.LineItemWithPolicy do
  @moduledoc """
  A struct representing a line item with tax policy in a payroll.
  """

  @type t :: %__MODULE__{amount: integer(), line_item_key: String.t(), tax_policy: String.t()}
  @enforce_keys [:amount, :line_item_key, :tax_policy]
  defstruct amount: 0, line_item_key: "", tax_policy: ""
end
