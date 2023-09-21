
data {

  int<lower = 0> N;
  int<lower = 0> N_cat1r;
  vector[N] y; 
  vector[N] cat1f;
  vector[N] cat2f;
  int<lower = 1> cat1r[N];
  vector[N] con1f;

}

parameters {

  real mu_base;
  real<lower=0> sigma_base; 
  real<lower=0> mu_diff;
  real<lower=0> sigma_diff;  

  real beta_base;

  real beta_cat1f_delta;
  real theta_cat2f_mu; 

  real<lower=0> theta_cat1r_sd;
  real theta_cat1r_eps[N_cat1r];

  real beta_con1f_delta; 

}

transformed parameters {

  vector[2] mu;
  vector[2] sigma;
  vector[N] beta_vec;

  real cat1r_dev[N_cat1r]; 

  mu[1] = mu_base;
  mu[2] = mu_base + mu_diff;
  sigma[1] = sigma_base;
  sigma[2] = sigma_base + sigma_diff; 

  for (n in 1:N) {  
   beta_vec[n] = inv_logit(beta_base + beta_cat1f_delta * cat1f[n] + beta_con1f_delta * con1f[n]);
  }

  for (n in 1:N_cat1r) { 
   cat1r_dev[n]  = theta_cat1r_sd * theta_cat1r_eps[n];
  }

} 

model {

// --- Priors --- // 

 mu_base ~ normal(0, 2);
 mu_diff ~ normal(0, 2); 

 sigma_base ~ normal(0, 2);
 sigma_diff ~ normal(0, 2);

 theta_cat2f_mu ~ normal(0, 1);

 beta_base ~ normal(0, 3);
 beta_cat1f_delta ~ normal(0, 3);

 theta_cat1r_sd  ~ inv_gamma(8, 15);
 theta_cat1r_eps ~ normal(0, 3);

 beta_con1f_delta ~ normal(0, 3);


// --- Model --- // 

 for (n in 1:N) {
   target += log_mix(beta_vec[n],
                     normal_lpdf(y[n] | mu[2] + cat1r_dev[cat1r[n]] + cat2f[n] * theta_cat2f_mu, sigma[2]),
                     normal_lpdf(y[n] | mu[1], sigma[1]));
 }


}


generated quantities {

  matrix[2, N] membership_l;
  matrix[2, N] membership_p;
  int ind_sero[N];
  int pop_sero;
  matrix[2, N] log_beta;

  for (n in 1:N) {
   vector[2] beta_n;
 
   log_beta[1, n] = log(beta_vec[n]); 
   log_beta[2, n] = log(1 - beta_vec[n]); 

   log_beta[1, n] += normal_lpdf(y[n] | mu[2] + cat1r_dev[cat1r[n]] + cat2f[n] * theta_cat2f_mu, sigma[2]);
   log_beta[2, n] += normal_lpdf(y[n] | mu[1], sigma[1]);

   membership_l[1, n] = exp(log_beta[1, n]); 
   membership_l[2, n] = exp(log_beta[2, n]); 

   membership_p[1, n] = membership_l[1, n] / (membership_l[1, n] + membership_l[2, n]);
   membership_p[2, n] = membership_l[2, n] / (membership_l[1, n] + membership_l[2, n]);

   ind_sero[n] = binomial_rng(1, membership_p[1, n]);

  }

  pop_sero = sum(ind_sero);

}





