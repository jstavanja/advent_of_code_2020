defmodule PasswordPhilosophy do
    def parse_rules_and_passwords(plain_rule_lines) do
        plain_rule_lines = Enum.map(
            plain_rule_lines,
            fn x -> String.split(x, ":")
                |> Enum.map(&String.trim/1)
            end)

        plain_rule_lines = Enum.map(
            plain_rule_lines,
            fn [rule, password] ->
               [String.split(rule, " "), password]
            end)

        plain_rule_lines = Enum.map(
            plain_rule_lines,
            fn [[bounds, character], password] ->
               [[String.split(bounds, "-"), character], password]
            end)
        
        Enum.map(
            plain_rule_lines,
            fn [[[lower_bound, upper_bound], character], password] ->
               [[[String.to_integer(lower_bound), String.to_integer(upper_bound)], character], password]
            end)
    end

    def count_valid_passwords(plain_rule_lines, validator_func) do
        rules_and_passwords = parse_rules_and_passwords(plain_rule_lines)
        List.foldl(rules_and_passwords, 0, fn rule_and_password, acc -> if validator_func.(rule_and_password) do acc + 1 else acc end end)
    end

    def is_valid_password([[[lower_bound, upper_bound], character], password]) do
        occurences = password |> String.split(character) |> length()
        occurences = occurences - 1

        is_in_range(occurences, lower_bound, upper_bound)
    end

    def is_valid_password_exact_positions([[[first_position, second_position], character], password]) do
        char_at_first_position = String.at(password, first_position - 1)
        char_at_second_position = String.at(password, second_position - 1)
        
        (character == char_at_first_position and character != char_at_second_position) or (character != char_at_first_position and character == char_at_second_position)
    end

    def is_in_range(num, min, max), do: num in min..max
end

{:ok, file_contents} = File.read("inputs/2_password_philosophy.txt")

rules_and_passwords = file_contents
    |> String.split("\n", trim: true)

IO.inspect PasswordPhilosophy.count_valid_passwords(rules_and_passwords, &PasswordPhilosophy.is_valid_password/1)
IO.inspect PasswordPhilosophy.count_valid_passwords(rules_and_passwords, &PasswordPhilosophy.is_valid_password_exact_positions/1)
