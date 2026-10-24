import numpy as np
import matplotlib.pyplot as plt

def load_membrane(path):
    """
    Load membrane envelope exported from Julia.
    Expected format: NumPy .npy file containing env[i].
    """
    return np.load(path)

def load_deformation(path):
    """
    Load membrane deformation (new envelope) exported from Julia.
    Expected format: NumPy .npy file containing new_env[i].
    """
    return np.load(path)

def plot_membrane(env, new_env, title="Membrane Envelope & Deformation"):
    """
    Visualize membrane envelope tightening.
    - env: original envelope
    - new_env: tightened envelope after deformation
    """
    env = np.asarray(env)
    new_env = np.asarray(new_env)

    if env.ndim != 1 or new_env.ndim != 1:
        raise ValueError("Membrane envelopes must be 1D arrays.")

    plt.figure(figsize=(10, 5))

    plt.plot(env, label="Original Envelope", linewidth=2)
    plt.plot(new_env, label="New Envelope (After Deformation)", linewidth=2)

    plt.fill_between(
        np.arange(len(env)),
        new_env,
        env,
        color="lightblue",
        alpha=0.4,
        label="Tightening Region"
    )

    plt.title(title)
    plt.xlabel("Index")
    plt.ylabel("Envelope Value")
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    plt.show()

def membrane_plot(env_path, new_env_path):
    """
    Full pipeline: load envelopes → plot tightening.
    """
    env = load_membrane(env_path)
    new_env = load_deformation(new_env_path)
    plot_membrane(env, new_env)
