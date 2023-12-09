times = [53, 71, 78, 80]
distances = [275, 1181, 1215, 1524]

function quadratic_roots(a, b, c)
    d = sqrt(b^2 - 4*a*c)
    return ((-b - d)/2a, (-b + d)/2a)
end

function calc_int_between(tup)
    newtup = (ceil(tup[1]), floor(tup[2]))
    return newtup[2] - newtup[1] + 1
end

calc_int_between(quadratic_roots(1, -times[1], distances[1]))

roots = [quadratic_roots(1, -z[1], z[2]) for z in zip(times, distances)]
nways = [calc_int_between(r) for r in roots]
prod(nways)

####
root = quadratic_roots(1, -53717880, 275118112151524)
nway = calc_int_between(root)

using Printf
@printf "%.f \n" nway