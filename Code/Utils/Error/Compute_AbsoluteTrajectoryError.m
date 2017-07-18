function [r_f_translation_error,r_f_rotation_error,...
    r_f_squared_translation_error,r_f_squared_rotation_error] = ...
    Compute_AbsoluteTrajectoryError(est_vertices,gt_vertices,v_rel_pose)

r_f_translation_error = 0;
r_f_rotation_error = 0;
r_f_squared_translation_error = 0;
r_f_squared_rotation_error = 0;

% number of degrees per one radian (for angular unit conversion)
f_deg_per_rad = 180/pi;

assert(isequal(size(est_vertices),size(gt_vertices)));
n = size(est_vertices,2);
for i = 1:n

    % put the ground truth vertex in the solution coordinate frame
    v_gt_pose = RelativeToAbsolutePose(v_rel_pose, gt_vertices(:,i));
    
    % calculate the errors
    v_error = AbsoluteToRelativePose(est_vertices(:,i), v_gt_pose);
    f_trans_error2 = norm(v_error(1:3))^2;
    r_f_translation_error = r_f_translation_error + sqrt(f_trans_error2);
    r_f_squared_translation_error = r_f_squared_translation_error + f_trans_error2;
    f_rot_error_degrees = wrapToPi(norm(v_error(4:6))) * f_deg_per_rad;
    r_f_rotation_error = r_f_rotation_error + f_rot_error_degrees;
    r_f_squared_rotation_error = r_f_squared_rotation_error + f_rot_error_degrees * f_rot_error_degrees;
    
end

% normalise errors by number of vertices
r_f_translation_error = r_f_translation_error/n;
r_f_rotation_error = r_f_rotation_error/n;
r_f_squared_translation_error = r_f_squared_translation_error/n; 
r_f_squared_rotation_error = r_f_squared_rotation_error /n;


end
