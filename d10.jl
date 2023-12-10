doc = readlines("puzzle/d10.txt")

stx = 119
sty = 103

tiles_dict = Dict(
    '|' => ['N', 'S'],
    '-' => ['E', 'W'],
    'L' => ['E', 'N'],
    'J' => ['N', 'W'],
    '7' => ['S', 'W'],
    'F' => ['S', 'E'],
)

function new_xy(x, y, dir)
    newx = x
    newy = y
    if dir == 'W'
        newx -= 1
        invdir = 'E'
    elseif dir == 'S'
        newy += 1
        invdir = 'N'
    elseif dir == 'E'
        newx += 1
        invdir = 'W'
    else
        newy -= 1
        invdir = 'S'
    end
    return newx, newy, invdir
end


newdir = 'S'
newx, newy, invdir = new_xy(stx, sty, newdir)
nstep = 1
dirs = []
xs = [stx]
ys = [sty]

while !(newx == stx && newy == sty)
    push!(dirs, newdir)
    push!(xs, newx)
    push!(ys, newy)
    newtile = doc[newy][newx]
    dirs_avail = tiles_dict[newtile]
    newdir = dirs_avail[[!(d in invdir) for d in dirs_avail]][1]
    newx, newy, invdir = new_xy(newx, newy, newdir)
    nstep += 1
end

####
using Luxor
using Plots

polygon = Point.(xs, ys)
plot(Tuple.(polygon), legend=false)

