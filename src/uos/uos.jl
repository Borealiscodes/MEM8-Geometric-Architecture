module UOS

export uos_step

using ..State
using ..Spectral
using ..Holonomy
using ..Drift
using ..Jacobian
using ..CollapseTensor
using ..Interaction
using ..GeodesicSolver
using ..Deviation
using ..Correction
using ..Stability.Envelope
using ..MembraneProjection
using ..Router
using ..Metric
using ..Connection

"""
    uos_step(state, metric, conn, env, dt)

Run one full iteration of the Unified Operator Stack (UOS).

Pipeline:
1. Spectral bundles
2. Holonomy drift
3. Drift
4. Jacobian roughness
5. Collapse-risk tensor + score
6. Interaction tensor + score
7. Geodesic prediction
8. Geodesic deviation
9. Geodesic correction
10. Membrane projection
11. Routing direction
12. State evolution

Returns the new State instance.
"""
function uos_step(state::State.State,
                  metric::Metric.Metric,
                  conn::Connection.Connection,
                  env::Envelope.StabilityEnvelope,
                  dt::Float64)

    z = state.z

    # 1. Spectral bundles
    spectral = Spectral.spectral_bundles(z)
    spectral = Spectral.normalize_bundles(spectral)
    spectral_high = spectral[end]

    # 2. Holonomy drift
    direction = rand(length(z)) .* 0.01  # small probe direction
    hol = Holonomy.holonomy_drift(conn, z, direction)

    # 3. Drift
    d = Drift.drift(z, state.z)

    # 4. Jacobian roughness
    rough = Jacobian.jacobian_roughness(z)

    # 5. Collapse-risk
    T = CollapseTensor.collapse_tensor(d, rough, hol)
    collapse = CollapseTensor.collapse_risk(T)

    # 6. Interaction geometry
    I = Interaction.interaction_tensor(d, rough, hol, spectral_high)
    interaction = Interaction.interaction_score(I)

    # 7. Geodesic prediction
    v0 = rand(length(z)) .* 0.01
    γ, v_pred = GeodesicSolver.geodesic_step(z, v0, conn, dt)

    # 8. Geodesic deviation
    deviation = Deviation.geodesic_deviation(metric, z, γ)

    # 9. Geodesic correction
    Δz_corr, _ = Correction.geodesic_correction(metric, z, γ)

    # 10. Membrane projection
    z_mem = MembraneProjection.membrane_project(
        metric, env, z, γ, d, rough, hol, collapse, interaction
    )

    # 11. Routing direction
    v_route = Router.routing_direction(
        metric, env, z_mem, γ, d, rough, hol, collapse, interaction
    )

    # 12. State evolution
    new_state = State.new_state(
        z_mem .+ v_route;
        spectral=spectral,
        curvature=Dict(:collapse => collapse),
        drift=d,
        holonomy=hol,
        collapse=collapse,
        interaction=interaction
    )

    return new_state
end

end
