doc = readlines("./puzzle/d8.txt")

function lr_instruction_dict(s)
    reg = r"([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)"
    m = collect(match(reg, s))
    
    return [m[1], (m[2], m[3])]
end

d1 = [lr_instruction_dict(s) for s in doc[3:length(doc)]]
lr_dict = Dict((k, v) for (k, v) in d1)

lrs = split(doc[1], "")
lrs = [c == "L" ? 1 : 2 for c in lrs]

pos = "AAA"
step = 0
while pos != "ZZZ"
    step += 1
    ind = step % length(lrs)
    ind = ind == 0 ? length(lrs) : ind
    lr = lrs[ind]
    pos = lr_dict[pos][lr]
end
step

####
ks = collect(keys(lr_dict))
start_pos = ks[[k[3] == 'A' for k in ks]]
end_pos = ks[[k[3] == 'Z' for k in ks]]
pos = "HCA"
step = 0
while pos != "ZZZ"
    step += 1
    ind = step % length(lrs)
    ind = ind == 0 ? length(lrs) : ind
    lr = lrs[ind]
    pos = lr_dict[pos][lr]
end
while !all_z(poses)
    step += 1
    ind = step % length(lrs)
    ind = ind == 0 ? length(lrs) : ind
    lr = lrs[ind]
    poses = [lr_dict[p][lr] for p in poses]
end