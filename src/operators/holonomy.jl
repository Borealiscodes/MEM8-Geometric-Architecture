module Holonomy

export holonomy_drift

using ..Connection

"""
    holonomy_drift(conn, v, direction)

Compute holonomy drift by parallel transporting a tangent vector `v`
along a direction vector `direction` using the connection Γ.

Holonomy drift is defined as:

    drift = ‖v - PT(v)‖

where PT(v) is the parallel-transported vector.

This diagnostic is used by:
- collapse-risk
- membrane stability fields
- routing stability
- UOS iteration diagnostics
"""
function holonomy_drift(conn::Connection.Connection,
                        v::Vector{Float64},
                        direction::Vector{Float64})

    # Parallel transport using the connection
    transported = Connection.parallel_transport(conn, v, direction)

    # Holonomy drift magnitude
    drift = sum(abs.(v .- transported))

    return drift
end

end
