module GeodesicSolver

export geodesic_step

using ..Connection
using ..Metric

"""
    geodesic_step(z, v, conn, dt)

Compute a first-order geodesic step from point `z` with tangent vector `v`
using the connection Γ and step size `dt`.

This implements the simplified geodesic equation:

    z' = z + v * dt
    v' = v - Γᵢⱼₖ vⱼ vₖ dt

This is the early-stage geodesic integrator described in the unified preprint.
It is sufficient for:
- membrane projection
- routing geometry
- collapse-risk prediction
- UOS iteration diagnostics
"""
function geodesic_step(z::Vector{Float64},
                       v::Vector{Float64},
                       conn::Connection.Connection,
                       dt::Float64)

    n = length(z)

    # Update position: z' = z + v * dt
    new_z = z .+ v .* dt

    # Update tangent vector: v' = v - Γᵢⱼₖ vⱼ vₖ dt
    new_v = zeros(Float64, n)
    for i in 1:n
        correction = 0.0
        for j in 1:n
            for k in 1:n
                correction += conn.Γ[i,j,k] * v[j] * v[k]
            end
        end
        new_v[i] = v[i] - correction * dt
    end

    return new_z, new_v
end

end
