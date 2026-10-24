module MEM8

# Core geometry
include("core/manifold.jl")
include("core/metric.jl")
include("core/connection.jl")
include("core/curvature.jl")

# Diagnostic operators
include("operators/drift.jl")
include("operators/jacobian.jl")
include("operators/collapse_tensor.jl")
include("operators/spectral.jl")
include("operators/holonomy.jl")

# Geodesic engine
include("geodesic/geodesic_solver.jl")
include("geodesic/deviation.jl")
include("geodesic/correction.jl")

# Membrane
include("membrane/envelope.jl")
include("membrane/stability_field.jl")
include("membrane/membrane.jl")

# Routing
include("routing/routes.jl")
include("routing/routing.jl")
include("routing/flow.jl")

# Unified Operator Stack
include("uos/uos.jl")
include("uos/trace.jl")

# Runtime state
include("state/state.jl")
include("state/evolution.jl")

end
