using Test
using MEM8

# Construct minimal geometry
metric = Metric.Metric(ones(8))
conn   = Connection.Connection(zeros(8,8,8))

# Stability envelope with generous thresholds
env = Stability.Envelope.StabilityEnvelope(
    10.0,   # drift
    10.0,   # roughness
    10.0,   # holonomy
    10.0,   # collapse-risk
    10.0    # interaction
)

# Initial state
z0 = zeros(8)
state0 = State.new_state(z0)

@testset "UOS Pipeline" begin

    @testset "Single UOS iteration runs without error" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        @test length(new_state.z) == 8
    end

    @testset "Spectral bundles are normalized" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        spectral = new_state.spectral
        @test abs(mean(spectral) - 1.0) < 1e-6
    end

    @testset "Collapse-risk is finite" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        @test isfinite(new_state.collapse)
    end

    @testset "Interaction score is finite" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        @test isfinite(new_state.interaction)
    end

    @testset "Membrane projection returns a valid vector" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        @test length(new_state.z) == 8
    end

    @testset "Routing direction is finite" begin
        new_state = UOS.uos_step(state0, metric, conn, env, 0.01)
        @test all(isfinite.(new_state.z))
    end

end
