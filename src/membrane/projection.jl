module Projection

using LinearAlgebra
using StaticArrays

export inward_projection

"""
    inward_projection(z, membrane_env)

Compute an inward-pointing projection vector that pushes the state `z`
back inside the membrane envelope if any component exceeds its threshold.

This operator is part of the safety altitude and ensures that routing
and geodesic motion remain inside the stability envelope.

All operations are deterministic and use StaticArrays for stability.
"""
function inward_projection(z::AbstractVector{Float64},
                           membrane_env::AbstractVector{Float64})

    n = length(z)
    z = SVector{n}(z)
    env = SVector{n}(membrane_env)

    proj = zeros(Float64, n)

    for i in 1:n
        if z[i] > env[i]
            # Push inward proportionally to the violation
            proj[i] = -(z[i] - env[i])
        else
            proj[i] = 0.0
        end
    end

    return SVector{n}(proj)
end

end # module
