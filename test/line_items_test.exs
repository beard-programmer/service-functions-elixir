defmodule Payroll.LineItemsTest do
  use ExUnit.Case
  doctest Payroll.LineItems

  alias Payroll.LineItems
  alias LineItems.LineItemWithPolicy
  alias LineItems.LineItem
  alias LineItems.CalculatedLineItem

  describe "build_line_item_with_policy/1" do
    test "builds line item with policy for salary" do
      line_item = %LineItem{line_item_key: "salary", amount: 1000}
      assert LineItems.build_line_item_with_policy(line_item) == {:ok, %LineItemWithPolicy{amount: line_item.amount, line_item_key: line_item.line_item_key,tax_policy: "TAXABLE"}}
    end

    test "builds line item with policy for bonus" do
      line_item = %LineItem{line_item_key: "bonus", amount: 500}
      assert LineItems.build_line_item_with_policy(line_item) == {:ok, %LineItemWithPolicy{amount: line_item.amount, line_item_key: line_item.line_item_key,tax_policy: "TAXABLE"}}
    end

    test "builds line item with policy for meal voucher" do
      line_item = %LineItem{line_item_key: "meal_voucher", amount: 200}
      assert LineItems.build_line_item_with_policy(line_item) == {:ok, %LineItemWithPolicy{amount: line_item.amount, line_item_key: line_item.line_item_key,tax_policy: "EXEMPT"}}
    end

    test "returns error for unsupported line item" do
      line_item = %LineItem{line_item_key: "unknown", amount: 100}
      assert {:error, _reason} = LineItems.build_line_item_with_policy(line_item)
    end

    test "returns error for non-integer amount" do
      line_item = %LineItem{line_item_key: "salary", amount: "not an integer"}
      assert {:error, _reason} = LineItems.build_line_item_with_policy(line_item)
    end

    test "returns error for non line item input" do
      line_item = 123456789
      assert {:error, _reason} = LineItems.build_line_item_with_policy(line_item)
    end
  end

  describe "calculate_taxes/1" do
    test "calculates taxes for salary" do
      line_item = %LineItemWithPolicy{amount: 1000, line_item_key: "salary", tax_policy: "TAXABLE"}
      assert LineItems.calculate_taxes(line_item) == {:ok, %CalculatedLineItem{amount: 1000, taxable: 1000, exempt: 0}}
    end

    test "calculates taxes for bonus" do
      line_item = %LineItemWithPolicy{amount: 500, line_item_key: "bonus", tax_policy: "TAXABLE"}
      assert LineItems.calculate_taxes(line_item) == {:ok, %CalculatedLineItem{amount: 500, taxable: 500, exempt: 0}}
    end

    test "calculates taxes for meal voucher" do
      line_item = %LineItemWithPolicy{amount: 100, line_item_key: "meal_voucher", tax_policy: "EXEMPT"}
      assert LineItems.calculate_taxes(line_item) == {:ok, %CalculatedLineItem{amount: 100, taxable: 50, exempt: 50}}
    end

    test "returns error when not known tax policy" do
      line_item = %LineItemWithPolicy{amount: 100, line_item_key: "meal_voucher", tax_policy: "SOME-unknown-policy"}
      assert {:error, _} = LineItems.calculate_taxes(line_item)
    end

    test "returns error when amount is invalid" do
      line_item = %LineItemWithPolicy{amount: nil, line_item_key: "meal_voucher", tax_policy: "TAXABLE"}
      assert {:error, _} = LineItems.calculate_taxes(line_item)
    end

    test "returns error when input is not line item at all" do
      line_item = "this is not a line item"
      assert {:error, _} = LineItems.calculate_taxes(line_item)
    end
  end
end
