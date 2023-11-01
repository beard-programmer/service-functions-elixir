defmodule Payroll.LineItemsTest do
  use ExUnit.Case
  doctest Payroll.LineItems

  alias Payroll.LineItems
  alias LineItems.LineItemWithPolicy
  alias LineItems.LineItem

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
end
