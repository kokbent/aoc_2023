using StatsBase, DataFrames

doc = readlines("./puzzle/d7.txt")
splits = [split(s) for s in doc]
hands = [s[1] for s in splits]
bids = [parse(Int, s[2]) for s in splits]

function counting(s)
    cm = countmap(split(s, ""))
    cm = sort(cm, byvalue = true, rev = true)
    v = collect(values(cm))
    return v
end

function detect_type(v)
    if v[1] == 5
        return 7
    elseif v[1] == 4
        return 6
    elseif v[1] == 3 && v[2] == 2
        return 5
    elseif v[1] == 3
        return 4
    elseif v[1] == 2 && v[2] == 2
        return 3
    elseif v[1] == 2
        return 2
    else
        return 1
    end
end

function replace_by_rank(s)
    replace(s, "2" => "a", "3" => "b", "4" => "c", "5" => "d",
            "6" => "e", "7" => "f", "8" => "g", "9" => "h",
            "T" => "i", "J" => "j", "Q" => "k", "K" => "l",
            "A" => "m")
end

types = [detect_type(counting(s)) for s in hands]
rep_hands = [replace_by_rank(s) for s in hands]

df = DataFrame(hand = hands, rep_hand = rep_hands, type = types, bid = bids)
df1 = sort(df, [:type, :rep_hand])

sum(df1.bid .* collect(1:1000))

####
function new_counting(s)
    cm = countmap(split(s, ""))
    cm = sort(cm, byvalue = true, rev = true)
    if haskey(cm, "J") && length(cm) != 1
        ks = collect(keys(cm))
        k = ks[1] == "J" ? ks[2] : ks[1]
        cm[k] = cm[k] + cm["J"]
        delete!(cm, "J")
    end
    v = collect(values(cm))
    # if sum(v) != 5 println(cm) end
    return v
end

function new_replace_by_rank(s)
    replace(s, "2" => "a", "3" => "b", "4" => "c", "5" => "d",
            "6" => "e", "7" => "f", "8" => "g", "9" => "h",
            "T" => "i", "J" => "0", "Q" => "k", "K" => "l",
            "A" => "m")
end

new_types = [detect_type(new_counting(s)) for s in hands]
new_rep_hands = [new_replace_by_rank(s) for s in hands]

new_df = DataFrame(hand = hands, rep_hand = new_rep_hands, type = new_types, bid = bids)
new_df1 = sort(new_df, [:type, :rep_hand])

sum(new_df1.bid .* collect(1:1000))
