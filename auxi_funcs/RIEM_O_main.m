function [DI,CM] = RIEM_O_main(image_t1,image_t2,par)
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
Llocal = LaplacianMatrix(Wlocal);
Lbsmo = LaplacianMatrix(Bsmo);
Llocal = Llocal + sum(Wlocal(:))/sum(Bsmo(:))*Lbsmo;
Ball = Batt + sum(Batt(:))/sum(Brep(:))*Brep;
Wall = Wlocal + sum(Wlocal(:))/sum(Bsmo(:))*Bsmo;
BTBall = Ball + Ball';
p = (sum(Ball,2) + sum(Ball',2))/2;
p = p/max(p);
%% RIEM-O
v = 0;
par.delt = 0.001;
dataset = par.dataset;
if strcmp(dataset,'#2-TexasALI') == 1 || strcmp(dataset,'#4-Img17') == 1  || strcmp(dataset,'#5-California') == 1 || strcmp(dataset,'#7-Img5') == 1  || strcmp(dataset,'#8-TexasL8') == 1
    par.alpha = 15;
elseif strcmp(dataset,'#1-Italy') == 1 || strcmp(dataset,'#3-Img7') == 1 || strcmp(dataset,'#6-YellowRiver') == 1 || strcmp(dataset,'#9-Shuguang') == 1 
    par.alpha = 25;
else
    par.alpha = 20;
end
alpha = par.alpha *(sum(Ball(:))/sum(Wall(:)));
beta = par.beta * (sum(Ball(:))/Ns) * (2^(-4));
par.Niter = 50;
for i = 1 : par.Niter
    p_old = p;
    p (p < 0) = 0;
    p (p > 1) = 1;
    
    Gradient = (BTBall) * (p-ones(Ns,1)) + 4 *alpha*Llocal*p + beta * ones(Ns,1)+10*(ones(Ns,1)-2*p);
    v = 0.5*v + 0.5*Gradient;
    p = p - par.delt*Gradient;
    par.delt = par.delt * 0.9;
    
    Rel_diff(i) = norm(p - p_old)/(norm(p)+eps);
    if i>30 && Rel_diff(i) < 10^-3
        break;
    end
end
p = (p-min(p))/(max(p)-min(p));
%% output DI and CM
Label_otsu = (sign(p-graythresh(p)) + 1)/2;
idx_co = label2idx(Cosup);
for i = 1:size(p)
    index_vector = idx_co{i};
    DI_map(index_vector) = p(i);
    CM_map(index_vector) = Label_otsu(i);
end
DI  =reshape(DI_map,[size(Cosup,1) size(Cosup,2)]);
CM  =reshape(CM_map,[size(Cosup,1) size(Cosup,2)]);

