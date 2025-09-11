clear;
close all
addpath(genpath(pwd))
warning('off')
%% load dataset

% dataset#1 to #9, where dataset#1-#7 are used in the paper.
% #1-Italy #2-TexasALI #3-Img7 #4-Img17 #5-California #5-California-sampled
% #6-YellowRiver #7-Img5 #8-TexasL8 #9-Shuguang

dataset = '#1-Italy'; % or others
Load_dataset % For other datasets, we recommend a similar pre-processing as in "Load_dataset"
fprintf(['\n Data loading is completed...... ' '\n'])

%% Parameter setting
par.solve = 'RIEM-L'; % 'RIEM-L' or 'RIEM-O' ; different methods of RIEM
par.dataset = dataset;
par.Ns = 2500;
par.alpha = 15;
par.beta = 1;
par

%% RIEM
t_o = clock;
fprintf(['\n RIME is running...... ' '\n'])
if strcmp(par.solve,'RIEM-O') == 1
    [DI,CM] = RIEM_O_main(image_t1,image_t2,par);
elseif strcmp(par.solve,'RIEM-L') == 1
    [CM] = RIEM_L_main(image_t1,image_t2,par);
end
fprintf('\n');fprintf('The total computational time of %s is %.3f s\n', par.solve, etime(clock, t_o));
fprintf(['\n' '====================================================================== ' '\n'])

%% Displaying results
fprintf(['\n Displaying the results...... ' '\n'])
figure;
if strcmp(par.solve,'RIEM-O') == 1
    subplot(131);imshow(remove_outlier(DI),[]);title('Difference image')
    subplot(132);imshow(CMplotRGB(CM,Ref_gt));title('Change map')
    subplot(133);imshow(Ref_gt,[]);title('Ground truth')
elseif strcmp(par.solve,'RIEM-L') == 1
    subplot(121);imshow(CMplotRGB(CM,Ref_gt));title('Change map')
    subplot(122);imshow(Ref_gt,[]);title('Ground truth')
end
[tp,fp,tn,fn,fplv,fnlv,~,~,OA,kappa]=performance(CM,Ref_gt);
F1 = 2*tp/(2*tp+fp+fn);
result = '%s: OA is %4.3f; Kc is %4.3f; F1 is %4.3f \n';
fprintf(result,par.solve,OA,kappa,F1)
