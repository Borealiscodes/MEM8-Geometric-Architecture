module Metric

export Metric, inner, norm

struct Metric
    G::Matrix{Float64}
end

inner(m::Metric, x, y) = x' * m.G * y
norm(m::Metric, x) = sqrt(inner(m, x, x))

end
