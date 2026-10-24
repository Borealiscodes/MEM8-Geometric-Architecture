module FlowFields

using LinearAlgebra
using StaticArrays

export routing_flow_field

"""
    routing_flow_field(R, grad, membrane_env, drift, roughness, holonomy)

Construct a deterministic routing flow field using:

- curvature decomposition (Ricci, scalar, sectional)
- collapse-risk gradient
- membrane deformation (tightened envelope)
- drift, roughness, holonomy diagnostics

This operator produces a continuous routing vector that guides
semantic motion away from collapse surfaces and toward stable regions.

All operations are deterministic and use StaticArrays for stability.
"""
function routing_flow_field(R::Array{Float64,4},
                            grad::AbstractVector{Float64},
                            membrane_env::AbstractVector{Float64},
                            drift::AbstractVector{Float64},
                            roughness::AbstractVector{Float64},
                            holonomy::AbstractVector{Float64})

    n = length(grad)

    # Convert to StaticArrays
    grad      = SVector{n}(grad)
    drift     = SVector{n}(drift)
    roughness = SVector{n}(roughness)
    holonomy  = SVector{n}(holonomy)

    # --- Curvature contributions ---
    Ric = ricci_tensor(R)
    scalar = sum(diag(Ric))
    K = sectional_curvature(R, ones(n), reverse(ones(n)))

    # Curvature vector (Ricci contraction)
    curv_vec = ricci_vector(Ric)

    # --- Diagnostic magnitudes ---
    drift_mag    = norm(drift)
    rough_mag    = norm(roughness)
    holonomy_mag = norm(holonomy)
    grad_mag     = norm(grad)

    # --- Membrane influence ---
    # Tighter membrane → stronger push away from collapse-risk
    membrane_factor = 1.0 / (1.0 + sum(membrane_env))

    # --- Flow field construction ---
    # Combine geometric + diagnostic + membrane signals
    flow = SVector{n}(
        # curvature pushes toward stable regions
        (-scalar .* curv_vec) +
        # collapse-risk gradient pushes away from collapse surfaces
        (-grad_mag .* grad) +
        # membrane pushes inward
        (membrane_factor .* (-grad)) +
        # diagnostics push toward stability
        (-drift_mag .* drift) +
        (-rough_mag .* roughness) +
        (-holonomy_mag .* holonomy)
    )

    # Normalize for stability
    flow_norm = norm(flow)
    if flow_norm > 0
        flow = flow / flow_norm
    end

    return flow
end


# --- Utility functions ---

function ricci_tensor(R::Array{Float64,4})
    n = size(R,1)
    Ric = zeros(Float64, n, n)
    for i in 1:n
        for j in 1:n
            s = 0.0
            for k in 1:n
                s += R[k,i,k,j]
            end
            Ric[i,j] = s
        end
    end
    return Ric
end

function ricci_vector(Ric::Array{Float64,2})
    n = size(Ric,1)
    v = zeros(Float64, n)
    for i in 1:n
        v[i] = sum(Ric[i, :])
    end
    return SVector{n}(v)
end

function sectional_curvature(R::Array{Float64,4},
                             u::AbstractVector{Float64},
                             v::AbstractVector{Float64})

    u = SVector{length(u)}(u)
    v = SVector{length(v)}(v)

    Ru_v = zero(u)
    for i in 1:length(u)
        for j in 1:length(u)
            for k in 1:length(u)
                for l in 1:length(u)
                    Ru_v = Ru_v + R[i,j,k,l] * u[j] * v[k] * v[l] * SVector{length(u)}(unit(i, length(u)))
                end
            end
        end
    end

    numerator = dot(Ru_v, u)
    denom = (dot(u,u) * dot(v,v)) - (dot(u,v)^2)

    return numerator / denom
end

unit(i, n) = SVector{n}([j == i ? 1.0 : 0.0 for j in 1:n])

end # module
