function [Wlocal] = ConstructingWeightingMatrix(Cosup,t1_feature,t2_feature)
[h,w]   = size(Cosup);
nbr_sp  = max(Cosup(:));
idx_t1 = label2idx(Cosup);
for i = 1:nbr_sp
    index_vector = idx_t1{i};
    [location_x, location_y] = ind2sub(size(Cosup),index_vector);
    location_center(i,:) = [round(mean(location_x)) round(mean(location_y))];
end
%%  Spatially-adjacent
adj_mat = zeros(nbr_sp);
for i=2:h-1
    for j=2:w-1
        label = Cosup(i,j);
        if (label ~= Cosup(i+1,j-1))
            adj_mat(label, Cosup(i+1,j-1)) = 1;
        end
        if (label ~= Cosup(i,j+1))
            adj_mat(label, Cosup(i,j+1)) = 1;
        end
        if (label ~= Cosup(i+1,j))
            adj_mat(label, Cosup(i+1,j)) = 1;
        end
        if (label ~= Cosup(i+1,j+1))
            adj_mat(label, Cosup(i+1,j+1)) = 1;
        end
    end
end
adj_mat_1 = double((adj_mat + adj_mat')>0);

R = 2*round(sqrt(h*w/nbr_sp));
adj_mat = zeros(nbr_sp);
for i=1:nbr_sp
    for j = i:nbr_sp
        if ((location_center(i,1) - location_center(j,1))^2 + (location_center(i,2) - location_center(j,2))^2 < R^2)
            adj_mat (i,j) = 1;
        end
    end
end
adj_mat = double((adj_mat + adj_mat')>0);
adj_mat_2 = adj_mat - eye(nbr_sp);
adj_mat = adj_mat_1|adj_mat_2;
%% Elc
[node_x, node_y] = find(adj_mat ==1);
for i = 1:sum(adj_mat(:))
    index_node_x = node_x(i);
    index_node_y = node_y(i);
    feature_t1_x = t1_feature(:,index_node_x);
    feature_t1_y = t1_feature(:,index_node_y);
    feature_t2_x = t2_feature(:,index_node_x);
    feature_t2_y = t2_feature(:,index_node_y);
    Dxy_t1(i) = norm(feature_t1_x-feature_t1_y,2)^2;
    Dxy_t2(i) = norm(feature_t2_x-feature_t2_y,2)^2;
    dist(i) = max(norm(location_center(index_node_x,:)-location_center(index_node_y,:),2),1);
end
rho_t1 = mean(Dxy_t1);
rho_t2 = mean(Dxy_t2);

for i =  1:sum(adj_mat(:))
    if Dxy_t1(i) > rho_t1 && Dxy_t2(i) > rho_t2
        Vxy(i) = 1/2;
    else
        sig_temp = 2*(Dxy_t1(i)-rho_t1)*(Dxy_t2(i) - rho_t2)/rho_t1/rho_t2;
        Vxy(i) = sigmoid(sig_temp);
    end
end
Vxy = Vxy ./dist;
Wlocal = zeros(nbr_sp);
for i =  1:sum(adj_mat(:))
    Wlocal(node_x(i),node_y(i)) = Vxy(i);
end
    
    

