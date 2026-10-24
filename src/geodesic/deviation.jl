module Deviation

export geodesic_deviation

using ..Metric

"""
    geodesic_deviation(metric, z, γ)

Compute geodesic deviation between the actual semantic vector `z`
and the predicted geodesic position `γ`.

Deviation is defined as the metric norm:

    deviation = ‖z - γ‖_m

This diagnostic is used by:
- geodesic correction
- collapse-risk prediction
- membrane stability fields
- routing stability
- UOS iteration diagnostics
"""
function geodesic_deviation(metric::Metric.Metric,
                            z::Vector{Float64},
                            γ::Vector{Float64})

    diff = z .- γ
    return Metric.norm(metric, diff)
end

end
