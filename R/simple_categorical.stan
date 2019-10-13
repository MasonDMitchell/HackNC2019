data {
  int<lower=0> N;
  real<lower=0> expenditure[N];
  
  int<lower=0> predict_day_count;
}
parameters {
  real<lower=0,upper=1e6> mu_expen;
  real<lower=-100,upper=100> log_stdeviation;
}
transformed parameters{
  real stdeviation = exp(log_stdeviation);
}
model {
  expenditure ~ normal(mu_expen,stdeviation);
}
generated quantities{
  real expen_predictions[predict_day_count];
  for (day in 1:predict_day_count) {
    expen_predictions[day] = normal_rng(mu_expen,stdeviation);
  }
}

