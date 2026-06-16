# RSM-Compress

**Stability-Preserving Neural Network Controller Compression for Singularly Perturbed Systems via Riemannian Slow-Manifold Geometry**

[![Status](https://img.shields.io/badge/Status-Under%20Review-yellow)](https://www.journals.elsevier.com/automatica)
[![Journal](https://img.shields.io/badge/Journal-Automatica%20(IFAC%2FElsevier)-blue)](https://www.journals.elsevier.com/automatica)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0001--2126--6428-green)](https://orcid.org/0009-0001-2126-6428)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-orange)](https://www.mathworks.com)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://www.python.org)

**Authors:**
- Sri Venkata Durga Sudarsan Madhyannapu — Department of Mathematics, Dr. RVR NRI Institute of Technology (Deemed to be University), Vijayawada Rural, Andhra Pradesh 521212, India
- Sravanam Pradheep Kumar — School of Basic Sciences, SRM University–AP, Guntur, Andhra Pradesh 522240, India

**Corresponding author:** msvdsudarsan@gmail.com | ORCID: [0009-0001-2126-6428](https://orcid.org/0009-0001-2126-6428)

---

## Abstract

No prior work compresses a Lyapunov-certified neural network controller while preserving its stability guarantees. This paper addresses that gap for singularly perturbed nonlinear systems by decomposing the control-sensitive Fisher information matrix (CS-FIM) asymptotically along the slow manifold and boundary layer, establishing that the dominant parameter-space curvature is determined to leading order in ε by the slow subsystem alone. Regional input-to-state stability (ISS) of the compressed closed-loop system is proved via a composite Lyapunov function for all ε ∈ (0, ε*), and reformulated as semi-global practical ISS.

---

## Key Results

| Benchmark | ε | Compression | Performance | Wilcoxon p |
|:---:|:---:|:---:|:---:|:---:|
| CSTR | 0.05 | **1024×** | Norm. error 1.058 ± 0.104 (< 6% degradation) | **0.41** |
| Quadrotor | 0.03 | **2048×** | Position error 0.019 ± 0.003 m | **0.41** |

All tests over **1,000 evaluation episodes** on ARM Cortex-M7.

---

## Repository Structure

```
RSMCompress/
├── README.md
├── LICENSE
├── MATLAB_OUTPUT_VALUES.txt
├── run_all_figures.m
├── Fig1_RSMCompress_Pipeline.m
├── Fig2_CSTR_Trajectory.m
├── Fig3_Quadrotor_Trajectory.m
├── Fig4_Fisher_Eigenvalue_Decay.m
├── Fig5_NGD_Convergence.m
├── Fig6_Epsilon_Rank_Dependence.m
├── Fig7_Ablation_Study.m
├── Fig1_RSMCompress_Pipeline.pdf
├── Fig2_CSTR_Trajectory.pdf
├── Fig3_Quadrotor_Trajectory.pdf
├── Fig4_Fisher_Eigenvalue_Decay.pdf
├── Fig5_NGD_Convergence.pdf
├── Fig6_Epsilon_Rank_Dependence.pdf
└── Fig7_Ablation_Study.pdf
```

---

## Verified Numerical Values (MATLAB, 16 June 2026)

| Symbol | Value | Location in Paper |
|:---:|:---:|:---:|
| α (rank exponent) | **0.44** | Remark 4.1, Fig. 4 |
| β̂ (spectral exponent) | **1.52** | Fig. 4, Remark 4.1 |
| threshold at ε=0.05 | **0.8755 (87.5%)** | Fig. 4 MATLAB assert |
| r₁ at ε=0.01 | **6** | Table A.1 |
| r₁ at ε=0.05 | **16** (1024×) | Table A.1 |
| r₁ at ε=0.10 | **23** (712×) | Table A.1 |
| r₁ at ε=0.20 | **32** (512×) | Table A.1 |
| NGD k_conv (CSTR) | **500** | Fig. 5, Remark 5.1 |
| NGD k_conv (Quadrotor) | **500** | Fig. 5, Remark 5.1 |
| Ablation: w/o Slow-mfld FIM | **+24.8%** | Table 3, Fig. 7 |
| Ablation: w/o all (= SVD-C) | **+54.3%** | Table 3, Fig. 7 |
| Synergy (54.3% > sum 45.3%) | confirmed | Table 3, Fig. 7 |
| λ-sensitivity range | **2.3% max** | Table 3, Fig. 7 |

---

## Five-Phase Algorithm

| Phase | Name | Description |
|:---:|:---:|:---|
| 1 | Slow-Manifold Sampling | Simulate plant with T_burn ≥ 5ε (physical time); collect N_s samples from M_ε |
| 2 | CS-FIM Estimation | Estimate F̂ₗˢ = (1/Ns) Σ Jₗ(x)Jₗ(x)ᵀ for each layer ℓ |
| 3 | ε-Rank Selection | Select rₗ(ε, δₗ) via cumulative Fisher-energy threshold, α=0.44 |
| 4 | Stiefel Projection | Project Wₗ onto top-rₗ eigenvector subspace via Cayley retraction |
| 5 | NGD Refinement | Refine Cₗ via natural-gradient descent on St(dₗ, rₗ), K iterations |

---

## Main Theoretical Results

| Result | Statement |
|:---|:---|
| **Theorem 4.1** (Occupation Measure) | μ_ε = (1−ε)μ_s + εμ_f + O(ε²) in total variation |
| **Lemma 4.2** (CS-FIM Split) | ‖Fₗ − Fₗˢ‖₂ = O(ε); subspace deviation O(ε/γ_r) by Davis–Kahan |
| **Theorem 5.2** (SG-pISS) | Compressed closed-loop is semi-globally practically ISS for ε ∈ (0, ε*) |
| **Corollary 5.3** (Perf. Bound) | ‖J(θ̃) − J(θ)‖ ≤ C_J(Σₗ√(Σ_{k>rₗ} λₗₖˢ) + ε) |
| **Theorem 5.4** (NGD Conv.) | Local O(1/K) convergence under local geodesic strong convexity |

---

## Implementation Details

- **Python 3.11**, PyTorch 2.2, geotorch, Runge–Kutta ODE solver
- **MATLAB R2020a+** for figure generation (exportgraphics, no print)
- Hardware: ARM Cortex-M7 (evaluation)
- Full-network training: Adam optimizer (CSTR: LR=3e-4, 2000 episodes; Quadrotor: LR=2e-4, 5000 episodes)

## Requirements (MATLAB figures)

- MATLAB R2020a or later
- No additional toolboxes required
- `exportgraphics()` used throughout (R2020a+); `saveas()` fallback included

## Running the Figures

```Open MATLAB and execute:

run_all_figures
```

All seven figures will be saved as PDF and PNG in the working directory.

---

## Citation

```bibtex
@article{MadhyannapuPradheepKumar2026,
  title   = {Stability-Preserving Neural Network Controller Compression
             for Singularly Perturbed Systems via Riemannian Slow-Manifold Geometry},
  author  = {Madhyannapu, Sri Venkata Durga Sudarsan and Pradheep Kumar, Sravanam},
  journal = {Submitted to Automatica},
  year = {2026}
}
```

---

## Related Publications

- Madhyannapu, S.V.D.S., Putcha, V.S., Deekshitulu, G.V.S.R. (2025). Hewer controllability and Kalman controllability of Lyapunov matrix periodic systems. *i-Manager's Journal on Mathematics*, 14(1):33–42. [DOI: 10.26634/jmat.14.1.21822](https://doi.org/10.26634/jmat.14.1.21822)
- Madhyannapu, S.V.D.S. & Pradheep Kumar, S. (2026). Physics-informed neural network verification of Kalman–Hewer controllability Gramians in singular bilinear periodic matrix differential systems. *Neural Networks*, Elsevier. Submission ID: NEUNET-D-26-04112 (With Editor).
- Madhyannapu, S.V.D.S. & Pradheep Kumar, S. (2026). Kalman–Hewer controllability equivalence for generalised bilinear matrix periodic systems with non-factorizable monodromy. *Mathematics of Control, Signals and Systems*, Springer (With Editor).

---

## Contact

Sri Venkata Durga Sudarsan Madhyannapu

Email: msvdsudarsan@gmail.com

ORCID: https://orcid.org/0009-0001-2126-6428

GitHub Repository:
https://github.com/msvdsudarsan/RSMCompress
