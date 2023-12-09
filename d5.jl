doc = readlines("puzzle/d5.txt")

seeds = split(doc[1], " ")
popfirst!(seeds)
seeds = [parse(Int, s) for s in seeds]

function make_ranges(s)
    codes = [parse(Int, r) for r in split(s, " ")]
    src_range = codes[2]:(codes[2] + codes[3] - 1)
    dst_range = codes[1]:(codes[1] + codes[3] - 1)
    return (src_range, dst_range)
end

function map_code(c, rgs)
    rg = filter((x) -> c in x[1], rgs)
    
    if length(rg) > 0
        newc = (c - rg[1][1].start) + rg[1][2].start
    else
        newc = c
    end

    return newc
end

seed_soil_ranges = [make_ranges(s) for s in doc[4:9]]
soil_fert_ranges = [make_ranges(s) for s in doc[12:54]]
fert_wate_ranges = [make_ranges(s) for s in doc[57:95]]
wate_ligh_ranges = [make_ranges(s) for s in doc[98:144]]
ligh_temp_ranges = [make_ranges(s) for s in doc[147:173]]
temp_humi_ranges = [make_ranges(s) for s in doc[176:183]]
humi_loca_ranges = [make_ranges(s) for s in doc[186:201]]

locations = Int[]
for s in seeds
    soil = map_code(s, seed_soil_ranges)
    fert = map_code(soil, soil_fert_ranges)
    wate = map_code(fert, fert_wate_ranges)
    ligh = map_code(wate, wate_ligh_ranges)
    temp = map_code(ligh, ligh_temp_ranges)
    humi = map_code(temp, temp_humi_ranges)
    loca = map_code(humi, humi_loca_ranges)
    push!(locations, loca)
end
minimum(locations)

####
function reverse_map_code(c, rgs)
    rg = filter((x) -> c in x[2], rgs)
    
    if length(rg) > 0
        newc = (c - rg[1][2].start) + rg[1][1].start
    else
        newc = c
    end

    return newc
end

seeds_mat = reshape(seeds, 2, 10)
seeds_ranges = [col[1]:(col[1]+col[2]-1) for col in eachcol(seeds_mat)]
m = -1
g = 0
while m == -1
    if g % 100000 == 0 println(g) end
    humi = reverse_map_code(g, humi_loca_ranges)
    temp = reverse_map_code(humi, temp_humi_ranges)
    ligh = reverse_map_code(temp, ligh_temp_ranges)
    wate = reverse_map_code(ligh, wate_ligh_ranges)
    fert = reverse_map_code(wate, fert_wate_ranges)
    soil = reverse_map_code(fert, soil_fert_ranges)
    seed = reverse_map_code(soil, seed_soil_ranges)

    rg = filter((x) -> seed in x, seeds_ranges)
    if length(rg) > 0 m = g end
    g += 1
end

m