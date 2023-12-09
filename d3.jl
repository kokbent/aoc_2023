doc = readlines("puzzle/d3.txt")

str_sub(s,newstr,sl) = @. SubString(s,1,sl.start-1) * newstr * SubString(s,sl.stop+1,length(s))
function find_num_ranges(str)
    ranges = Vector{UnitRange}()
    nums = Vector{Int}()
    ini = 1
    sl = findnext(r"\d+", str, ini)
    while !isnothing(sl)
        num = parse(Int, str[sl])
        push!(nums, num)
        push!(ranges, sl)
        ini = sl.stop + 1
        if ini > length(str) break end
        sl = findnext(r"\d+", str, ini)
    end
    return ranges, nums
end

function scan_loc(rs, locs)
    if length(rs) == 0
        return Bool[]
    else
        b = zeros(Bool, length(rs))
        for l in locs
            c = [l in r for r in rs]
            b = b .| c
        end
        return b
    end
end

nums = []
ranges = []
for s in doc
    r, n = find_num_ranges(s)
    push!(nums, n)
    push!(ranges, r)
end
nums
ranges

inclusion = [zeros(Bool, length(v)) for v in nums]

symsum = 0
for i in eachindex(doc)
    ini = 1
    next_sl = findnext(r"[@#$%&*\/\-+=]", doc[i], ini)

    while !isnothing(next_sl)
        symsum += 1
        next_loc = next_sl.start
        # same row
        if !(i-1 == 0)
            inclusion[i-1] = inclusion[i-1] .| scan_loc(ranges[i-1], [next_loc-1, next_loc, next_loc+1])
        end
        if !(i+1 > length(nums))
            inclusion[i+1] = inclusion[i+1] .| scan_loc(ranges[i+1], [next_loc-1, next_loc, next_loc+1])
        end
        inclusion[i] = inclusion[i] .| scan_loc(ranges[i], [next_loc-1, next_loc+1])

        ini = next_loc + 1
        if ini > length(doc[i]) break end
        next_sl = findnext(r"[@#$%&*\/\-+=]", doc[i], ini)
    end
end

grandsum = 0
for i in eachindex(nums)
    n = sum(nums[i][inclusion[i]])
    grandsum += n
end
    
grandsum

####
ratios = Int[]
for i in eachindex(doc)
    ini = 1
    next_sl = findnext(r"[*]", doc[i], ini)

    while !isnothing(next_sl)
        next_loc = next_sl.start
        # same row
        if !(i-1 == 0)
            n1 = nums[i-1][scan_loc(ranges[i-1], [next_loc-1, next_loc, next_loc+1])]
        end
        if !(i+1 > length(nums))
            n3 = nums[i+1][scan_loc(ranges[i+1], [next_loc-1, next_loc, next_loc+1])]
        end
        n2 = nums[i][scan_loc(ranges[i], [next_loc-1, next_loc+1])]

        adj_nums = [n1; n2; n3]
        if length(adj_nums) == 2
            push!(ratios, prod(adj_nums))
        end

        ini = next_loc + 1
        if ini > length(doc[i]) break end
        next_sl = findnext(r"[*]", doc[i], ini)
    end
end
sum(ratios)