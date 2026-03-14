function z = KPB_kBest_Bound(j, w, k_idx)
    % Unified globals to match the diagnostic script and Alg 8
    global zKP Pred k_count k1 k2 weights_g profits_g
    
    w_idx = w + 1; % 1-based indexing for capacity
    j_idx = j + 1; % 1-based indexing alignment for items (CRITICAL FIX)
    
    % Base case: Stage 0
    if j == 0
        if k_idx == 1
            z = 0; 
        else
            z = -inf; 
        end
        return;
    end
    
    % Memoization Check: Look in j_idx floor
    if k_idx <= k_count(j_idx, w_idx)
        z = zKP(j_idx, w_idx, k_idx); 
        return;
    end
    
    % Recursive call 1 (Item not selected)
    z1 = KPB_kBest_Bound(j-1, w, k1(j_idx, w_idx));
    
    % Recursive call 2 (Item selected)
    if w >= weights_g(j)
        z2 = KPB_kBest_Bound(j-1, w-weights_g(j), k2(j_idx, w_idx)) + profits_g(j);
    else
        z2 = -inf;
    end
    
    % Prevent dead-ends
    if z1 == -inf && z2 == -inf
        z = -inf; 
        return;
    end
    
    % Merge and State Updates (Saving in j_idx to match Alg 8 extraction)
    if z1 >= z2
        Pred(j_idx, w_idx, k_idx) = -k1(j_idx, w_idx);
        k1(j_idx, w_idx) = k1(j_idx, w_idx) + 1;
        zKP(j_idx, w_idx, k_idx) = z1;
    else
        Pred(j_idx, w_idx, k_idx) = k2(j_idx, w_idx);
        k2(j_idx, w_idx) = k2(j_idx, w_idx) + 1;
        zKP(j_idx, w_idx, k_idx) = z2;
    end
    
    k_count(j_idx, w_idx) = k_idx;
    z = zKP(j_idx, w_idx, k_idx);
end