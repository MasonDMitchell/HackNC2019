data {
  int<lower=1> N;
  int<lower=1> K;
  real<lower=0> expenditure[K,N];
  
  int<lower=0> predict_day_count;
}
parameters {
  real<lower=0,upper=1e6> mu_expen[K];
  real<lower=-4,upper=12> log_stdeviation[K];
}
transformed parameters{
  real stdeviation[K] = exp(log_stdeviation);
}
model {
  log_stdeviation ~ normal(0,1);
  mu_expen ~ normal(150,40);
  for (categ in 1:K){
    expenditure[categ] ~ normal(mu_expen[categ],stdeviation[categ]);
  }
}
generated quantities{
  real<lower=0> expen_predictions[K,predict_day_count];
  real<lower=0> total_prediction[predict_day_count];
  for (day in 1:predict_day_count) {
    total_prediction[day] = 0;
    for (categ in 1:K){
      real pred = normal_rng(mu_expen[categ],stdeviation[categ]);
      while (pred <= 0)
        pred = normal_rng(mu_expen[categ],stdeviation[categ]);
      expen_predictions[categ,day] = pred;
      total_prediction[day] += pred;
    }
  }
}

