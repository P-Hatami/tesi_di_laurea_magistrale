% =========================================================================
% Function: KPB (Algorithm 3)
% Description: Standard 0-1 Knapsack backward recursive engine.
%              Evaluates the optimal path using memoization to ensure O(nW).
% =========================================================================
function z = KPB(j, w)
    % Unified global variables to prevent memory overhead during recursion
    global zKP Pred weights_g profits_g;
    
    % Architectural offsets for MATLAB's 1-based indexing
    w_idx = w + 1; 
    j_idx = j + 1; 
    
    % Base case: Stage 0 (No items left to consider)
    if j == 0
        z = 0; 
        return;
    end
    
    % Memoization Check: Return immediately if state is already computed
    if zKP(j_idx, w_idx) ~= -inf
        z = zKP(j_idx, w_idx);
        return;
    end
    
    % Recursive call 1: Item j is NOT included
    z1 = KPB(j - 1, w);
    
    % Recursive call 2: Item j IS included (if capacity permits)
    if w >= weights_g(j)
        z2 = KPB(j - 1, w - weights_g(j)) + profits_g(j);
    else
        z2 = -inf;
    end
    
    % State Evaluation and Predecessor Tracking
    if z1 >= z2
        z = z1;
        Pred(j_idx, w_idx) = 0; % 0 indicates item was excluded
    else
        z = z2;
        Pred(j_idx, w_idx) = 1; % 1 indicates item was included
    end
    
    % Store the computed optimal value in the memoization table
    zKP(j_idx, w_idx) = z;
end