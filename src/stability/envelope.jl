module Envelope

export StabilityEnvelope, envelope_score, in_envelope

"""
    StabilityEnvelope(drift_th, rough_th, holonomy_th, collapse_th, interaction_th)

A stability envelope defines the safe operating region of the MEM8 manifold.

Each threshold corresponds to a diagnostic altitude:
- drift_th        : maximum allowed drift
- rough_th        : maximum allowed Jacobian roughness
- holonomy_th     : maximum allowed holonomy drift
- collapse_th     : maximum allowed collapse-risk eigenvalue
- interaction_th  : maximum allowed interaction magnitude
"""
struct StabilityEnvelope
    drift_th::Float64
    rough_th::Float64
    holonomy_th::Float64
    collapse_th::Float64
    interaction_th::Float64
end

"""
    envelope_score(env, drift, roughness, holonomy, collapse, interaction)

Compute a normalized stability score in [0, ∞).

Score < 1.0  → safe
Score = 1.0  → boundary
Score > 1.0  → unstable

This is defined as:

    score = max(
        drift/drift_th,
        roughness/rough_th,
        holonomy/holonomy_th,
        collapse/collapse_th,
        interaction/interaction_th
    )
"""
function envelope_score(env::StabilityEnvelope,
                        drift::Float64,
                        roughness::Float64,
                        holonomy::Float64,
                        collapse::Float64,
                        interaction::Float64)

    ratios = [
        drift      / env.drift_th,
        roughness  / env.rough_th,
        holonomy   / env.holonomy_th,
        collapse   / env.collapse_th,
        interaction / env.interaction_th
    ]

    return maximum(ratios)
end

"""
    in_envelope(env, drift, roughness, holonomy, collapse, interaction)

Return true if the state is inside the stability envelope.

Equivalent to:

    envelope_score < 1.0
"""
function in_envelope(env::StabilityEnvelope,
                     drift::Float64,
                     roughness::Float64,
                     holonomy::Float64,
                     collapse::Float64,
                     interaction::Float64)

    return envelope_score(env, drift, roughness, holonomy, collapse, interaction) < 1.0
end

end
