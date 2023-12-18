using DataStructures

doc = readline("./puzzle/d15.txt")

sp = split(doc, ",")

function HASH(s)
    val = 0
    for c in s
        val += Int(c)
        val *= 17
        val = val % 256
    end
    return val
end

hashes = HASH.(sp)
sum(hashes)

####
boxes = [OrderedDict() for i in 1:256]
for s in sp
    if occursin("=", s)
        extract = match(r"([a-z]+)=(\d)", s)
        h = HASH(extract[1])+1

        if extract[1] in keys(boxes[h])
            boxes[h][extract[1]] = parse(Int16, extract[2])
        else
            merge!(boxes[h], Dict(extract[1] => parse(Int16, extract[2])))
        end
    else
        extract = match(r"([a-z]+)-", s)
        h = HASH(extract[1])+1

        if extract[1] in keys(boxes[h])
            delete!(boxes[h], extract[1])
        end
    end
end

focal_powers = []
for i in eachindex(boxes)
    if length(boxes[i]) == 0 continue end
    vals = [d[2] for d in boxes[i]]
    fp = i .* vals .* collect(1:length(vals))
    push!(focal_powers, sum(fp))
end
sum(focal_powers)
