import numpy as np
import matplotlib.pyplot as plt

def load_curvature(path):
    """
    Load curvature tensor exported from Julia.
    Expected format: NumPy .npy file containing R[i,j,k,l].
    """
    return np.load(path)

def sectional_curvature(R, i, j):
    """
    Compute sectional curvature K(e_i, e_j) from R[i,j,i,j].
    Assumes orthonormal basis from Julia metric export.
    """
    return R[i, j, i, j]

def curvature_field(R):
    """
    Produce a 2D curvature field K(i,j) for visualization.
    """
    n = R.shape[0]
    K = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            K[i, j] = sectional_curvature(R, i, j)
    return K

def plot_curvature(K, title="Sectional Curvature Field"):
    """
    Visualize curvature field using matplotlib.
    """
    plt.figure(figsize=(8, 6))
    plt.imshow(K, cmap="viridis", origin="lower")
    plt.colorbar(label="Curvature")
    plt.title(title)
    plt.xlabel("i")
    plt.ylabel("j")
    plt.tight_layout()
    plt.show()

def curvature_plot(path):
    """
    Full pipeline: load curvature → compute field → plot.
    """
    R = load_curvature(path)
    K = curvature_field(R)
    plot_curvature(K)
