% =========================================================================
% Function: Solve_KPB_kBest (Algorithm 6)
% Description: Wrapper function that initializes memory, sequentially invokes
%              Algorithm 5 to find up to k_max solutions, and reconstructs 
%              the optimal decision vectors via backtracking.
% =========================================================================
function [X_opt, Z_opt] = Solve_KPB_kBest(n, W_cap, k_max)
    global zKP Pred k_count k1 k2 weights_g;
    
    % --- Phase 1: Memory Pre-allocation ---
    zKP = -inf(n + 1, W_cap + 1, k_max);
    Pred = zeros(n + 1, W_cap + 1, k_max);
    k_count = zeros(n + 1, W_cap + 1);
    k1 = ones(n + 1, W_cap + 1);
    k2 = ones(n + 1, W_cap + 1);
    
    % --- Phase 2: Invoke Backward Recursion (Algorithm 5) ---
    for kp = 1:k_max
        z_val = KPB_kBest(n, W_cap, kp); 
        if z_val == -inf
            break; % Terminate early if state-space is exhausted
        end
    end
    
    % --- Phase 3: Path Reconstruction (Backtracking) ---
    actual_k = k_count(n + 1, W_cap + 1); 
    X_opt = zeros(actual_k, n); 
    Z_opt = zeros(actual_k, 1);
    
    for k_idx = 1:actual_k
        kp_ptr = k_idx;    
        w_ptr = W_cap;     
        Z_opt(k_idx) = zKP(n + 1, W_cap + 1, k_idx); % Store the profit
        
        % Backward traversal
        for j = n:-1:1     
            w_idx = w_ptr + 1; 
            p_val = Pred(j + 1, w_idx, kp_ptr);
            
            if p_val > 0   
                % Item j was SELECTED
                X_opt(k_idx, j) = 1;
                kp_ptr = p_val;           
                w_ptr = w_ptr - weights_g(j); 
            else           
                % Item j was NOT SELECTED
                X_opt(k_idx, j) = 0;
                kp_ptr = abs(p_val);      
            end
        end
    end
end