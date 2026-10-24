module State

using StaticArrays
using LinearAlgebra

using ..Metric: MetricTensor
using ..Connection: ConnectionCoefficients
using ..Curvature: CurvatureTensor

export MEM8State

"""
    MEM8State

Unified state container for the MEM8 geometric runtime.
This is the single altitude-aligned structure that all operators read/write.
"""
struct MEM8State{N}
    # Geometry altitude
    z::SVector{N,Float64}
    metric::MetricTensor
    connection::ConnectionCoefficients
    curvature::CurvatureTensor

    # Diagnostic altitude
    drift::SVector{N,Float64}
    roughness::SVector{N,Float64}
    holonomy::SVector{N,Float64}
    collapse_grad::SVector{N,Float64}

    # Safety altitude
    membrane_env::SVector{N,Float64}

    # Motion altitude
    flow::SVector{N,Float64}
end

end # module
