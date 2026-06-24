# RSM-Compress

**Stability-Preserving Neural Network Controller Compression for Singularly Perturbed Systems via Riemannian Slow-Manifold Geometry**

[![Status](https://img.shields.io/badge/Status-Under%20Review-yellow)](https://www.journals.elsevier.com/automatica)
[![Journal](https://img.shields.io/badge/Journal-Automatica%20(IFAC%2FElsevier)-blue)](https://www.journals.elsevier.com/automatica)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0001--2126--6428-green)](https://orcid.org/0009-0001-2126-6428)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-orange)](https://www.mathworks.com)

**Authors:**
- Sri Venkata Durga Sudarsan Madhyannapu — Department of Mathematics, Dr. RVR NRI Institute of Technology (Deemed to be University), Vijayawada Rural, Andhra Pradesh 521212, India
- Sravanam Pradheep Kumar — School of Basic Sciences, SRM University–AP, Guntur, Andhra Pradesh 522240, India

**Corresponding author:** msvdsudarsan@gmail.com | ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)

---

## Abstract

Compressing a neural network (NN) controller for a singularly perturbed nonlinear plant typically voids whatever stability guarantee the uncompressed controller carries, because standard pruning methods treat the dynamical system as an opaque data source and optimise reconstruction error without regard to closed-loop behaviour. This paper addresses that problem directly. We introduce the Control-Sensitive Fisher Information Matrix (CS-FIM), a Lyapunov-weighted information matrix whose structure reflects which parameter directions govern long-term closed-loop performance. Applying Tikhonov averaging and Fenichel slow-manifold theory, we prove that the CS-FIM admits an asymptotic splitting F_CS = F_slow + O(ε) with an O(ε²) total-variation remainder in occupation measure. A Davis–Kahan bound then controls the resulting subspace approximation error by O(ε/γ_r), where γ_r is the spectral gap separating retained from discarded parameter directions. An ε-dependent rank-selection rule (exponent α = 0.44, analytically constrained to the admissible interval (0, 0.60) and empirically optimised within that range) determines the minimum slow-subspace dimension required to preserve semi-global practical input-to-state stability (SG-pISS) with explicit, computable gain bounds. The compressed controller is obtained by projecting onto the Stiefel manifold and refining via Riemannian natural-gradient descent.

---

## Key Results

| Benchmark | ε | Compression | Normalised Error | Wilcoxon p | ISS Violations |
|:---:|:---:|:---:|:---:|:---:|:---:|
| CSTR | 0.05 | **1024×** | 1.058 ± 0.104 | **0.413** (not significant) | 0 / 50 |
| Quadrotor | 0.03 | **2048×** | 1.151 ± 0.031 | **< 0.001** (significant†) | 0 / 50 |
| DC–DC Converter | 0.02 | **429×** | 1.083 | **0.280** (not significant) | 0 / 50 |

†The quadrotor result reflects an independent closed-loop Monte Carlo reverification (N = 50). The position-error increase is small in absolute terms (< 1 cm) and is an order of magnitude below the degradation of every reconstruction-only baseline at the same compression ratio. All other methods yield significant degradation (p < 0.05) at these compression ratios.

All RSM-Compress results involve **zero ISS violations** across all benchmarks. Hardware evaluation on ARM Cortex-M7 over 1,000 episodes.

---

## Repository Structure

```
RSMCompress/
├── README.md
├── LICENSE
├── MATLAB_OUTPUT_VALUES.txt        ← Verified numerical outputs (all figures + Table 2)
├── run_all_figures.m               ← Master script: runs all 7 figure scripts
├── Benchmark_Statistics.m          ← Monte Carlo closed-loop evaluation (N=50)
├── RSMCompress_Table2_Timing.m     ← Table 2 timing: CS-FIM and NGD wall-clock
├── Fig1_RSMCompress_Pipeline.m     ← Figure 1: Five-phase pipeline diagram
├── Fig2_CSTR_Trajectory.m          ← Figure 2: CS-FIM eigenvalue decay
├── Fig3_Quadrotor_Trajectory.m     ← Figure 3: CSTR concentration trajectory
├── Fig4_Fisher_Eigenvalue_Decay.m  ← Figure 4: Quadrotor x-position trajectory
├── Fig5_NGD_Convergence.m          ← Figure 5: ε-rank dependence
├── Fig6_Epsilon_Rank_Dependence.m  ← Figure 6: NGD convergence
├── Fig7_Ablation_Study.m           ← Figure 7: Ablation study
├── Fig1_RSMCompress_Pipeline.pdf
├── Fig2_CSTR_Trajectory.pdf
├── Fig3_Quadrotor_Trajectory.pdf
├── Fig4_Fisher_Eigenvalue_Decay.pdf
├── Fig5_NGD_Convergence.pdf
├── Fig6_Epsilon_Rank_Dependence.pdf
└── Fig7_Ablation_Study.pdf
```

---

## Verified Numerical Values

All values below are cross-verified between the manuscript and the MATLAB scripts. See `MATLAB_OUTPUT_VALUES.txt` for the full verification log.

| Symbol | Value | Manuscript location |
|:---|:---:|:---|
| α (rank-criterion exponent) | **0.44** | Remark 4.2, Figure 5 |
| β̂ (Fisher eigenvalue decay exponent) | **1.52** | Figure 2, Remark 4.2 |
| Admissible range for α | **(0, 0.60)** | Remark 4.2 |
| Energy threshold at ε = 0.05 | **0.8755 (87.5%)** | Figure 2, Table 6 |
| r₁ at ε = 0.01 | **6** (2730×) | Table 6 |
| r₁ at ε = 0.05 | **16** (1024×) | Table 6 |
| r₁ at ε = 0.10 | **23** (712×) | Table 6 |
| r₁ at ε = 0.20 | **32** (512×) | Table 6 |
| SG-pISS residual Γ at ε = 0.05 | **0.0044** | Table 6, Remark 4.5 |
| NGD convergence (CSTR) | **k = 500** (within 0.1%) | Figure 6, Theorem 5.2 |
| NGD convergence (Quadrotor) | **k = 500** (within 0.1%) | Figure 6, Theorem 5.2 |
| Ablation: w/o slow-manifold FIM split | **+24.8%** tracking error | Table 7, Figure 7 |
| Ablation: w/o all components (= SVD-C) | **+54.3%** tracking error | Table 7, Figure 7 |
| Component synergy | 54.3% > additive sum 45.3% | Table 7, Figure 7 |
| Burn-in sensitivity (max variation) | **2.3%** | Table 8, Figure 7 |
| Spectral gap — CSTR (r* = 16) | 0.0237 > 0.0183 ✓ | Section 4.2 |
| Spectral gap — Quadrotor (r* = 6) | 0.0312 > 0.0148 ✓ | Section 4.2 |
| Spectral gap — DC–DC (r* = 5) | 0.0419 > 0.0084 ✓ | Section 4.2 |

---

## Five-Phase Algorithm (RSM-Compress)

| Phase | Name | Description |
|:---:|:---|:---|
| 1 | Slow-Manifold Sampling | Simulate plant for T = T_burn/ε ≥ 5 time units; collect N_s samples from M_ε |
| 2 | CS-FIM Estimation | Estimate F̂ₗˢ = (1/Nₛ) Σᵢ V(xᵢ,zᵢ) Jₗ(xᵢ)Jₗ(xᵢ)ᵀ for each layer ℓ |
| 3 | ε-Rank Selection | Select rₗ(ε, δₗ) via cumulative Fisher-energy threshold (α = 0.44) |
| 4 | Stiefel Projection | Project Wₗ onto top-rₗ eigenvector subspace via Cayley retraction |
| 5 | NGD Refinement | Refine via Riemannian natural-gradient descent on St(dₗ, rₗ), K iterations |

---

## Main Theoretical Results

| Result | Statement | Manuscript location |
|:---|:---|:---|
| **Theorem 3.2** (CS-FIM splitting) | F_CS = F_slow + ε R, ‖R‖_F ≤ C_R; ‖μ_ε − μ₀‖_TV ≤ C_TV ε² | Section 3.2, Appendix A |
| **Lemma 3.5** (Davis–Kahan bound) | Subspace error ≤ 2√(2k) ε C_R / γ_k | Section 3.3 |
| **Theorem 4.4** (SG-pISS) | Compressed closed loop satisfies SG-pISS; residual Γ(ε,η) = O(ε√η) | Section 4.3, Appendix B |
| **Proposition 4.6** (CS-FIM vs standard Fisher) | CS-FIM bound provably smaller by O(1) for all ε ∈ (0, ε*] | Section 4.4 |
| **Corollary 4.8** (Performance bound) | \|J(θ̂) − J(θ)\| ≤ C_J (Σₗ Σ_{k>rₗ} λˢₗₖ + ε) | Section 4.5 |
| **Theorem 5.2** (NGD convergence) | Local linear convergence: (1 − μ/L)^K gap reduction | Section 5.1 |

---

## Computational Cost (Table 2)

| Benchmark | Parameters p | Selected rank r* | CS-FIM estimation | NGD refinement (K=500) |
|:---:|:---:|:---:|:---:|:---:|
| CSTR | 8,321 | 16 | 0.013 s | 0.041 s |
| Quadrotor | 57,603 | 6 | < 0.005 s | 0.022 s |
| DC–DC | 2,145 | 5 | < 0.005 s | < 0.005 s |

Measured on Intel Core i9-12900K (3.2 GHz), 64 GB RAM, MATLAB R2023b.

---

## Running the Code

**Requirements:** MATLAB R2020a or later; no additional toolboxes required.

**Reproduce all figures:**

```matlab
run_all_figures
```

All seven figures are saved as PDF and PNG in the working directory.
Expected runtime: approximately 28 s total (see `MATLAB_OUTPUT_VALUES.txt`).

**Reproduce Table 2 timing:**

```matlab
RSMCompress_Table2_Timing
```

**Reproduce benchmark statistics (Monte Carlo, N = 50):**

```matlab
Benchmark_Statistics
```

---

## Implementation Details

- **MATLAB R2020a+** for figure generation and numerical verification
- **Hardware evaluation:** ARM Cortex-M7, 1,000 episodes
- **Full-network training:** Adam optimiser (CSTR: LR = 3×10⁻⁴, 2,000 episodes; Quadrotor: LR = 2×10⁻⁴, 5,000 episodes)
- **Statistical testing:** Two-sided Wilcoxon rank-sum test, α_sig = 0.05, N = 50 independent trajectories per method

---

## Citation

```bibtex
@article{MadhyannapuPradheepKumar2026,
  title   = {Stability-Preserving Neural Network Controller Compression
             for Singularly Perturbed Systems via Riemannian Slow-Manifold Geometry},
  author  = {Madhyannapu, Sri Venkata Durga Sudarsan and Pradheep Kumar, Sravanam},
  journal = {Automatica},
  note    = {Under review},
  year    = {2026}
}
```

---

## Related Publications

- Madhyannapu, S.V.D.S., Putcha, V.S., Deekshitulu, G.V.S.R. (2025). Hewer controllability and Kalman controllability of Lyapunov matrix periodic systems. *i-Manager's Journal on Mathematics*, 14(1):33–42. [DOI: 10.26634/jmat.14.1.21822](https://doi.org/10.26634/jmat.14.1.21822)
- Madhyannapu, S.V.D.S. & Pradheep Kumar, S. (2026). Physics-informed neural network verification of Kalman–Hewer controllability Gramians in singular bilinear periodic matrix differential systems. *Neural Networks* (Elsevier). Submission ID: NEUNET-D-26-04112 (with editor).
- Madhyannapu, S.V.D.S. & Pradheep Kumar, S. (2026). Kalman–Hewer controllability equivalence for generalised bilinear matrix periodic systems with non-factorizable monodromy. *Mathematics of Control, Signals and Systems* (Springer). Under review.

---

## Contact

Sri Venkata Durga Sudarsan Madhyannapu  
Email: msvdsudarsan@gmail.com  
ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)  
Repository: <https://github.com/msvdsudarsan/RSMCompress>
