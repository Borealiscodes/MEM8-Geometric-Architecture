module Metric

export Metric, inner, norm, normalize_metric, is_positive_definite

"""
    Metric(G)

A Riemannian metric represented by a symmetric, positive-definite matrix `G`.
All geometric operators (curvature, drift, holonomy, collapse-risk, geodesics)
use this metric for inner products and norms.
"""
struct Metric
    G::Matrix{Float64}
end

"""
    is_positive_definite(G)

Check whether a matrix is symmetric positive-definite.
This ensures the metric defines a valid inner product.
"""
function is_positive_definite(G::Matrix{Float64})
    issymmetric(G) && all(eigvals(G) .> 0)
end

"""
    normalize_metric(G)

Normalize a metric so that its diagonal entries are 1.0 on average.
This keeps curvature and drift numerically stable across iterations.
"""
function normalize_metric(G::Matrix{Float64})
    d = diag(G)
    scale = mean(d)
    return G ./ scale
end

"""
    inner(m, x, y)

Compute the metric inner product ⟨x, y⟩_m = xᵀ G y.
This is the fundamental operation used throughout the MEM8 geometry.
"""
inner(m::Metric, x::Vector{Float64}, y::Vector{Float64}) = x' * m.G * y

"""
    norm(m, x)

Compute the metric norm ‖x‖_m = sqrt(⟨x, x⟩_m).
Used for drift, holonomy, collapse-risk, routing, and membrane projection.
"""
norm(m::Metric, x::Vector{Float64}) = sqrt(inner(m, x, x))

end
