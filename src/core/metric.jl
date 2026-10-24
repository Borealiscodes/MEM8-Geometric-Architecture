module Metric

using LinearAlgebra
using StaticArrays

export MetricTensor, metric_norm

"""
    MetricTensor(g)

A metric tensor represented as a symmetric positive-definite matrix.

This is the core geometric object from which:
- norms
- inner products
- geodesics
- curvature
are derived.
"""
struct MetricTensor
    g::SMatrix{3,3,Float64}   # 3D default; can generalize later
end

"""
    metric_norm(M, x)

Compute the norm of vector x under metric M.
‖x‖ = sqrt(xᵀ g x)
"""
function metric_norm(M::MetricTensor, x::AbstractVector{Float64})
    x = SVector{length(x)}(x)
    return sqrt(dot(x, M.g * x))
end

end # module
