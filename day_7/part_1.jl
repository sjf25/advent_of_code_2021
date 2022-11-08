using Statistics

v = map(x->parse(Int64, x), split(readline(), ","))
ans = sum(abs.(v .- median(v)))
println(ans)
