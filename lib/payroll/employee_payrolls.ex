defmodule Payroll.EmployeePayrolls do
  @doc """
  Calculates employee payroll.

  ## Examples
    iex> ep = %Payroll.EmployeePayrolls.EmployeePayroll{employee_id: 1, line_items: []}
    iex> {:ok, %Payroll.EmployeePayrolls.CalculatedEmployeePayroll{employee_id: 1,total: 0,taxable: 0,exempt: 0}} = Payroll.EmployeePayrolls.calculate_employee_payroll(&Payroll.LineItems.build_line_item_with_policy/1, &Payroll.LineItems.calculate_taxes/1, ep)
    iex> ep = %Payroll.EmployeePayrolls.EmployeePayroll{
    ...>   employee_id: 1,
    ...>   line_items: [
    ...>     %Payroll.LineItems.LineItem{amount: 100, line_item_key: "salary"},
    ...>     %Payroll.LineItems.LineItem{amount: 150, line_item_key: "bonus"},
    ...>     %Payroll.LineItems.LineItem{amount: 200, line_item_key: "meal_voucher"}
    ...>   ]
    ...> }
    iex> Payroll.EmployeePayrolls.calculate_employee_payroll(&Payroll.LineItems.build_line_item_with_policy/1, &Payroll.LineItems.calculate_taxes/1, ep)
    {:ok,
      %Payroll.EmployeePayrolls.CalculatedEmployeePayroll{
        employee_id: 1,
        total: 450,
        taxable: 350.0,
        exempt: 100.0
      }}
  """
  @spec calculate_employee_payroll(
          Payroll.LineItems.build_line_item_with_policy_fn(),
          Payroll.LineItems.calculate_taxes_fn(),
          Payroll.EmployeePayrolls.EmployeePayroll.t()
        ) ::
          {:ok, Payroll.EmployeePayrolls.CalculatedEmployeePayroll.t()} | {:error, String.t()}
  def calculate_employee_payroll(
        build_line_item_with_policy_fn,
        calculate_taxes_fn,
        %Payroll.EmployeePayrolls.EmployeePayroll{employee_id: employee_id} = employee_payroll
      )
      when is_integer(employee_id) do
    # calculate_taxes_fn = &Payroll.LineItems.calculate_taxes/1

    # Step 1: receive line items
    {:ok, employee_payroll.line_items}
    # Step 2: build line items with policy using Dependency
    |> process_collection(build_line_item_with_policy_fn)
    # Step 3: calculate taxes for each line item using Dependency
    |> process_collection(calculate_taxes_fn)
    |> case do
      {:ok, list} ->
        # Step 4: build CalculatedEmployeePayroll
        {total_amount, total_taxable, total_exempt} = aggregate_totals(list)

        {:ok,
         %Payroll.EmployeePayrolls.CalculatedEmployeePayroll{
           employee_id: employee_id,
           total: total_amount,
           taxable: total_taxable,
           exempt: total_exempt
         }}

      {:error, reason} ->
        {:error, "#{__MODULE__}.calculate_employee_payroll: failed, reason - #{reason}"}
    end
  end

  defp aggregate_totals(calculated_line_items) do
    aggregation_fn = fn %{amount: amount, taxable: taxable, exempt: exempt},
                        {amount_acc, taxable_acc, exempt_acc} ->
      {amount_acc + amount, taxable_acc + taxable, exempt_acc + exempt}
    end

    Enum.reduce(calculated_line_items, {0, 0, 0}, aggregation_fn)
  end

  defp process_collection({:ok, collection}, operation) do
    apply_operation_fn = fn element, {:ok, acc} ->
      case operation.(element) do
        {:ok, result} ->
          {:cont, {:ok, [result | acc]}}

        {:error, reason} ->
          {:halt,
           {:error,
            "process_collection: - error processing #{inspect(element)} with reason #{reason}"}}
      end
    end

    Enum.reduce_while(collection, {:ok, []}, apply_operation_fn)
    |> case do
      {:ok, results} -> {:ok, Enum.reverse(results)}
      error -> error
    end
  end

  defp process_collection(error, _), do: error
end
