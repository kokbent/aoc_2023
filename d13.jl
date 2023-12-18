doc = readlines("./puzzle/d13.txt")
doc01 = replace.(doc, "." => "0", "#" => "1")
blank_line = findall(doc01 .== "")
ranges = []
for i in eachindex(blank_line)
    if i == 1
        push!(ranges, 1:(blank_line[i]-1))
    else
        push!(ranges, (blank_line[i-1]+1):(blank_line[i]-1))
    end
end
push!(ranges, (blank_line[length(blank_line)]+1):length(doc01))
patterns = [doc01[r] for r in ranges]

same_adj(mat, i) = return all(mat[i+1,:] .== mat[i,:])

function find_reflection(mat)
    same_adj_ind = findall([same_adj(mat, i) for i in 1:(size(mat)[1]-1)])
    nrow = size(mat)[1]
    ncol = size(mat)[2]

    for i in same_adj_ind
        if length(1:i) < length((i+1):nrow)
            bs = mat[1:1:i,:] .== mat[(i+length(1:i)):-1:(i+1),:]
        else
            bs = mat[nrow:-1:(i+1),:] .== mat[(i+1-length((i+1):nrow)):1:i,:]
        end
        if all(bs)
            return i
        end
    end
    return Nothing
end

scores = []
for p in patterns
    p_int = [parse.(Int8, p_sp) for p_sp in split.(p, "")]
    mat = reduce(vcat, transpose(p_int))
    score_horizontal = find_reflection(mat)
    score_vertical = find_reflection(transpose(mat))
    println("$score_horizontal\t$score_vertical")
    score = score_horizontal === Nothing ? score_vertical : (score_horizontal * 100)
    push!(scores, score)
end

sum(scores)

####
function find_new_reflection(mat)
    nrow = size(mat)[1]
    ncol = size(mat)[2]

    for i in 1:nrow
        if length(1:i) < length((i+1):nrow)
            bs = mat[1:1:i,:] .== mat[(i+length(1:i)):-1:(i+1),:]
        else
            bs = mat[nrow:-1:(i+1),:] .== mat[(i+1-length((i+1):nrow)):1:i,:]
        end
        if sum(bs) == length(bs) - 1
            return i
        end
    end
    return Nothing
end

scores = []
for p in patterns
    p_int = [parse.(Int8, p_sp) for p_sp in split.(p, "")]
    mat = reduce(vcat, transpose(p_int))
    score_horizontal = find_new_reflection(mat)
    score_vertical = find_new_reflection(transpose(mat))
    println("$score_horizontal\t$score_vertical")
    score = score_horizontal === Nothing ? score_vertical : (score_horizontal * 100)
    push!(scores, score)
end

sum(scores)