function [Sp,R_en] = StructureRepresentation (X,par)
X = X';
N = size(X,1);
S = zeros(N,N);
R = zeros(N,N);
[idx,distX] = knnsearch(X,X,'k',N);
Kn = par.kmax;
Kf = par.kF;
idx_att = idx(:,1:Kn);
idx_rep = fliplr(idx(:,end-Kf+1:end));
for i = 1:N
    id_x = idx_att(i,1:Kn);
    S(i,id_x) = 1;
end
for i = 1:N
    id_x = idx_rep(i,1:Kf);
    R(i,id_x) = 1;
end
Sp=sparse(S);
Rp = sparse(R);
if strcmp(par.solve,'RIEM-O') == 1
    Sp = Sp + Sp * Sp  + Sp* Sp* Sp;
    Rp = Rp + Sp*Rp + Rp*Sp;
end
R_en = full(Rp);
R_en = sign(R_en);
Sp = full(Sp);
Sp = sign(Sp);

