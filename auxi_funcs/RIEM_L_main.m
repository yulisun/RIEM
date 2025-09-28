function [CM] = RIEM_L_main(image_t1,image_t2,par)
%% superpixe segmentation
[Cosup,~] = GMMSP_Cosegmentation(image_t1,image_t2,par.Ns);
[t1_feature,t2_feature] = MMfeatureExtraction(Cosup,image_t1,image_t2);
Ns = size(t1_feature,2);
par.kmax =round(Ns.^0.5);
par.kF = 5*par.kmax;
[S_t1,R_t1] = StructureRepresentation (t1_feature,par);
[S_t2,R_t2] = StructureRepresentation (t2_feature,par);
%% Constructing Matrix
[Batt,Brep,Bsmo] = ConstructingQuadraticMatrix(t1_feature,t2_feature,S_t1,R_t1,S_t2,R_t2,Cosup,par);
[Wlocal] = ConstructingWeightingMatrix(Cosup,t1_feature,t2_feature);
Ball = Batt + sum(Batt(:))/sum(Brep(:))*Brep;
Wall = Wlocal + sum(Wlocal(:))/sum(Bsmo(:))*Bsmo;
p = (sum(Ball,2) + sum(Ball',2))/2;
p = (p-min(p))/(max(p)-min(p));
T_theory = graythresh(p);
potsu = (sign(p-T_theory) + 1)/2;
initLabeling = 2-potsu;

%% Wall Elc_edgeWeights
[node_x, node_y] = find(Wall ~=0);
Elc_edgeWeights = zeros(length(node_x),6);
Elc_edgeWeights(:,1) = node_x; % index of node 1
Elc_edgeWeights(:,2) = node_y; % index of node 2
for i = 1:length(node_x)
    Elc_edgeWeights(i,4) = Wall(node_x(i),node_y(i));
end
Elc_edgeWeights(:,5) =  Elc_edgeWeights(:,4);
%%  Ball  Esc_edgeWeights
[node_x, node_y] = find(Ball ~=0);
Esc_edgeWeights = zeros(length(node_x),6);
Esc_edgeWeights(:,1) = node_x; % index of node 1
Esc_edgeWeights(:,2) = node_y; % index of node 2
for i = 1:length(node_x)
    Esc_edgeWeights(i,6) = Ball(node_x(i),node_y(i));
end
%% E
lambda = par.beta* (sum(Ball(:))/Ns);
alfalc = par.alpha *(sum(Ball(:))/sum(Wall(:)));
Esp_termWeights = zeros(size(t1_feature,2),2);
Esp_termWeights (:,1) = lambda;
Elc_edgeWeights(:,3:6) = alfalc*Elc_edgeWeights(:,3:6);

final_edgeWeights = [Esc_edgeWeights;Elc_edgeWeights];
idx_selfloop = find(final_edgeWeights(:,1) ==final_edgeWeights(:,2));
final_edgeWeights(idx_selfloop,:) =[];
%%
addpath('LSA_TR_v2.03');addpath('LSA_TR_v2.03\bk_matlab')
[energy.UE, energy.subPE, energy.superPE, energy.constTerm] = reparamEnergy(Esp_termWeights', final_edgeWeights);
[labels_LSA, ~, ~] = LSA_TR(energy,[],initLabeling,[]);
if labels_LSA == 1
    [labels_LSA, ~, ~] = LSA_TR(energy);
end
if labels_LSA == 1
   error('Error: LSA_TR numerical solution is unstable! It is recommended to run the code in Matlab2016a or use the RIEM-O algorithm!');
end
idx_co = label2idx(Cosup);
for i = 1:size(t1_feature,2)
    index_vector = idx_co{i};
    bi_map(index_vector) = 2-labels_LSA(i);
end
CM = reshape(bi_map,[size(Cosup,1) size(Cosup,2)]);


