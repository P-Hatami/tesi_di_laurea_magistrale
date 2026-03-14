% =========================================================================
% Function: Solve_KPB_Forward (Algorithm 2)
% Description: The main wrapper for Forward DP. Initializes memory, loops 
%              through all stages/capacities to build the state-space, 
%              and reconstructs the k-best paths.
% =========================================================================
function [X_opt, Z_opt] = Solve_KPB_Forward(n, W_cap, k_max)
    global zKP Pred k_count weights_g;
    
    % --- Phase 1: Initialization ---
    zKP = -inf(n + 1, W_cap + 1, k_max);
    Pred = zeros(n + 1, W_cap + 1, k_max);
    k_count = zeros(n + 1, W_cap + 1);
    
    % Base Case Setup: Stage 0, Capacity 0 has exactly 1 path with 0 profit
    zKP(1, 1, 1) = 0;
    k_count(1, 1) = 1;
    
    % --- Phase 2: Forward Generation Loop ---
    for j = 1:n
        for w = 0:W_cap
            % Generate states for item j at capacity w
            Generate_States(j, w, k_max);
        end
    end
    
    % --- Phase 3: Build k* solutions ---
    k_star = k_count(n + 1, W_cap + 1); 
    X_opt = zeros(k_star, n);
    Z_opt = zeros(k_star, 1);
    
    for k_idx = 1:k_star
        curr_k = k_idx;
        curr_w = W_cap + 1;
        Z_opt(k_idx) = zKP(n + 1, W_cap + 1, k_idx); % Save the profit
        
        % Traceback through the predecessor matrix
        for j = n:-1:1
            if Pred(j + 1, curr_w, curr_k) > 0 
                X_opt(k_idx, j) = 1;
                curr_k = Pred(j + 1, curr_w, curr_k);
                curr_w = curr_w - weights_g(j);
            else
                X_opt(k_idx, j) = 0;
                curr_k = -Pred(j + 1, curr_w, curr_k);
            end
        end
    end
end