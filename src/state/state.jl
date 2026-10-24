module State

export State, new_state

"""
    State(z, spectral, curvature, drift, holonomy, collapse, interaction)

The MEM8 runtime state is an immutable container holding all geometric
diagnostics for a single iteration of the Unified Operator Stack (UOS).

Fields:
- `z`           : semantic vector (point on the manifold)
- `spectral`    : spectral bundles (FFT-based multi-resolution geometry)
- `curvature`   : curvature diagnostics (sectional, Ricci, scalar)
- `drift`       : curvature drift between iterations
- `holonomy`    : holonomy drift diagnostics
- `collapse`    : collapse-risk tensor eigenvalues
- `interaction` : interaction tensor eigenvalues

This structure is intentionally minimal and deterministic.
All operators update the state by producing a *new* State instance.
"""
struct State
    z::Vector{Float64}
    spectral::Vector{Float64}
    curvature::Dict{Symbol, Float64}
    drift::Float64
    holonomy::Float64
    collapse::Float64
    interaction::Float64
end

"""
    new_state(z; spectral=[], curvature=Dict(), drift=0.0, holonomy=0.0,
              collapse=0.0, interaction=0.0)

Construct a new MEM8 runtime state with optional geometric diagnostics.
This function is used by the UOS to produce updated states each iteration.
"""
function new_state(z::Vector{Float64};
                   spectral::Vector{Float64}=Float64[],
                   curvature::Dict{Symbol,Float64}=Dict{Symbol,Float64}(),
                   drift::Float64=0.0,
                   holonomy::Float64=0.0,
                   collapse::Float64=0.0,
                   interaction::Float64=0.0)

    return State(z, spectral, curvature, drift, holonomy, collapse, interaction)
end

end
