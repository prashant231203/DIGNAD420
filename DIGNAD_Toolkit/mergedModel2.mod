@#define exogenous = 0
@#define endogenous_domestic = 0
@#define endogenous_commercial = 0
@#define all_debt = 1


@#if endogenous_domestic+exogenous+endogenous_commercial+all_debt != 1
    @#error "More than one scenario selected"
@#endif

@#include "baseline_model2.mod"

@#include "baseline_shocks2.mod" 

simul(periods = 1000, stack_solve_algo=6); 
























































































