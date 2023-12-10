doc = readlines("puzzle/d9.txt")

preds = []
for s in doc
    v = [parse(Int, i) for i in split(s, " ")]
    dv = diff(v)
    lasts = []
    while !all(dv .== 0)
        push!(lasts, dv[length(dv)])
        dv = diff(dv)
    end
    push!(preds, v[length(v)] + sum(lasts))
end
sum(preds)

####
preds = []
for s in doc
    v = [parse(Int, i) for i in split(s, " ")]
    dv = diff(v)
    firsts = []
    while !all(dv .== 0)
        push!(firsts, dv[1])
        dv = diff(dv)
    end
    ind = collect(1:length(firsts))
    mult = [isodd(i) ? -1 : 1 for i in ind]
    add = firsts .* mult
    push!(preds, v[1] + sum(add))
end
sum(preds)

# 1 - (2 - (1 - 0))
A - B + C
A - B + C - D

s = doc[2]
v = [parse(Int, i) for i in split(s, " ")]
v = v[2:length(v)]
dv = diff(v)
firsts = []
while !all(dv .== 0)
    push!(firsts, dv[1])
    dv = diff(dv)
end
ind = collect(1:length(firsts))
mult = [isodd(i) ? -1 : 1 for i in ind]
add = firsts .* mult
sum(add)