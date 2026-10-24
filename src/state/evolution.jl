module Evolution

export evolve_state

using ..State

"""
    evolve_state(state, Δz; spectral=nothing, curvature=nothing,
                 drift=nothing, holonomy=nothing,
                 collapse=nothing, interaction=nothing)

Deterministically evolve the MEM8 runtime state by applying a semantic update Δz.

This function is intentionally minimal:
- It updates the semantic vector: z' = z + Δz
- It optionally updates geometric diagnostics
- It returns a *new* immutable State instance

All higher-level operators (membrane, routing, geodesics, UOS)
call this function to produce the next iteration of the runtime.
"""
function evolve_state(state::State.State,
                      Δz::Vector{Float64};
                      spectral::Union{Nothing,Vector{Float64}}=nothing,
                      curvature::Union{Nothing,Dict{Symbol,Float64}}=nothing,
                      drift::Union{Nothing,Float64}=nothing,
                      holonomy::Union{Nothing,Float64}=nothing,
                      collapse::Union{Nothing,Float64}=nothing,
                      interaction::Union{Nothing,Float64}=nothing)

    # Update semantic position
    new_z = state.z .+ Δz

    # Preserve previous diagnostics unless explicitly updated
    new_spectral    = spectral    === nothing ? state.spectral    : spectral
    new_curvature   = curvature   === nothing ? state.curvature   : curvature
    new_drift       = drift       === nothing ? state.drift       : drift
    new_holonomy    = holonomy    === nothing ? state.holonomy    : holonomy
    new_collapse    = collapse    === nothing ? state.collapse    : collapse
    new_interaction = interaction === nothing ? state.interaction : interaction

    return State.new_state(new_z;
        spectral=new_spectral,
        curvature=new_curvature,
        drift=new_drift,
        holonomy=new_holonomy,
        collapse=new_collapse,
        interaction=new_interaction
    )
end

end
