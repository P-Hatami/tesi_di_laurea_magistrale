% =========================================================================
% Function: Generate_Active_States (Algorithm 9)
% Description: Constructs the Boolean reachability matrix (A) to prune 
%              the state-space. A(w+1, j) = 1 implies that reaching 
%              the target capacity W is possible from state (j, w).
% =========================================================================
function A = Generate_Active_States(n, W)
    global weights_g; % Unified memory
    
    A = zeros(W + 1, n + 1); 
    A(W + 1, n + 1) = 1; % Base case: target capacity W is exactly reachable
    
    % Backward traversal from item n down to 1
    for j = n:-1:1
        for w = 0:W
            idx_w = w + 1; % 1-based indexing offset
            
            % Step 1: Carry over previous reachability (Item j NOT included)
            A(idx_w, j) = A(idx_w, j + 1);
            
            % Step 2: Check if including item j leads to a valid future state
            if w + weights_g(j) <= W
                idx_w_next = w + weights_g(j) + 1; 
                
                if A(idx_w_next, j + 1) == 1
                    A(idx_w, j) = 1;
                end
            end
        end
    end
end