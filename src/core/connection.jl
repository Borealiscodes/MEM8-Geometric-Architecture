module Connection

export Connection, christoffel

struct Connection
    Γ::Array{Float64,3}
end

christoffel(conn::Connection, i, j, k) = conn.Γ[i,j,k]

end
