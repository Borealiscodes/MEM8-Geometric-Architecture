import numpy as np
import h5py

class MEM8State:
    """
    Unified Python-side state container for MEM8.
    Mirrors the Julia MEM8State{N} structure.
    """

    def __init__(
        self,
        z,
        metric,
        connection,
        curvature,
        drift,
        roughness,
        holonomy,
        collapse_grad,
        membrane_env,
        flow
    ):
        self.z = z
        self.metric = metric
        self.connection = connection
        self.curvature = curvature

        self.drift = drift
        self.roughness = roughness
        self.holonomy = holonomy
        self.collapse_grad = collapse_grad

        self.membrane_env = membrane_env
        self.flow = flow

def load_state_hdf5(path):
    """
    Load a full MEM8 state from an HDF5 file exported by Julia.
    Expected structure:
        /z
        /metric
        /connection
        /curvature
        /drift
        /roughness
        /holonomy
        /collapse_grad
        /membrane_env
        /flow
    """
    with h5py.File(path, "r") as f:
        z             = f["z"][:]
        metric        = f["metric"][:]
        connection    = f["connection"][:]
        curvature     = f["curvature"][:]

        drift         = f["drift"][:]
        roughness     = f["roughness"][:]
        holonomy      = f["holonomy"][:]
        collapse_grad = f["collapse_grad"][:]

        membrane_env  = f["membrane_env"][:]
        flow          = f["flow"][:]

    return MEM8State(
        z,
        metric,
        connection,
        curvature,
        drift,
        roughness,
        holonomy,
        collapse_grad,
        membrane_env,
        flow
    )

def load_state_npy(prefix):
    """
    Load a full MEM8 state from a set of .npy files.
    Expected filenames:
        prefix + "_z.npy"
        prefix + "_metric.npy"
        prefix + "_connection.npy"
        prefix + "_curvature.npy"
        prefix + "_drift.npy"
        prefix + "_roughness.npy"
        prefix + "_holonomy.npy"
        prefix + "_collapse_grad.npy"
        prefix + "_membrane_env.npy"
        prefix + "_flow.npy"
    """
    def L(name):
        return np.load(f"{prefix}_{name}.npy")

    return MEM8State(
        L("z"),
        L("metric"),
        L("connection"),
        L("curvature"),
        L("drift"),
        L("roughness"),
        L("holonomy"),
        L("collapse_grad"),
        L("membrane_env"),
        L("flow")
    )
