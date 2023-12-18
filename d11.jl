doc = readlines("./puzzle/d11.txt")

doc01 = [replace(s, "." => 0, "#" => 1) for s in doc]
doc01sp = [split(s, "") for s in doc01]
docint = [[parse(Int8, c) for c in s] for s in doc01sp]
mat = reduce(vcat, transpose(docint))

newvec1 = []
for i in 1:size(mat)[1]
    have_galaxy = sum(mat[i, :])
    if have_galaxy == 0
        push!(newvec1, i)
        push!(newvec1, i)
    else
        push!(newvec1, i)
    end
end

newmat1 = mat[newvec1, :]
newvec2 = []
for i in 1:size(newmat1)[2]
    have_galaxy = sum(newmat1[:, i])
    if have_galaxy == 0
        push!(newvec2, i)
        push!(newvec2, i)
    else
        push!(newvec2, i)
    end
end
newmat2 = newmat1[:, newvec2]

galaxy_locs = []
for i in 1:size(newmat2)[1]
    ys = findall(newmat2[i, :] .== 1)
    coords = [[i, y] for y in ys]
    galaxy_locs = reduce(vcat, (galaxy_locs, coords))
end

dists = []
for i in 1:(length(galaxy_locs)-1)
    for j in (i+1):length(galaxy_locs)
        dif = galaxy_locs[j] - galaxy_locs[i]
        dist = sum(abs.(dif))
        push!(dists, dist)
    end
end

sum(dists)

####
rs_nogalaxy = findall([sum(r) == 0 for r in eachrow(mat)])
cs_nogalaxy = findall([sum(c) == 0 for c in eachcol(mat)])

..(a, b) = a:(b - a == 0 ? 1 : sign(b - a)):b

galaxy_locs = []
for i in 1:size(mat)[1]
    xs = findall(mat[i, :] .== 1)
    coords = [[x, i] for x in xs]
    galaxy_locs = reduce(vcat, (galaxy_locs, coords))
end

newdists = []
for i in 1:(length(galaxy_locs)-1)
    for j in (i+1):length(galaxy_locs)
        difx = galaxy_locs[j][1]..galaxy_locs[i][1]
        intx = intersect(difx, cs_nogalaxy)
        distx = (length(difx) - length(intx) - 1) + (length(intx) * 1e6)
        
        dify = galaxy_locs[j][2]..galaxy_locs[i][2]
        inty = intersect(dify, rs_nogalaxy)
        disty = (length(dify) - length(inty) - 1) + (length(inty) * 1e6)

        dist = distx + disty
        push!(newdists, dist)
    end
end

sum(newdists)
using Printf
@printf "%.f \n" sum(newdists)
