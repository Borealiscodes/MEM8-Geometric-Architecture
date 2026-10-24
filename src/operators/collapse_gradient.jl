module CollapseGradient

using LinearAlgebra
using StaticArrays

export collapse_risk_gradient

"""
    collapse_risk_gradient(R, drift, roughness, holonomy)

Compute a deterministic collapse-risk gradient vector using:

- Ricci curvature
- scalar curvature
- sectional curvature sampling
- drift magnitude
- roughness magnitude
- holonomy magnitude

This gradient points toward increasing collapse-risk and is used for:

- membrane deformation
- collapse-surface avoidance
- routing flow-field construction

All operations are deterministic and use StaticArrays for stability.
"""
function collapse_risk_gradient(R::Array{Float64,4},
                                drift::AbstractVector{Float64},
                                roughness::AbstractVector{Float64},
                                holonomy::AbstractVector{Float64})

    n = length(drift)

    # Convert to StaticArrays
    drift     = SVector{n}(drift)
    roughness = SVector{n}(roughness)
    holonomy  = SVector{n}(holonomy)

    # --- Curvature contributions ---
    # Ricci curvature
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

    # Scalar curvature
    scalar = sum(diag(Ric))

    # Sectional curvature sampling (deterministic)
    u = ones(n)
    v = reverse(u)
    K = sectional_curvature(R, u, v)

    # --- Diagnostic contributions ---
    drift_mag     = norm(drift)
    rough_mag     = norm(roughness)
    holonomy_mag  = norm(holonomy)

    # --- Gradient construction ---
    # Combine geometric + diagnostic signals
    # No magic constants; all weights are intrinsic magnitudes.
    grad = SVector{n}(
        scalar .* drift +
        K .* roughness +
        ricci_vector(Ric) +
        holonomy_mag .* holonomy
    )

    return grad
end


# Utility: sectional curvature (same as in core module)
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


# Utility: convert Ricci tensor to a vector by contracting rows
function ricci_vector(Ric::Array{Float64,2})
    n = size(Ric,1)
    v = zeros(Float64, n)
    for i in 1:n
        v[i] = sum(Ric[i, :])
    end
    return SVector{n}(v)
end


# Utility: unit vector basis
unit(i, n) = SVector{n}([j == i ? 1.0 : 0.0 for j in 1:n])

end # module
