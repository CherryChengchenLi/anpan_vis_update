data {
  int<lower=1> N;  // total number of observations
  array[N] int Y;  // response variable
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  matrix[N, N] Lcov;  // cholesky factor of known covariance matrix
  array[K-1] real<lower=0> beta_sd;
}
transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
}
parameters {
  vector[Kc] beta;  // population-level effects
  real centered_cov_intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma_phylo;
  vector[N] std_phylo_effect;  // standardized group-level effects
}
transformed parameters {
  vector[N] phylo_effect;  // actual group-level effects
  phylo_effect = (sigma_phylo * (Lcov * std_phylo_effect));
}
model {
  // likelihood
  vector[N] mu = centered_cov_intercept + phylo_effect;
  target += bernoulli_logit_glm_lpmf(Y | Xc, mu, beta);

  // priors
  target += std_normal_lpdf(centered_cov_intercept);

  target += normal_lpdf(beta | 0, beta_sd);

  target += std_normal_lpdf(sigma_phylo) - std_normal_lccdf(0);

  target += std_normal_lpdf(std_phylo_effect);
}
generated quantities {
  // actual population-level intercept
  real intercept = centered_cov_intercept - dot_product(means_X, beta);
  array[N] int yrep;
  vector[N] log_lik;
  for (i in 1:N){
    log_lik[i] = bernoulli_logit_glm_lpmf(Y[i] | to_matrix(Xc[i]), centered_cov_intercept + phylo_effect[i], beta);
    yrep[i] = bernoulli_logit_rng(centered_cov_intercept + phylo_effect[i] + Xc[i]*beta);
  }
}
