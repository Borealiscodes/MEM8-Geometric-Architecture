module Export

using JSON
using LinearAlgebra
using StaticArrays
using HDF5

export export_state_json,
       export_trace_json,
       export_numpy_array,
       export_hdf5_trace

"""
    export_state_json(state, path)

Export a single semantic state to JSON.

This is used by Python tools for:
- spectral inspection
- holonomy debugging
- collapse-risk visualization
- membrane probing
- routing flow-field visualization
"""
function export_state_json(state, path::String)
    data = Dict(
        "z" => collect(state.z),
        "drift" => collect(state.drift),
        "roughness" => collect(state.roughness),
        "holonomy" => collect(state.holonomy),
        "collapse_risk" => state.collapse_risk,
        "membrane_env" => collect(state.membrane_env)
    )
    open(path, "w") do io
        JSON.print(io, data)
    end
end


"""
    export_trace_json(trace, path)

Export a full runtime trace to JSON.

Each entry contains:
- semantic state
- diagnostics
- membrane deformation
- routing flow-field
"""
function export_trace_json(trace::Vector, path::String)
    data = []

    for state in trace
        push!(data, Dict(
            "z" => collect(state.z),
            "drift" => collect(state.drift),
            "roughness" => collect(state.roughness),
            "holonomy" => collect(state.holonomy),
            "collapse_risk" => state.collapse_risk,
            "membrane_env" => collect(state.membrane_env),
            "routing_flow" => collect(state.routing_flow)
        ))
    end

    open(path, "w") do io
        JSON.print(io, data)
    end
end


"""
    export_numpy_array(arr, path)

Export a Julia array to a NumPy-compatible .npy file.

Python tooling uses this for:
- curvature fields
- collapse-risk gradients
- membrane deformation maps
- routing flow fields
"""
function export_numpy_array(arr::AbstractArray, path::String)
    # NumPy .npy format (minimal deterministic implementation)
    open(path, "w") do io
        # Magic header
        write(io, UInt8[0x93])
        write(io, "NUMPY")
        write(io, UInt8[0x01, 0x00])  # version 1.0

        # Header dictionary
        header = "{'descr': '<f8', 'fortran_order': False, 'shape': ($(join(size(arr), ",")),), }"
        header_len = length(header) + 1
        write(io, UInt16(header_len))
        write(io, header)
        write(io, UInt8[0x0A])

        # Raw data
        write(io, reinterpret(UInt8, vec(arr)))
    end
end


"""
    export_hdf5_trace(trace, path)

Export a full runtime trace to HDF5.

This is used by Python tooling for:
- multi-altitude visualization
- time-series diagnostics
- membrane evolution
- routing flow-field evolution
"""
function export_hdf5_trace(trace::Vector, path::String)
    h5open(path, "w") do file
        for (i, state) in enumerate(trace)
            g = create_group(file, "state_$i")
            g["z"] = collect(state.z)
            g["drift"] = collect(state.drift)
            g["roughness"] = collect(state.roughness)
            g["holonomy"] = collect(state.holonomy)
            g["collapse_risk"] = state.collapse_risk
            g["membrane_env"] = collect(state.membrane_env)
            g["routing_flow"] = collect(state.routing_flow)
        end
    end
end

end # module
