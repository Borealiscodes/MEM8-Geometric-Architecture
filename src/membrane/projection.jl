module MembraneProjection

export membrane_project

using ..Stability.Envelope
using ..Correction
using ..Metric

"""
    membrane_project(metric, env, z, γ, drift, roughness, holonomy, collapse, interaction)

Apply membrane projection to semantic state `z` using:
- stability envelope `env`
- predicted geodesic position `γ`
- diagnostic signals (drift, roughness, holonomy, collapse, interaction)

If the state is inside the envelope:
    return z unchanged

If the state is outside the envelope:
    apply geodesic correction scaled by collapse-risk:

        Δz = -gain * (z - γ) * collapse

Return the corrected semantic vector z'.
"""
function membrane_project(metric::Metric.Metric,
                          env::Envelope.StabilityEnvelope,
                          z::Vector{Float64},
                          γ::Vector{Float64},
                          drift::Float64,
                          roughness::Float64,
                          holonomy::Float64,
                          collapse::Float64,
                          interaction::Float64)

    # Check envelope membership
    safe = Envelope.in_envelope(env, drift, roughness, holonomy, collapse, interaction)

    if safe
        return z
    end

    # Compute geodesic correction (base gain = 0.1)
    Δz, deviation = Correction.geodesic_correction(metric, z, γ; gain=0.1)

    # Scale correction by collapse-risk
    scaled_Δz = Δz .* collapse

    # Apply correction
    new_z = z .+ scaled_Δz

    return new_z
end

end
