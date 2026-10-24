module Geodesics

using LinearAlgebra
using StaticArrays

export geodesic_step

"""
    geodesic_step(z, flow, projection, dt)

Compute a single geodesic-informed motion step.

This operator integrates:
- routing flow fields (curvature-aware direction)
- inward projection (membrane safety)
- step size dt (deterministic integration)

The result is a new state z' that follows a curvature-aware trajectory
while respecting membrane constraints.

All operations are deterministic and use StaticArrays for stability.
"""
function geodesic_step(z::AbstractVector{Float64},
                       flow::AbstractVector{Float64},
                       projection::AbstractVector{Float64},
                       dt::Float64)

    n = length(z)
    z = SVector{n}(z)
    f = SVector{n}(flow)
    p = SVector{n}(projection)

    # Combine flow + projection
    direction = f + p

    # Normalize direction for stability
    dir_norm = norm(direction)
    if dir_norm > 0
        direction = direction / dir_norm
    end

    # Geodesic step
    z_new = z + dt * direction

    return z_new
end

end # module
