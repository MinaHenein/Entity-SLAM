function [visible,varargout] = checkObservation(obj,config,i,pointPositionAbsolute)
%CHECKOBSERVATION checks if camera observes point at time i
%   input: camera, time, point position in global coordinates
%   output: visible (0/1), position of point w.r.t. camera, in camera frame
%
%   point is visible if range and bearing from camera are within camera
%   field of view

%   pose of camera at time i
cameraPose = obj.pose(:,i);
%   relative position of point from camera
pointPositionRelative = config.absoluteToRelativePointHandle(cameraPose,pointPositionAbsolute);
% pointPositionRelative = AbsoluteToRelativePosition(cameraPose,pointPositionAbsolute);
% pointPositionRelative = AbsolutePoint2RelativePoint3D(cameraPose,pointPositionAbsolute);

%   convert relative position to spherical coordinates
bearing = atan2(pointPositionRelative(1),pointPositionRelative(3));
elevation = atan2(pointPositionRelative(2,:),...
                  sqrt(pointPositionRelative(1,:).^2 + pointPositionRelative(3,:).^2));
%   check if within FOV
if (obj.fieldOfView(1) <= bearing) && (bearing <= obj.fieldOfView(2)) && ...
   (obj.fieldOfView(3) <= elevation) && (elevation <= obj.fieldOfView(4)) && ...
   norm(pointPositionRelative) <= obj.maxRange
    visible = 1;
else
    visible = 0;
end

switch nargout
    case 2
        %output relative pose
        varargout{1} = pointPositionRelative;
end

end

