doc = readlines("./puzzle/d16.txt")

nrow = length(doc)
ncol = length(doc[1])

function new_xy(x, y, d)
    if d == "u"
        y -= 1
    elseif d == "d"
        y += 1
    elseif d == "l"
        x -= 1
    elseif d == "r"
        x += 1
    end

    return x, y
end

function valid_xy(x, y) return (y in 1:nrow) & (x in 1:ncol) end

function action(char, d)
    if char == '.'
        return ("cont", d)
    elseif char == '\\'
        d == "u" && return ("cont", "l")
        d == "d" && return ("cont", "r")
        d == "l" && return ("cont", "u")
        d == "r" && return ("cont", "d")
    elseif char == '/'
        d == "u" && return ("cont", "r")
        d == "d" && return ("cont", "l")
        d == "l" && return ("cont", "d")
        d == "r" && return ("cont", "u")
    elseif char == '|'
        ((d == "u") | (d == "d")) && return ("cont", d)
        ((d == "l") | (d == "r")) && return ("split", "ud")
    elseif char == '-'
        ((d == "l") | (d == "r")) && return ("cont", d)
        ((d == "u") | (d == "d")) && return ("split", "lr")
    end
end

function travel(start_xy, direction)
    x, y = start_xy
    next_step = "cont"

    travelled = []
    while next_step == "cont"
        x, y = new_xy(x, y, direction)
        if !valid_xy(x, y)
            next_step = "oob"
            break
        elseif ((x, y), direction) in travelled
            next_step = "infloop"
            break
        else
            push!(travelled, ((x, y), direction))
            tile = doc[y][x]
        end
        next_step, direction = action(tile, direction)
    end

    travelled = [t[1] for t in travelled]
    if (next_step == "oob") | (next_step == "infloop")
        return [travelled, []]
    elseif next_step == "split"
        if direction == "ud"
            return([travelled, [((x, y), "u"), ((x, y), "d")]])
        else
            return([travelled, [((x, y), "l"), ((x, y), "r")]])
        end
    end
end

function beam(coord, direction)
    x, y = coord
    queue1 = [((x, y), direction)]
    travelled = []
    history = []

    while length(queue1) > 0
        coord, d = queue1[1]
        if (coord, d) in history
            popfirst!(queue1)
            continue
        else
            trav, branch = travel(coord, d)
            queue1 = [queue1; branch]
            travelled = [travelled; trav]
            push!(history, queue1[1])
            popfirst!(queue1)
        end
    end

    return length(unique(travelled))
end

beam((0, 1), "r")

####
total_energized = []
for i in 1:nrow
    n = beam((0, i), "r")
    push!(total_energized, n)
    n = beam((ncol+1, i), "l")
    push!(total_energized, n)
end

for i in 1:ncol
    n = beam((i, 0), "d")
    push!(total_energized, n)
    n = beam((i, nrow+1), "u")
    push!(total_energized, n)
end
maximum(total_energized)