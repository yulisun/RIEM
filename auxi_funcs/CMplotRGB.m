function ROI_idx_int = CMplotRGB(CM,Ref_gt)
ROI_idx_int (:,:,1)= (Ref_gt & CM) |(~Ref_gt & CM);
ROI_idx_int(:,:,2) = (Ref_gt & CM) |  (Ref_gt & ~CM);
ROI_idx_int(:,:,3) = (Ref_gt & CM)|  (Ref_gt & ~CM);
ROI_idx_int = double(ROI_idx_int);

% ROI_idx_int (:,:,1)= (Ref_gt & CM) | (~Ref_gt & CM);
% ROI_idx_int(:,:,2) = (Ref_gt & CM) | (Ref_gt & ~CM);
% ROI_idx_int(:,:,3) = (Ref_gt & CM);
% ROI_idx_int = double(ROI_idx_int);