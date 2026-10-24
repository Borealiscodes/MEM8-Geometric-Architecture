module GeodesicSolver

export geodesic_step

geodesic_step(γ, v, dt) = γ .+ v .* dt

end
