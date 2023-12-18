doc = readlines("./puzzle/d12.txt")

function check_fit(s, n)
    l = length.(split(s, ".", keepempty = false))
    if length(l) != length(n)
        return false
    elseif all(l .== n)
        return true
    else
        return false
    end
end

function trial_error(s, ns)
    str_vec = collect(s)
    cond = str_vec .== '?'
    num_unknown = sum(cond)

    nway = 0
    for i in 1:(2^num_unknown)
        new_str_vec = str_vec
        subs = [d == 1 ? '#' : '.' for d in digits(i-1, base = 2, pad = num_unknown)]
        new_str_vec[cond] = subs
        nway += check_fit(join(new_str_vec), ns)
    end
    return(nway)
end

nways = []
for l in doc
    sx = split(l)
    ns = parse.(Int16, split(sx[2], ","))
    push!(nways, trial_error(sx[1], ns))
end

#### brute force won't work need smarter search
function n_dmg(chunk)
    if occursin("?", chunk)
        return 0
    else
        return length(chunk)
    end
end

function find_next_step(s, ns)
    chunks = split(s, ".", keepempty = false)
    ndmg = n_dmg.(chunks)
    new_ns = copy(ns)
    while length(ndmg) > 0
        if ndmg[1] == 0
            next_step = "g"
            break
        elseif length(new_ns) == 0
            next_step = "a"
            break
        elseif ndmg[1] != new_ns[1]
            next_step = "a"
            break
        else
            popfirst!(ndmg)
            popfirst!(new_ns)
            popfirst!(chunks)
        end
    end

    if length(ndmg) == 0
        next_step = length(new_ns) == 0 ? "f" : "a" 
    end 
    new_s = join(chunks, ".")

    return(next_step, new_s, new_ns)
end

function new_trial_and_error(s, ns)
    # println(s)
    # println(ns)
    next_step, new_s, new_ns = find_next_step(s, ns)
    if next_step == "g"
        new_s1 = replace(new_s, "?" => "#", count = 1)
        new_s2 = replace(new_s, "?" => ".", count = 1)
        return new_trial_and_error(new_s1, new_ns) + new_trial_and_error(new_s2, new_ns)
    elseif next_step == "f"
        return 1
    elseif next_step == "a"
        return 0
    end
end

l = "?#??#???.??.??? 3,1,1,1,1"
sx = split(l)
s_expand = join(repeat([sx[1]], 4), "?")
nums = parse.(Int16, split(sx[2], ","))
n_expand = repeat(nums, 4)

new_trial_and_error(s_expand, n_expand)

nways = []
for l in doc
    println(l)
    sx = split(l)
    s_expand = join(repeat([sx[1]], 5), "?")
    nums = parse.(Int16, split(sx[2], ","))
    n_expand = repeat(nums, 5)
    push!(nways, new_trial_and_error(s_expand, n_expand))
end