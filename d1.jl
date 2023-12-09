doc = readlines("./puzzle/d1.txt")
function first_last_digit(s)
    f = filter(isdigit, s)
    i = parse(Int32, f[begin] * f[end])
    return i
end

ints = [first_last_digit(s) for s in doc]
sum(ints)

####
num_dict = Dict("one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5",
                "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9")
r = "one|two|three|four|five|six|seven|eight|nine"
rg = Regex(r)
rev_rg = Regex(reverse(r))

function replace_at_once(s)
    replace(s, "1" => "one", "2" => "two", "3" => "three", 
        "4" => "four", "5" => "five", "6" => "six", "7" => "seven", 
        "8" => "eight", "9" => "nine")
end

function first_last_nums(s)
    slicefirst = findfirst(rg, s)
    slicelast = findfirst(rev_rg, reverse(s))
    dfirst = num_dict[s[slicefirst]]
    dlast = num_dict[reverse(reverse(s)[slicelast])]
    i = parse(Int16, dfirst * dlast)
    return i
end

newdoc = [replace_at_once(s) for s in doc]
ints = [first_last_nums(x) for x in newdoc]
sum(ints)