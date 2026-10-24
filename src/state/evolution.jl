module Evolution

export evolve

evolve(state, r) = State(state.z .+ r.v)

end
