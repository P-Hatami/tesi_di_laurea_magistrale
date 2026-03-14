function Generate_States(j, w, k_max)
    % Added 'A' to the global memory to use it as a pruning sword
    global zKP Pred k_count weights_g profits_g A_map;

    w_idx = w + 1; 
    
    % +++ REAL PRUNING INJECTED HERE +++
    % If the Oracle says capacity 'w' at stage 'j+1' cannot reach W, PRUNE IT!
    if isempty(A_map) == 0 && A_map(w_idx, j + 1) == 0
        return; % Abort generating this state entirely (Saves 80% of time!)
    end
    % ++++++++++++++++++++++++++++++++++

    k_prime = 1; k1 = 1; k2 = 1;
    wj = weights_g(j);
    pj = profits_g(j);
    
    curr_floor = j;
    next_floor = j + 1;
    
    k1_max = k_count(curr_floor, w_idx);
    k2_max = 0; 
    if w >= wj 
        k2_max = k_count(curr_floor, w - wj + 1); 
    end
    
    while (k1 <= k1_max || k2 <= k2_max) && k_prime <= k_max
        l = 0; 
        z_t = -inf;
        
        if k1 <= k1_max 
            v1 = zKP(curr_floor, w_idx, k1);
            if z_t < v1, l = -k1; z_t = v1; end
        end
        
        if k2 <= k2_max 
            v2 = zKP(curr_floor, w - wj + 1, k2) + pj;
            if z_t < v2, l = k2; z_t = v2; end
        end
        
        if l ~= 0
            zKP(next_floor, w_idx, k_prime) = z_t;
            Pred(next_floor, w_idx, k_prime) = l;
            if l < 0, k1 = k1 + 1; else, k2 = k2 + 1; end
            k_prime = k_prime + 1;
        else
            break; 
        end
    end
    
    k_count(next_floor, w_idx) = k_prime - 1;
end