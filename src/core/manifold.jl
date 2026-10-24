module Manifold

export Manifold, Chart

struct Chart
    coords::Symbol
end

struct Manifold
    charts::Vector{Chart}
end

end
