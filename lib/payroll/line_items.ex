defmodule Payroll.LineItems do
   @moduledoc """
  This module handles payroll line items.
  """

  alias Payroll.LineItems.LineItem
  alias Payroll.LineItems.LineItemWithPolicy
  alias Payroll.LineItems.CalculatedLineItem

  @doc """
  Builds a line item with tax policy based on the given line item.

  ## Examples
      iex> line_item = %Payroll.LineItems.LineItem{line_item_key: "salary", amount: 1000}
      iex> {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "TAXABLE"}} = Payroll.LineItems.build_line_item_with_policy(line_item)

      iex> line_item = %Payroll.LineItems.LineItem{line_item_key: "bonus", amount: 500}
      iex> {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: 500, line_item_key: "bonus", tax_policy: "TAXABLE"}} = Payroll.LineItems.build_line_item_with_policy(line_item)

      iex> line_item = %Payroll.LineItems.LineItem{line_item_key: "meal_voucher", amount: 200}
      iex> {:ok, %Payroll.LineItems.LineItemWithPolicy{amount: 200, line_item_key: "meal_voucher", tax_policy: "EXEMPT"}} = Payroll.LineItems.build_line_item_with_policy(line_item)

      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy(%Payroll.LineItems.LineItem{line_item_key: "unknown", amount: 100})

      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy(%Payroll.LineItems.LineItem{line_item_key: "unknown", amount: nil})

      iex> {:error, _error_message} = Payroll.LineItems.build_line_item_with_policy("not a line item at all")
  """
  @spec build_line_item_with_policy(LineItem.t()) :: {:ok, LineItemWithPolicy.t()} | {:error, String.t()}
  def build_line_item_with_policy(line_tem) do
    case line_tem do
      %LineItem{line_item_key: "salary", amount: amount} when is_integer(amount) ->
        {:ok, %LineItemWithPolicy{amount: amount, line_item_key: "salary", tax_policy: "TAXABLE"}}

      %LineItem{line_item_key: "bonus", amount: amount} when is_integer(amount) ->
        {:ok, %LineItemWithPolicy{amount: amount, line_item_key: "bonus", tax_policy: "TAXABLE"}}
      %LineItem{line_item_key: "meal_voucher", amount: amount} when is_integer(amount) ->
        {:ok, %LineItemWithPolicy{amount: amount, line_item_key: "meal_voucher", tax_policy: "EXEMPT"}}
      other ->
        {:error, "build_line_item_with_policy: unsupported line item given #{inspect(other)}"}
    end
  end

  @doc """
  Calculates taxes for given line item.

  ## Examples
      iex> line_item = %Payroll.LineItems.LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "TAXABLE"}
      iex> {:ok, %Payroll.LineItems.CalculatedLineItem{amount: 1000, taxable: 1000, exempt: 0}} = Payroll.LineItems.calculate_taxes(line_item)

      iex> line_item = %Payroll.LineItems.LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "EXEMPT"}
      iex> {:ok, %Payroll.LineItems.CalculatedLineItem{amount: 1000, taxable: 500.0, exempt: 500.0}} = Payroll.LineItems.calculate_taxes(line_item)

      iex> line_item = %Payroll.LineItems.LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "SOMe-unknownPOLICY"}
      iex> {:error, _} = Payroll.LineItems.calculate_taxes(line_item)

      iex> line_item = %Payroll.LineItems.LineItemWithPolicy{amount: nil, line_item_key: "salary", tax_policy: "TAXABLE"}
      iex> {:error, _} = Payroll.LineItems.calculate_taxes(line_item)
  """
  @spec calculate_taxes(LineItemWithPolicy.t()) :: {:ok, CalculatedLineItem.t()} | {:error, String.t()}
  def calculate_taxes(line_item_with_policy) do
    case line_item_with_policy do
      %LineItemWithPolicy{amount: amount, line_item_key: _, tax_policy: "TAXABLE"} when is_integer(amount) ->
        {:ok, %CalculatedLineItem{amount: amount, taxable: amount, exempt: 0}}
       %LineItemWithPolicy{amount: amount, line_item_key: _, tax_policy: "EXEMPT"} when is_integer(amount) ->
        exempt = amount / 2
        taxable = amount - exempt
        {:ok, %CalculatedLineItem{amount: amount, taxable: taxable, exempt: exempt}}
      any ->
        {:error, "#{__MODULE__}.calculate_taxes: invalid input given #{inspect(any)}"}
    end
  end
end
