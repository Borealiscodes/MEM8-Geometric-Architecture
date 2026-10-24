module Step

using StaticArrays
using LinearAlgebra

using ..State: MEM8State
using ..Diagnostics: compute_drift, compute_roughness, compute_holonomy
using ..CollapseGradient: collapse_gradient
using ..Deformation: deform_membrane
using ..Projection: inward_projection
using ..FlowFields: routing_flow
using ..Geodesics: geodesic_step

export step!

"""
    step!(state, dt)

Deterministic altitude-aligned update loop for MEM8.
"""
function step!(state::MEM8State{N}, dt::Float64) where {N}

    # --- Diagnostic altitude ---
    drift      = compute_drift(state)
    roughness  = compute_roughness(state)
    holonomy   = compute_holonomy(state)
    collapse   = collapse_gradient(state)

    # --- Safety altitude ---
    new_env    = deform_membrane(state.membrane_env, drift, roughness, holonomy)
    proj       = inward_projection(state.z, new_env)

    # --- Motion altitude ---
    flow       = routing_flow(state, collapse)
    z_new      = geodesic_step(state.z, flow, proj, dt)

    # --- Return updated state ---
    return MEM8State{N}(
        z_new,
        state.metric,
        state.connection,
        state.curvature,
        drift,
        roughness,
        holonomy,
        collapse,
        new_env,
        flow
    )
end

end # module
