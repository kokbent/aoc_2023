using StatsBase

doc = readlines("./puzzle/d14.txt")

function rearrange(s)
    if length(s) == 0 || !('O' in s) || !('.' in s) return s end
    counts = countmap(s)

    return repeat("O", counts['O']) * repeat(".", counts['.'])
end

function tilt(s)
    sp = split(s, "#", keepempty = true)
    tilted = join(rearrange.(sp), "#")
    return tilted
end

function weigh(s)
    sp = split(s, "")
    ind = findall(sp .== "O")
    w = (length(s) + 1) .- ind
    return(sum(w))
end

weights = []
for i in 1:length(doc[1])
    col = join([s[i] for s in doc])
    tcol = tilt(col)
    push!(weights, weigh(tcol))
end
weights
sum(weights)

####
function rearrange(s, reverse)
    if length(s) == 0 || !('O' in s) || !('.' in s) return s end
    counts = countmap(s)

    if reverse
        return repeat(".", counts['.']) * repeat("O", counts['O'])
    else
        return repeat("O", counts['O']) * repeat(".", counts['.'])
    end
end

function tilt(s, reverse)
    sp = split(s, "#", keepempty = true)
    tilted = join(rearrange_new.(sp, reverse), "#")
    return tilted
end

function tilt_all(vs, reverse)
    new_vs = []
    for i in 1:length(vs)
        col = join([s[i] for s in vs])
        tcol = tilt(col, reverse)
        push!(new_vs, tcol)
    end
    return(new_vs)
end

function spin_cycle(vs)
    m1 = tilt_all(vs, false)
    m2 = tilt_all(m1, false)
    m3 = tilt_all(m2, true)
    m4 = tilt_all(m3, true)
    return m4
end

function weigh_all(vs)
    weights = []
    for i in 1:length(vs)
        col = join([s[i] for s in vs])
        push!(weights, weigh(col))
    end
    return(sum(weights))
end

weights = []
mat = doc
for i in 1:1000
    mat = spin_cycle(mat)
    push!(weights, weigh_all(mat))
end

Plots.plot(weights[101:length(weights)])
sub_weights = weights[101:length(weights)]
min_ind = findall(sub_weights .== minimum(sub_weights))
diff(min_ind)
period = sub_weights[16:87]
