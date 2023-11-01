defmodule Payroll.EmployeePayrollsTest do
  use ExUnit.Case
  doctest Payroll.EmployeePayrolls

  describe "calculate_employee_payroll/1" do
    setup do
      {:ok,
       build_line_item_dependency: &Payroll.LineItems.build_line_item_with_policy/1,
       calculate_taxes_dependency: &Payroll.LineItems.calculate_taxes/1}
    end

    test "calculates :ok when no line items given", context do
      ep = %Payroll.EmployeePayrolls.EmployeePayroll{employee_id: 1, line_items: []}

      assert {:ok,
              %Payroll.EmployeePayrolls.CalculatedEmployeePayroll{
                employee_id: 1,
                total: 0,
                taxable: 0,
                exempt: 0
              }} ==
               Payroll.EmployeePayrolls.calculate_employee_payroll(
                 context.build_line_item_dependency,
                 context.calculate_taxes_dependency,
                 ep
               )
    end

    test "calculates :ok when valid line items given", context do
      ep = %Payroll.EmployeePayrolls.EmployeePayroll{
        employee_id: 1,
        line_items: [
          %Payroll.LineItems.LineItem{amount: 100, line_item_key: "salary"},
          %Payroll.LineItems.LineItem{amount: 150, line_item_key: "bonus"},
          %Payroll.LineItems.LineItem{amount: 200, line_item_key: "meal_voucher"}
        ]
      }

      assert {:ok,
              %Payroll.EmployeePayrolls.CalculatedEmployeePayroll{
                employee_id: 1,
                total: 450,
                taxable: 350,
                exempt: 100
              }} ==
               Payroll.EmployeePayrolls.calculate_employee_payroll(
                 context.build_line_item_dependency,
                 context.calculate_taxes_dependency,
                 ep
               )
    end

    test "returns error when line item key is unknown", context do
      ep = %Payroll.EmployeePayrolls.EmployeePayroll{
        employee_id: 1,
        line_items: [
          %Payroll.LineItems.LineItem{amount: 10, line_item_key: "salary"},
          %Payroll.LineItems.LineItem{amount: 10, line_item_key: "bonus123123213123"}
        ]
      }

      assert {:error, _} =
               Payroll.EmployeePayrolls.calculate_employee_payroll(
                 context.build_line_item_dependency,
                 context.calculate_taxes_dependency,
                 ep
               )
    end
  end
end
