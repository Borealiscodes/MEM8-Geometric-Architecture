module Router

export routing_direction

using ..Stability.Envelope
using ..Metric

"""
    routing_direction(metric, env, z, γ, drift, roughness, holonomy, collapse, interaction)

Compute a safe routing direction vector v.

Base direction:
    v = γ - z

Safety scaling:
- If inside the envelope:
      v_scaled = v * (1 / (1 + interaction))
- If outside the envelope:
      v_scaled = v * (1 / (1 + collapse))

This ensures:
- high interaction → smaller steps
- high collapse-risk → much smaller steps
- safe regions → normal geodesic motion

Returns the safe direction vector v_scaled.
"""
function routing_direction(metric::Metric.Metric,
                           env::Envelope.StabilityEnvelope,
                           z::Vector{Float64},
                           γ::Vector{Float64},
                           drift::Float64,
                           roughness::Float64,
                           holonomy::Float64,
                           collapse::Float64,
                           interaction::Float64)

    # Base geodesic direction
    v = γ .- z

    # Envelope membership
    safe = Envelope.in_envelope(env, drift, roughness, holonomy, collapse, interaction)

    if safe
        # Interaction controls step size in safe regions
        scale = 1.0 / (1.0 + interaction)
    else
        # Collapse-risk controls step size in unsafe regions
        scale = 1.0 / (1.0 + collapse)
    end

    v_scaled = v .* scale

    return v_scaled
end

end
