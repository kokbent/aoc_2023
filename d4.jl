doc = readlines("puzzle/d4.txt")

function find_nmatch(s)
    win_num_range = [x:(x+1) for x in collect(11:3:38)]
    hav_num_range = [x:(x+1) for x in collect(43:3:115)]
    gid = s[6:8]
    win_nums = [parse(Int, s[x]) for x in win_num_range]
    hav_nums = [parse(Int, s[x]) for x in hav_num_range]
    matches = [x in win_nums for x in hav_nums]
    nmatch = sum(matches)

    return nmatch
end

nmatches = [find_nmatch(s) for s in doc]
points = [n == 0 ? 0 : 2^(n-1) for n in nmatches]

sum(points)

####
function get_child(parent_id)
    n = nmatches[parent_id]
    child_ids = collect(1:n) .+ parent_id
    return(child_ids)
end

sc = collect(1:length(nmatches))
total = 0
while length(sc) != 0
    children = get_child(sc[1])
    append!(sc, children)
    total += 1
    popfirst!(sc)
end
total