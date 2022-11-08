using Statistics

v = map(x->parse(Int64, x), split(readline(), ","))
u = abs.(v .- mean(v))
w = u .* (u .+ 1) ./ 2
ans = sum(w)
println(ans)
