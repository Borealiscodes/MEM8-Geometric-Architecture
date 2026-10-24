import numpy as np
import matplotlib.pyplot as plt

def load_geodesic(path):
    """
    Load geodesic trajectory exported from Julia.
    Expected format: NumPy .npy file containing z[t, i].
    Shape: (T, N)
    """
    return np.load(path)

def load_membrane(path):
    """
    Load membrane envelope for overlay.
    Expected format: NumPy .npy file containing env[i].
    """
    return np.load(path)

def plot_geodesic_trace(z, env=None, title="Geodesic Trace"):
    """
    Visualize geodesic trajectory.
    - If z is 1D over time: plot as a line.
    - If z is 2D over time: plot each coordinate.
    - If env is provided: overlay membrane envelope.
    """
    z = np.asarray(z)

    # --- 1D geodesic trace ---
    if z.ndim == 1:
        plt.figure(figsize=(10, 4))
        plt.plot(z, linewidth=2, label="Geodesic")
        if env is not None:
            plt.hlines(env, 0, len(z)-1, colors="red", linestyles="dashed", label="Membrane")
        plt.title(title)
        plt.xlabel("Time Step")
        plt.ylabel("Position")
        plt.grid(True, alpha=0.3)
        plt.legend()
        plt.tight_layout()
        plt.show()
        return

    # --- 2D geodesic trace (T × N) ---
    if z.ndim == 2:
        T, N = z.shape
        plt.figure(figsize=(10, 5))

        for i in range(N):
            plt.plot(z[:, i], label=f"z[{i}]")

        if env is not None:
            for i in range(N):
                plt.hlines(env[i], 0, T-1, colors="red", linestyles="dashed", alpha=0.4)

        plt.title(title)
        plt.xlabel("Time Step")
        plt.ylabel("Coordinate Value")
        plt.grid(True, alpha=0.3)
        plt.legend()
        plt.tight_layout()
        plt.show()
        return

    raise ValueError("Geodesic trace must be 1D or 2D.")

def geodesic_trace_plot(z_path, env_path=None):
    """
    Full pipeline: load geodesic → optional membrane → plot.
    """
    z = load_geodesic(z_path)
    env = load_membrane(env_path) if env_path is not None else None
    plot_geodesic_trace(z, env)
