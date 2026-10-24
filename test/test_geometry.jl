using Test
using MEM8

@testset "Geometry" begin

    # --- Metric -------------------------------------------------------------

    @testset "Metric norm" begin
        metric = Metric.Metric(ones(4))
        v = [1.0, 2.0, 3.0, 4.0]
        @test Metric.norm(metric, v) == sum(abs.(v))
    end

    @testset "Metric scaling" begin
        metric = Metric.Metric([2.0, 2.0, 2.0, 2.0])
        v = [1.0, 1.0, 1.0, 1.0]
        @test Metric.norm(metric, v) == 8.0
    end

    # --- Connection ---------------------------------------------------------

    @testset "Parallel transport identity connection" begin
        Γ = zeros(4,4,4)
        conn = Connection.Connection(Γ)
        v = [1.0, 2.0, 3.0, 4.0]
        direction = [0.1, 0.1, 0.1, 0.1]
        transported = Connection.parallel_transport(conn, v, direction)
        @test transported == v
    end

    @testset "Parallel transport with simple connection" begin
        Γ = ones(4,4,4) .* 0.01
        conn = Connection.Connection(Γ)
        v = [1.0, 0.0, 0.0, 0.0]
        direction = [1.0, 0.0, 0.0, 0.0]
        transported = Connection.parallel_transport(conn, v, direction)
        @test transported[1] < 1.0
    end

    # --- Geodesic Solver ----------------------------------------------------

    @testset "Geodesic step identity connection" begin
        metric = Metric.Metric(ones(4))
        conn = Connection.Connection(zeros(4,4,4))
        z = zeros(4)
        v = [1.0, 0.0, 0.0, 0.0]
        dt = 0.1
        z_new, v_new = GeodesicSolver.geodesic_step(z, v, conn, dt)
        @test z_new == [0.1, 0.0, 0.0, 0.0]
        @test v_new == v
    end

    @testset "Geodesic step with curvature" begin
        Γ = ones(4,4,4) .* 0.01
        conn = Connection.Connection(Γ)
        z = zeros(4)
        v = [1.0, 1.0, 1.0, 1.0]
        dt = 0.1
        z_new, v_new = GeodesicSolver.geodesic_step(z, v, conn, dt)
        @test all(z_new .> 0.0)
        @test all(v_new .< v)
    end

    # --- Curvature Tensor ---------------------------------------------------

    @testset "Curvature tensor shape" begin
        Γ = zeros(4,4,4)
        conn = Connection.Connection(Γ)
        R = Curvature.curvature_tensor(conn)
        @test size(R) == (4,4,4,4)
    end

    @testset "Curvature tensor determinism" begin
        Γ = rand(4,4,4) .* 0.01
        conn = Connection.Connection(Γ)
        R1 = Curvature.curvature_tensor(conn)
        R2 = Curvature.curvature_tensor(conn)
        @test R1 == R2
    end

end
