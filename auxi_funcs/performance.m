function [tp,fp,tn,fn,fplv,fnlv,abfplv,abfnlv,pcc,kappa,imw]=performance(cm,gt)
gt=double(gt(:,:,1));
cm=double(cm);
[A,B]=size(gt);N=A*B;
Nu=0;Nc=0;
imw=zeros(A,B);
Nu= sum(gt(:)== 0);
Nc = sum(gt(:)~= 0);
im = cm-gt;
fp = sum(im(:)>0);
fn = sum(im(:)<0);
tp = Nc-fn;
tn = Nu-fp;

tp=Nc-fn;tn=Nu-fp;
fplv=fp/N;fnlv=fn/N;
abfplv=fp/Nu;abfnlv=fn/Nc;
pcc=1-fplv-fnlv;

pra=(tp+tn)/N;pre=((tp+fp)*(tp+fn)+(fn+tn)*(fp+tn))/(N^2);
kappa=(pra-pre)/(1-pre);