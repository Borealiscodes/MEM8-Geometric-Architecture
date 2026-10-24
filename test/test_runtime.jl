using Test
using MEM8

# Minimal geometry
metric = Metric.Metric(ones(8))
conn   = Connection.Connection(zeros(8,8,8))

# Envelope with tight thresholds to force halting
env_tight = Stability.Envelope.StabilityEnvelope(
    0.1,   # drift
    0.1,   # roughness
    0.1,   # holonomy
    0.1,   # collapse-risk
    0.1    # interaction
)

# Envelope with generous thresholds to allow long runs
env_loose = Stability.Envelope.StabilityEnvelope(
    10.0,
    10.0,
    10.0,
    10.0,
    10.0
)

# Initial state
z0 = zeros(8)
state0 = State.new_state(z0)

@testset "Runtime Loop" begin

    @testset "Halts on envelope violation" begin
        final_state, iters, reason = RuntimeLoop.run_uos(
            state0, metric, conn, env_tight; dt=0.01, max_iters=50
        )
        @test reason == "Envelope violation"
        @test iters >= 1
    end

    @testset "Halts on collapse-risk threshold" begin
        # Artificially force collapse-risk by injecting large drift
        bad_state = State.new_state(fill(100.0, 8))
        final_state, iters, reason = RuntimeLoop.run_uos(
            bad_state, metric, conn, env_tight; dt=0.01, max_iters=50
        )
        @test reason == "Collapse-risk threshold exceeded"
    end

    @testset "Halts on max iterations" begin
        final_state, iters, reason = RuntimeLoop.run_uos(
            state0, metric, conn, env_loose; dt=0.01, max_iters=5
        )
        @test reason == "Max iterations reached"
        @test iters == 5
    end

    @testset "Final state is deterministic" begin
        f1, _, _ = RuntimeLoop.run_uos(state0, metric, conn, env_loose; dt=0.01, max_iters=10)
        f2, _, _ = RuntimeLoop.run_uos(state0, metric, conn, env_loose; dt=0.01, max_iters=10)
        @test f1.z == f2.z
    end

end
