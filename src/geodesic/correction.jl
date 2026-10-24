module Correction

export geodesic_correction

using ..Metric
using ..Deviation

"""
    geodesic_correction(metric, z, γ; gain=0.1)

Compute a correction vector Δz that pulls the semantic state `z`
toward the predicted geodesic position `γ`.

Correction is defined as:

    Δz = -gain * (z - γ)

The magnitude of the correction is proportional to geodesic deviation:

    deviation = ‖z - γ‖_m

This operator is used by:
- membrane projection
- routing geometry
- collapse-risk prediction
- UOS iteration correction
"""
function geodesic_correction(metric::Metric.Metric,
                             z::Vector{Float64},
                             γ::Vector{Float64};
                             gain::Float64=0.1)

    diff = z .- γ
    deviation = Deviation.geodesic_deviation(metric, z, γ)

    # Correction vector scaled by deviation
    Δz = -gain .* diff

    return Δz, deviation
end

end
