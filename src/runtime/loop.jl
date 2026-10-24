module RuntimeLoop

export run_uos

using ..UOS
using ..State
using ..Stability.Envelope

"""
    run_uos(initial_state, metric, conn, env; dt=0.01, max_iters=100)

Run the MEM8 Unified Operator Stack (UOS) repeatedly until:
- stability envelope is violated
- collapse-risk exceeds its threshold
- iteration limit is reached

Returns:
- final_state
- iteration_count
- halted_reason (String)
"""
function run_uos(initial_state::State.State,
                 metric,
                 conn,
                 env::Envelope.StabilityEnvelope;
                 dt::Float64=0.01,
                 max_iters::Int=100)

    state = initial_state

    for iter in 1:max_iters

        # Run one UOS iteration
        new_state = UOS.uos_step(state, metric, conn, env, dt)

        # Extract diagnostics
        drift        = new_state.drift
        roughness    = Jacobian.jacobian_roughness(new_state.z)
        holonomy     = new_state.holonomy
        collapse     = new_state.collapse
        interaction  = new_state.interaction

        # Envelope membership
        inside = Envelope.in_envelope(env, drift, roughness, holonomy, collapse, interaction)

        if !inside
            return new_state, iter, "Envelope violation"
        end

        # Collapse-risk hard stop
        if collapse > env.collapse_th
            return new_state, iter, "Collapse-risk threshold exceeded"
        end

        # Continue iteration
        state = new_state
    end

    return state, max_iters, "Max iterations reached"
end

end
