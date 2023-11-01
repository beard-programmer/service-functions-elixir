defmodule Payroll.LineItems do
   @moduledoc """
  This module handles payroll line items.
  """

  alias Payroll.LineItems.LineItem
  alias Payroll.LineItems.LineItemWithPolicy

  @doc """
  Builds a line item with tax policy based on the given line item.

  ## Examples
      iex> alias Payroll.LineItems.LineItem
      iex> alias Payroll.LineItems.LineItemWithPolicy
      iex> line_item = %LineItem{line_item_key: "salary", amount: 1000}
      iex> Payroll.LineItems.build_line_item_with_policy(line_item)
      {:ok, %LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "TAXABLE"}}

      iex> alias Payroll.LineItems.LineItem
      iex> alias Payroll.LineItems.LineItemWithPolicy
      iex> line_item = %LineItem{line_item_key: "bonus", amount: 500}
      iex> Payroll.LineItems.build_line_item_with_policy(line_item)
      {:ok, %LineItemWithPolicy{amount: 500, line_item_key: "bonus", tax_policy: "TAXABLE"}}

      iex> alias Payroll.LineItems.LineItem
      iex> alias Payroll.LineItems.LineItemWithPolicy
      iex> line_item = %LineItem{line_item_key: "meal_voucher", amount: 200}
      iex> Payroll.LineItems.build_line_item_with_policy(line_item)
      {:ok, %LineItemWithPolicy{amount: 200, line_item_key: "meal_voucher", tax_policy: "EXEMPT"}}

      iex> alias Payroll.LineItems.LineItem
      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy(%LineItem{line_item_key: "unknown", amount: 100})

      iex> alias Payroll.LineItems.LineItem
      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy(%LineItem{line_item_key: "unknown", amount: nil})

      iex> alias Payroll.LineItems.LineItem
      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy("not a line item at all")
  """
  @spec build_line_item_with_policy(LineItem.t()) :: {:ok, LineItemWithPolicy.t()} | {:error, String.t()}
  def build_line_item_with_policy(line_tem) do
    case line_tem do
      %Payroll.LineItems.LineItem{line_item_key: "salary", amount: amount} when is_integer(amount) ->
        {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: amount, line_item_key: "salary", tax_policy: "TAXABLE"}}

      %Payroll.LineItems.LineItem{line_item_key: "bonus", amount: amount} when is_integer(amount) ->
        {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: amount, line_item_key: "bonus", tax_policy: "TAXABLE"}}
      %LineItem{line_item_key: "meal_voucher", amount: amount} when is_integer(amount) ->
        {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: amount, line_item_key: "meal_voucher", tax_policy: "EXEMPT"}}
      other ->
        {:error, "build_line_item_with_policy: unsupported line item given #{inspect(other)}"}
    end
  end
end
