clear;
close all
addpath(genpath(pwd))
warning('off')
%% load dataset
% dataset#1 to #9, where dataset#1-#7 are used in the paper.
% #1-Italy #2-TexasALI #3-Img7 #4-Img17 #5-California #5-California-sampled
% #6-YellowRiver #7-Img5 #8-TexasL8 #9-Shuguang

dataset = '#9-Shuguang'; % or others
Load_dataset % For other datasets, we recommend a similar pre-processing as in "Load_dataset"
fprintf(['\n Data loading is completed...... ' '\n'])

%% RIEM-L
t_o = clock;
fprintf(['\n RIME-L is running...... ' '\n'])
time = clock;
[CM] = RIEM_main(image_t1,image_t2);
fprintf('\n');fprintf('The total computational time of RIEM-L is %i \n',etime(clock,t_o));
fprintf(['\n' '====================================================================== ' '\n'])

%% Displaying results
fprintf(['\n Displaying the results...... ' '\n'])
figure;
subplot(121);imshow(CMplotRGB(CM,Ref_gt));title('Change map')
subplot(122);imshow(Ref_gt,[]);title('Ground truth')
[tp,fp,tn,fn,fplv,fnlv,~,~,OA,kappa]=performance(CM,Ref_gt);
F1 = 2*tp/(2*tp+fp+fn);
result = 'RIEM: OA is %4.3f; Kc is %4.3f; F1 is %4.3f \n';
fprintf(result,OA,kappa,F1)
