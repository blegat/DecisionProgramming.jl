using Logging, Test, Random, JuMP, GLPK
using DecisionProgramming

rng = MersenneTwister(4)

@info "Creating the influence diagram."
C, D, V = random_diagram(rng, 4, 2, 3, 2)
S = States(rng, [2, 3], length(C) + length(D))
X = [Probabilities(rng, c, S) for c in C]
Y = [Consequences(rng, v, S) for v in V]

S, C, D, V, X, Y = validate_influence_diagram(S, C, D, V, X, Y)
P = PathProbability(C, X)
U = DefaultPathUtility(V, Y)

@info("Creating random decision strategy")
Z_j = [DecisionStrategy(rng, d, S) for d in D]
Z = GlobalDecisionStrategy(D, Z_j)

@info "Analyzing results."
udist = UtilityDistribution(S, P, U, Z)
sprobs = StateProbabilities(S, P, Z)

@info "Printing results"
print_decision_strategy(S, Z)
print_utility_distribution(udist)
print_state_probabilities(sprobs, [c.j for c in C])
print_state_probabilities(sprobs, [d.j for d in D])
print_statistics(udist)
print_risk_measures(udist, [0.0, 0.05, 0.1, 0.2, 1.0])
