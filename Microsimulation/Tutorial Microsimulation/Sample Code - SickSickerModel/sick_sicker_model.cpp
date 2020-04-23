// C++ program to implement sick sicker model
// Reference:https://github.com/DARTH-git/Microsimulation-tutorial/blob/master/Appendix%20A_online_supp.R
#include <iostream>
#include <vector>
#include <string>
#include <bits/stdc++.h>
#include <cmath>
#include <stdlib.h>
#include <chrono>
using namespace std;
using namespace std::chrono;

// Model input
int n_i = 1000;                                 // number of simulated individuals
int n_t = 30;                                     // time horizon, 30 cycles
vector<int> v_n{0, 1, 2, 3};                      // the model states: Healthy (0), Sick (1), Sicker (2), Dead (3)
int n_s = v_n.size();                             // the number of health states
vector<int> v_M_1(n_s, 0);                        // everyone begins in the healthy state(0)
double d_c = 0.03, d_e = 0.03;                    // equal discounting of costs and QALYs by 3%
vector<string> v_Trt{"No Treatment", "Treatment"}; // store the strategy names

// Transition probabilities (per cycle)
double p_HD = 0.005;               // probability to die when healthy
double p_HS1 = 0.15;          	   // probability to become sick when healthy
double p_S1H = 0.5;           	   // probability to become healthy when sick
double p_S1S2 = 0.105;         	   // probability to become sicker when sick
double rr_S1 = 3;             	   // rate ratio of death when sick vs healthy
double rr_S2 = 10;            	   // rate ratio of death when sicker vs healthy
double r_HD  = -log(1 - p_HD); 	   // rate of death when healthy - base e
double r_S1D = rr_S1 * r_HD;  	   // rate of death when sick
double r_S2D = rr_S2 * r_HD;  	   // rate of death when sicker
double p_S1D = 1 - exp(- r_S1D);   // probability to die when sick
double p_S2D = 1 - exp(- r_S2D);   // probability to die when sicker

// Cost and utility inputs
double c_H = 2000;                // cost of remaining one cycle healthy
double c_S1 = 4000;               // cost of remaining one cycle sick
double c_S2 = 15000;              // cost of remaining one cycle sicker
double c_Trt = 12000;             // cost of treatment (per cycle)

double u_H = 1;                   // utility when healthy
double u_S1 = 0.75;               // utility when sick
double u_S2 = 0.5 ;               // utility when sicker
double u_Trt = 0.95 ;             // utility when sick(er) and being treated

// Functions
// Probability function
// The Probs function that updates the transition probabilities of every cycle is shown below.
// M_it:    health state occupied by individual i at cycle t (int variable)
vector<double> Probs(int M_it)
{
    vector<double>v_p_it(n_s, 0); // create vector of state transition probabilities

    switch(M_it)
    {
      case 0:
        v_p_it = {1 - p_HS1 - p_HD, p_HS1, 0, p_HD};                // transition probabilities when healthy
        break;
      case 1:
        v_p_it = {p_S1H, 1- p_S1H - p_S1S2 - p_S1D, p_S1S2, p_S1D}; // transition probabilities when sick
        break;
      case 2:
        v_p_it = {0, 0, 1 - p_S2D, p_S2D};                          // transition probabilities when sicker
        break;
      case 3:
        v_p_it = {0, 0, 0, 1};                                     // transition probabilities when dead
        break;
    }

    // return the transition probabilities or produce an error
    double sum = accumulate(v_p_it.begin(), v_p_it.end(), 0);
    if(sum == 1){
      return v_p_it;
    }else {
      //cout << "Probabilities do not sum to 1\n";
      return v_p_it;
    }
}

// Costs function
// The Costs function estimates the costs at every cycle.
double Costs(int M_it, bool Trt = false){
  // M_it: health state occupied by individual i at cycle t (character variable)
  // Trt:  is the individual being treated? (default is FALSE)

  double c_it = 0;  // by default the cost for everyone is zero
  switch(M_it)
  {
    case 0:
      c_it = c_H;                  // update the cost if healthy
      break;
    case 1:
      c_it = c_S1 + c_Trt * Trt;   // update the cost if sick conditional on treatment
      break;
    case 2:
      c_it = c_S2 + c_Trt * Trt;   // update the cost if sicker conditional on treatment
      break;
  }
  return c_it;
}

// Health outcome function
// The Effs function to update the utilities at every cycle.
double Effs(int M_it, bool Trt = false, int cl = 1){
  // M_it: health state occupied by individual i at cycle t (character variable)
  // Trt:  is the individual treated? (default is FALSE)
  // cl:   cycle length (default is 1)

  double u_it = 0;  // by default the utility for everyone is zero
  switch(M_it)
  {
    case 0:
      u_it = u_H;                              // update the utility if healthy
      break;
    case 1:
      u_it = Trt * u_Trt + (1 - Trt) * u_S1;  // update the utility if sick conditional on treatment
      break;
    case 2:
      u_it = u_S2;                            // update the utility if sicker
      break;
  }
  double QALYs = u_it * cl;                   // return the QALYs
  return QALYs;
}

