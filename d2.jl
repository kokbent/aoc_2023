using DataFrames, Statistics
doc = readlines("puzzle/d2.txt")

bigdf = DataFrame()
for j in eachindex(doc)
    s = doc[j]
    gid, allrnds = split(s, ": ")
    rnds = split(allrnds, "; ")

    rnds_df = DataFrame()
    for i in eachindex(rnds)
        df = DataFrame(n = String[], colour = String[])
        balls = split(rnds[i], ", ")
        balls_vec = [match(r"(\d+) (.*)", x).captures for x in balls]
        for r in balls_vec push!(df, r) end
        df[!, :rnd] .= i
        rnds_df = [rnds_df; df]
    end
    
    rnds_df[!, :game] .= j
    bigdf = [bigdf; rnds_df]
end
transform!(bigdf, :n => ByRow(x -> parse(Int, x)) => :n)

function upper_limit(x)
    if (x == "red")
        return 12
    elseif (x == "green")
        return 13
    else return 14
    end
end

bigdf[!, :limit] = [upper_limit(c) for c in bigdf[!, :colour]]
bigdf[!, :exceed] = bigdf[!, :n] .<= bigdf[!, :limit]

exceed_df = combine(groupby(bigdf, :game), :exceed => mean)
gid_possible = exceed_df[exceed_df[!, :exceed_mean] .== 1.0, :game]
sum(gid_possible)

####
function max_or_na(x)
    if (size(x) == 0)
        return nothing
    else return max(x)
    end
end
max_df = combine(groupby(bigdf, [:game, :colour]), :n => maximum)
power_df = combine(groupby(max_df, :game), :n_maximum => prod => :prod)
sum(power_df[:, :prod])