% =========================================================================
% Function: Solve_KPB (Algorithm 4)
% Description: The main wrapper for solving the standard 0-1 Knapsack.
%              Initializes memory, invokes Algorithm 3, and reconstructs 
%              the optimal decision vector.
% =========================================================================
function [x_star, opt_value] = Solve_KPB(n, W_cap)
    % Call globals to align with Algorithm 3
    global zKP Pred weights_g;
    
    % Step 1: Memory Preallocation (Critical for MATLAB performance)
    % Initialized to n+1 and W_cap+1 to match the j_idx and w_idx offsets
    zKP = -inf(n + 1, W_cap + 1);
    Pred = zeros(n + 1, W_cap + 1);
    
    % Step 2: Execute Backward Recursion (Algorithm 3)
    opt_value = KPB(n, W_cap);
    
    % Step 3: Optimal Path Reconstruction
    w_rem = W_cap;
    x_star = zeros(1, n);
    
    % Backtrack through the Pred matrix
    for j = n:-1:1
        % Read from j+1 to perfectly match the alignment in KPB.m
        if Pred(j + 1, w_rem + 1) > 0
            x_star(j) = 1;                  % Item j was selected
            w_rem = w_rem - weights_g(j);   % Reduce available capacity
        else
            x_star(j) = 0;                  % Item j was excluded
        end
    end
end