// Return the state index(0/1/2/3) depending on the probability
int sample(vector<double> prob)
{
  double random_number = (double)rand() / (double) RAND_MAX;
  double cumm_prob = 0;
  for(int i = 0; i < prob.size(); i ++){
    cumm_prob = cumm_prob + prob[i];
    if(random_number <= cumm_prob)
      return i;
  }
}

// The MicroSim function for the simple microsimulation of the 'Sick-Sicker' model keeps track of what happens to each individual during each cycle.
void MicroSim(vector<int> v_M_1, int n_i, int n_t, vector<int> v_n, double d_c, double d_e, bool TR_out = true, bool TS_out = true, bool Trt = false, int seed = 1)
{
  // Arguments:
    // v.M_1:   vector of initial states for individuals
    // n.i:     number of individuals
    // n.t:     total number of cycles to run the model
    // v.n:     vector of health state names
    // d.c:     discount rate for costs
    // d.e:     discount rate for health outcome (QALYs)
    // TR.out:  should the output include a microsimulation trace? (default is TRUE)
    // TS.out:  should the output include a matrix of transitions between states? (default is TRUE)
    // Trt:     are the n.i individuals receiving treatment? (scalar with a Boolean value, default is FALSE)
    // seed:    starting seed number for random number generator (default is 1)
  // Makes use of:
    // Probs:   function for the estimation of transition probabilities
    // Costs:   function for the estimation of cost state values
    // Effs:    function for the estimation of state specific health outcomes (QALYs)

    //vector<double> v_dwc(n_t, 0);
    //vector<double> v_dwe(n_t, 0);
    //for(int i = 0; i <= n_t; i++){
    //  v_dwc[i] = pow((1/1+d_c),i); // calculate the cost discount weight based on the discount rate d.c
    //  v_dwe[i] = pow((1/1+d_e),i); // calculate the QALY discount weight based on the discount rate d.e
    //}

    // create the matrix capturing the state name/costs/health outcomes for all individuals at each time point
    int m_M[n_i][n_t+1] = {0};
    double m_C[n_i][n_t+1] = {0};
    double m_E[n_i][n_t+1] = {0};
    //int **m_M = new int * [n_i];
    //double **m_C = new double * [n_i];
    //double **m_E = new double * [n_i];

    for(int i = 0; i < n_i; i++){
      //m_M[i] = new int[n_t + 1];
      //m_C[i] = new double[n_t + 1];
      //m_E[i] = new double[n_t + 1];
      cout<<"Computing for individual:"<<i<<"\n";
      srand(seed + i);                    // set the seed for every individual for the random number generator
      m_M[i][0] = 0;              // indicate the initial health state
      m_C[i][0] = Costs(m_M[i][0], Trt); // estimate costs per individual for the initial health state conditional on treatment
      m_E[i][0] = Effs(m_M[i][0], Trt);  // estimate QALYs per individual for the initial health state conditional on treatment

      for(int t = 0; t <= n_t; t++){
        vector<double> v_p = Probs(m_M[i][t]); // calculate the transition probabilities at cycle t
        m_M[i][t+1] = sample(v_p);             // sample the next health state and store that state in matrix m.M
        m_C[i][t+1] = Costs(m_M[i][t+1], Trt); // estimate costs per individual during cycle t + 1 conditional on treatment
        m_E[i][t+1] = Effs(m_M[i][t+1], Trt);  // estimate QALYs per individual during cycle t + 1 conditional on treatment
        cout<<"t="<<t<<" M="<<m_M[i][t+1]<<" C="<<m_C[i][t+1]<<" e="<<m_E[i][t+1]<<"\n";
      }
    }
}



int main(){
  vector<double>result =  Probs(0);
  for(int i = 0; i < result.size(); i++){
    cout << result[i]<<" ";
  }
  auto start = high_resolution_clock::now();
  bool Trt = true;
  MicroSim(v_M_1, n_i, n_t, v_n, d_c, d_e, true, true, Trt, 1);

  auto stop = high_resolution_clock::now();
  auto duration = duration_cast<seconds>(stop - start);
  cout << "Time taken by function(sec): " << duration.count() <<"\n";



  //cout<<"Hello World!";
  //cout<<n_i<<"\n";
  //for (int x : v_n)
  //  cout<<x<<" ";
  //cout<<n_s<<"\n";
  //cout<<r_HD<<"\n";
  //cout<<p_S1D<<"\n";

  //for(int i = 0; i < result.size(); i++){
  //  cout << result[i]<<" ";
  //}
  //cout<<"\n";
  //int ind = sample(result);
  //cout<<ind<<"\n";
  //cout<<Costs(0)<<"\n";
  //cout<<Effs(0)<<"\n";
}
