module Interaction

export interaction_tensor, interaction_score

using LinearAlgebra

"""
    interaction_tensor(drift, roughness, holonomy, spectral_high)

Construct a symmetric interaction tensor capturing cross-coupling between:
- drift
- Jacobian roughness
- holonomy drift
- spectral high-band energy

This matches the unified preprint's early-stage interaction geometry.
"""
function interaction_tensor(drift::Float64,
                            roughness::Float64,
                            holonomy::Float64,
                            spectral_high::Float64)

    I = [
        drift         roughness     holonomy;
        roughness     holonomy      spectral_high;
        holonomy      spectral_high drift
    ]

    return I
end

"""
    interaction_score(I)

Compute interaction magnitude as the sum of absolute eigenvalues:

    score = sum(abs.(eigvals(I)))

This diagnostic is used by:
- membrane stability fields
- routing stability
- UOS iteration diagnostics
"""
function interaction_score(I::Matrix{Float64})
    vals = eigvals(I)
    return sum(abs.(vals))
end

end
