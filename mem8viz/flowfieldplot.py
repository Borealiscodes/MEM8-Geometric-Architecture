import numpy as np
import matplotlib.pyplot as plt

def load_flow(path):
    """
    Load routing flow field exported from Julia.
    Expected format: NumPy .npy file containing flow[i].
    """
    return np.load(path)

def plot_flow_field(flow, title="Routing Flow Field"):
    """
    Visualize routing flow field.
    - If flow is 1D: plot as a vector.
    - If flow is 2D: quiver plot.
    """
    flow = np.asarray(flow)

    # --- 1D flow field ---
    if flow.ndim == 1:
        plt.figure(figsize=(10, 4))
        plt.stem(flow, use_line_collection=True)
        plt.title(title)
        plt.xlabel("Index")
        plt.ylabel("Flow Value")
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        plt.show()
        return

    # --- 2D flow field ---
    if flow.ndim == 2:
        n, m = flow.shape
        X, Y = np.meshgrid(np.arange(m), np.arange(n))

        plt.figure(figsize=(8, 6))
        plt.quiver(X, Y, flow, np.zeros_like(flow), angles='xy')
        plt.title(title)
        plt.xlabel("j")
        plt.ylabel("i")
        plt.tight_layout()
        plt.show()
        return

    raise ValueError("Flow field must be 1D or 2D.")

def flow_field_plot(path):
    """
    Full pipeline: load flow → plot.
    """
    flow = load_flow(path)
    plot_flow_field(flow)
