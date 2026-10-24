module CollapseTensor

export collapse_risk, collapse_tensor

using LinearAlgebra

"""
    collapse_tensor(drift, roughness, holonomy)

Construct a first-order collapse-risk tensor T from:
- drift
- Jacobian roughness
- holonomy drift

This matches the unified preprint's early-stage collapse-risk approximation:

    T = α * drift + β * roughness + γ * holonomy

For now, α = β = γ = 1.0 (simple weighting).
Later versions may use learned or adaptive weights.
"""
function collapse_tensor(drift::Float64,
                         roughness::Float64,
                         holonomy::Float64)

    # Simple 3x3 tensor for early-stage diagnostics
    T = [
        drift      roughness  holonomy;
        roughness  holonomy   drift;
        holonomy   drift      roughness
    ]

    return T
end

"""
    collapse_risk(T)

Compute collapse-risk as the maximum eigenvalue of the collapse tensor T.

This diagnostic is used by:
- membrane stability fields
- membrane projection
- routing stability
- UOS iteration diagnostics
"""
function collapse_risk(T::Matrix{Float64})
    vals = eigvals(T)
    return maximum(vals)
end

end
