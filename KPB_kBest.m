% =========================================================================
% Function: KPB_kBest_Recursive (Algorithm 5)
% Description: Core backward recursive engine for extracting the k-th best 
%              solution in an unconstrained knapsack state-space.
% =========================================================================
function z = KPB_kBest_Recursive(j, w, k_idx)
    % Unified global variables for state management
    global zKP Pred k_count k1 k2 weights_g profits_g;
    
    % Architectural offsets for MATLAB's 1-based indexing
    w_idx = w + 1;
    j_idx = j + 1;
    
    % Base Case: Stage 0 (Knapsack is empty / No items left)
    if j == 0
        if k_idx == 1
            z = 0;   % Feasible base state
        else
            z = -inf; % Non-existent k-best paths for empty knapsack
        end
        return;
    end
    
    % Memoization Check: Avoid redundant recursive calls
    if k_idx <= k_count(j_idx, w_idx)
        z = zKP(j_idx, w_idx, k_idx); 
        return;
    end
    
    % Branch 1: Exclude item j
    z1 = KPB_kBest(j - 1, w, k1(j_idx, w_idx));
    
    % Branch 2: Include item j (Check weight constraint)
    if w >= weights_g(j)
        z_prev = KPB_kBest(j - 1, w - weights_g(j), k2(j_idx, w_idx));
        if z_prev == -inf
            z2 = -inf;
        else
            z2 = z_prev + profits_g(j);
        end
    else
        z2 = -inf;
    end
    
    % Prune dead-end (exhausted) paths to prevent memory bloat
    if z1 == -inf && z2 == -inf
        z = -inf;
        return;
    end
    
    % State Merging and Path Indexing
    if z1 >= z2
        % Track exclusion branch with a negative index pointer
        Pred(j_idx, w_idx, k_idx) = -k1(j_idx, w_idx); 
        k1(j_idx, w_idx) = k1(j_idx, w_idx) + 1;
        zKP(j_idx, w_idx, k_idx) = z1;
        z = z1;
    else
        % Track inclusion branch with a positive index pointer
        Pred(j_idx, w_idx, k_idx) = k2(j_idx, w_idx);  
        k2(j_idx, w_idx) = k2(j_idx, w_idx) + 1;
        zKP(j_idx, w_idx, k_idx) = z2;
        z = z2;
    end
    
    % Update the local counter of discovered k-best solutions
    k_count(j_idx, w_idx) = k_idx;
end