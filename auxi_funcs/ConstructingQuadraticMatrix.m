function [Batt,Brep,Bsmo] = ConstructingQuadraticMatrix(t1_feature,t2_feature,S_t1,R_t1,S_t2,R_t2,Cosup,par)
dist_t1 = pdist2(t1_feature',t1_feature','squaredeuclidean');
dist_t2 = pdist2(t2_feature',t2_feature','squaredeuclidean');
Sdist_t1 = S_t1.*dist_t1;
Sdist_t2 = S_t2.*dist_t2;
Rdist_t1 = R_t1.*dist_t1;
Rdist_t2 = R_t2.*dist_t2;
N = size(t1_feature,2);
f1 = zeros(N);
f3 = zeros(N);
f2 = zeros(N);
f4 = zeros(N);
f5 = zeros(N);
f6 = zeros(N);
for i = 1: N
    th_x(i) = max(Sdist_t1(i,:));
    th_y(i) = max(Sdist_t2(i,:));
end
fuhao_t1 = sign(dist_t2- repmat(th_y,[N 1]));
fuhao_t2 = sign(dist_t1- repmat(th_x,[N 1]));

f1 = S_t1.*dist_t2 ;
f3 = S_t2.*dist_t1 ;
f1 =  f1.*((fuhao_t1+1)/2);
f3 =  f3.*((fuhao_t2+1)/2);

f2 = S_t1.*exp(-dist_t2) ;
f4 = S_t2.*exp(-dist_t1) ;
f2 =  f2.*((-fuhao_t1+1)/2);
f4 =  f4.*((-fuhao_t2+1)/2);

f5 = R_t1.*exp(-dist_t2) ;
f6 = R_t2.*exp(-dist_t1) ;
f5 =  f5.*((-fuhao_t1+1)/2);
f6 =  f6.*((-fuhao_t2+1)/2);

f1 = f1-diag(diag(f1));
f2 = f2-diag(diag(f2));
f3 = f3-diag(diag(f3));
f4 = f4-diag(diag(f4));
f5 = f5-diag(diag(f5));
f6 = f6-diag(diag(f6));


Batt = f1 +   (sum(f1(:))/sum(f3(:))) * f3;
Brep = f5 +   (sum(f5(:))/sum(f6(:))) * f6;
Bsmo = f2 +   (sum(f2(:))/sum(f4(:))) * f4;


