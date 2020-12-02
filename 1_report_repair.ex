defmodule ReportRepair do

    def generate_possible_combinations([a, b]) do
        [[a, b]]
    end

    def generate_possible_combinations([hd | tl]) do
       generate_possible_combinations_for_current_element(hd, tl) ++ generate_possible_combinations(tl)
    end

    def generate_possible_combinations_for_current_element(el, rest) do
        List.foldl(rest, [], fn x, acc -> acc ++ [[el, x]] end)
    end

    def get_pair(numbers) do
        ReportRepair.generate_possible_combinations(numbers)
            |> find_two_that_sum_to_2020
    end

    def find_two_that_sum_to_2020([[hd_a, hd_b] | rest]) do
        if (hd_a + hd_b == 2020) do
            [hd_a, hd_b]
        else
            find_two_that_sum_to_2020(rest)
        end
    end
end

{:ok, file_contents} = File.read("inputs/1_report_repair.txt")

numbers = file_contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)

[a, b] = ReportRepair.get_pair(numbers)

IO.inspect a*b
