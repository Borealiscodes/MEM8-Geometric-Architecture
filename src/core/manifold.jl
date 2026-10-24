module Manifold

export Chart, Manifold, TangentVector, coordinate, to_tangent

"""
    Chart(name, dim)

A coordinate chart on the MEM8 manifold.
`name` is a symbol identifying the chart.
`dim` is the dimensionality of the coordinate system.
"""
struct Chart
    name::Symbol
    dim::Int
end

"""
    Manifold(charts)

A smooth manifold composed of a collection of coordinate charts.
Charts must be compatible and cover the semantic space.
"""
struct Manifold
    charts::Vector{Chart}
end

"""
    TangentVector(x)

A tangent vector at a point on the manifold.
Internally represented as a static vector for deterministic geometry.
"""
struct TangentVector
    x::Vector{Float64}
end

"""
    coordinate(chart, point)

Project a semantic point into the coordinate system of a chart.
For now, this is identity; later, charts may define nonlinear transforms.
"""
function coordinate(chart::Chart, point::Vector{Float64})
    return point[1:chart.dim]
end

"""
    to_tangent(point)

Convert a semantic point into a tangent vector.
This is the canonical representation used by all geometric operators.
"""
to_tangent(point::Vector{Float64}) = TangentVector(point)

end
