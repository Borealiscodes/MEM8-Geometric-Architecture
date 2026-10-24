import numpy as np
import matplotlib.pyplot as plt

def load_collapse_gradient(path):
    """
    Load collapse-risk gradient exported from Julia.
    Expected format: NumPy .npy file containing grad[i].
    """
    return np.load(path)

def plot_collapse_gradient(grad, title="Collapse-Risk Gradient"):
    """
    Visualize collapse-risk gradient as a 1D or 2D field.
    If grad is 1D: plot as a line.
    If grad is 2D: plot as a heatmap.
    """
    grad = np.asarray(grad)

    if grad.ndim == 1:
        plt.figure(figsize=(8, 4))
        plt.plot(grad, marker="o")
        plt.title(title)
        plt.xlabel("Index")
        plt.ylabel("Gradient Value")
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        plt.show()

    elif grad.ndim == 2:
        plt.figure(figsize=(8, 6))
        plt.imshow(grad, cmap="inferno", origin="lower")
        plt.colorbar(label="Gradient")
        plt.title(title)
        plt.xlabel("i")
        plt.ylabel("j")
        plt.tight_layout()
        plt.show()

    else:
        raise ValueError("Gradient must be 1D or 2D.")

def collapse_gradient_plot(path):
    """
    Full pipeline: load gradient → plot.
    """
    grad = load_collapse_gradient(path)
    plot_collapse_gradient(grad)
