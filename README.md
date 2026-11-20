# Two-stage DiD in Stata

Estimate a staggered policy effect using Gardner’s two-stage difference-in-differences procedure.

The first regression uses untreated observations to estimate school effects, year effects, and covariate relationships. The second stage uses the adjusted outcomes to estimate the policy effect. The native standard error accounts for first-stage estimation.

## Install

Requires **Stata 16 or later**. No R, Python, or additional Stata estimation
packages are required to use this command.

Install the command directly from GitHub:

```stata
net install fastdid2s, from("https://raw.githubusercontent.com/mattdwebb/fastdid2sstata/main/") replace
discard
which fastdid2s
```

For a source-only trial, `adopath ++ "."` makes this checkout available for the
current session. Use one known version and record it for reproducible work.

## A school-policy example

The included fictional data contain 960 pupil observations: ten pupils in each of 12 schools and eight years (2010–2017). Pupils are repeated cross sections, so their row numbers are not longitudinal identifiers.
Four schools adopt in 2013, four in 2015, and four never adopt. The outcome is
`test_score`, measured in score points. `baseline_score` is a predetermined
covariate. Schools are the independent inference clusters.

The data generator adds a two-point policy effect, alongside school, year,
covariate, and varying disturbance components. This is a software teaching
example, not evidence about an actual policy. The [data guide](examples/DATA_GUIDE.md)
defines every variable and links the reproducible generator.

Run from the extracted repository folder:

```stata
clear
set type double
insheet using "examples/school_policy.csv", comma names clear
fastdid2s test_score baseline_score, time(year) cluster(school) gvar(first_treat) inference(native jackknife)
display e(estimate)
display e(jackknife_se)
```

The executed example gives:

| Estimate (score points) | Native clustered SE | Jackknife SE |
|---:|---:|---:|
| 2.316869 | 0.285375 | 0.336814 |

The estimated effect is about **2.32 score points**. The jackknife
standard error is **0.34 points**, calculated by leaving each of the twelve
schools out in turn. It describes uncertainty around this estimate; it does not
change the point estimate or establish the identifying assumptions of a policy
study. Standalone jackknife p-values use Student t with 11 degrees of freedom here.

`do examples/school_policy.do` runs this example, prints a compact table, and
saves `examples/school_results.csv`. Its [recorded output](examples/expected_output.txt)
is checked against the release example. Small last-digit differences may depend
on numerical libraries; they should not change the substantive result.

## Adapt it to your data

Use zero for never-treated schools and repeat each school’s first treatment year on all its rows. Treatment must be absorbing and common to observations in a school-year.

Covariates follow the outcome in the variable list. Omit `baseline_score` for an unadjusted specification. Use numeric covariates whose timing makes sense for your study;
the command does not make post-treatment controls causally appropriate.

Request `inference(native)` for the estimator’s analytic clustered calculation, `inference(jackknife)` for delete-school inference, or `inference(native jackknife)` to retain both. Native and jackknife standard errors are stored separately.

When a deletion removes a cohort, the jackknife recomputes the estimator’s
supported aggregate and its weights using the surviving estimable effects.
All cluster deletions must yield a scalar estimate. A genuinely unidentified
deletion is reported as a failure; it is never silently omitted.

Coefficient randomization inference and the supported studentized variants use
alternative cohort assignments while preserving treatment counts. These require
more input than the introductory example; see [inference options](INFERENCE.md).
Changing the treatment assignment must also change any treatment-dependent fits.

## Supported scope

This guide covers a static aggregate with cluster and time fixed effects. Individual fixed effects, event studies, and alternative cohort aggregations are outside this implementation’s supported scope.

Different DiD estimators can target different weighted averages when effects
vary. Comparing their coefficients does not by itself show that one is correct.
Unsupported options return explicit errors rather than substituting another model.

## Help, methods, and validation

- [Estimator definition and references](METHOD_SPECIFICATION.md)
- [Inference definitions](INFERENCE.md)
- [Technical development reference](docs/DEVELOPMENT_REFERENCE.md)
- [Runnable example](examples/school_policy.do) and [data definitions](examples/DATA_GUIDE.md)
- [License](LICENSE)

Use the repository’s Issues page for a reproducible problem report. Include your
software version, a small artificial dataset, and the exact command. Do not post
confidential research data. For developers, `tests/run_release_tests.ps1` runs the
native Stata checks and records their status with a licensed Stata installation.
