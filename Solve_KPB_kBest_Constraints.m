% =========================================================================
% Function: Solve_KPB_kBest_Constraints
% Description: Algorithm 8 (Constraints Validation for k-Best Knapsack)
% =========================================================================
function [fX, fZ] = Solve_KPB_kBest_Constraints(n, W, k_lim, z_min)
    global zKP Pred weights_g; 
    act_sol = 0; 
    kp = 1; 
    fX = []; 
    fZ = []; 
    
    while act_sol < k_lim
        % Call the global recursive engine (Algorithm 5)
        z_v = KPB_kBest_Bound(n, W, kp);
        
        % Termination condition: Minimum profit threshold reached or exhausted paths
        if z_v < z_min || z_v == -inf
            break; 
        end
        
        % Path Reconstruction logic
        tmp_x = zeros(1, n); 
        c_k = kp; 
        w_ptr = W;
        
        for j = n:-1:1
            w_idx = w_ptr + 1; % Architectural offset for MATLAB 1-based indexing
            p_v = Pred(j+1, w_idx, c_k);
            
            if p_v > 0
                % Item j is included
                tmp_x(j) = 1; 
                w_ptr = w_ptr - weights_g(j); 
                c_k = p_v;
            else
                % Item j is excluded
                tmp_x(j) = 0; 
                c_k = abs(p_v); 
            end
        end
        
        % Validation against Side Constraints
        if check_feasibility(tmp_x) 
            act_sol = act_sol + 1;
            fX(act_sol, :) = tmp_x; 
            fZ(act_sol) = z_v;
        end
        
        kp = kp + 1; % Move to the next theoretical k-best candidate
    end
end

% =========================================================================
% Local Function: check_feasibility
% Description: Evaluates secondary side-constraints on the extracted vector
% =========================================================================
function is_feasible = check_feasibility(x_vector)
    % Define any problem-specific side constraints here.
    % Example: Mutually exclusive items (item 1 and 2 cannot be selected together)
    % if x_vector(1) == 1 && x_vector(2) == 1
    %     is_feasible = false;
    %     return;
    % end
    
    % Default behavior: If no specific constraints are violated, return true
    is_feasible = true;
end