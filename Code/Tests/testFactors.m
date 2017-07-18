clear all
clear classes
close all
addpath(genpath(pwd))

pose = [1 2 3 0 0 pi/2]';
point = [2 3 4]';

poseSE3 = R3xso3_LogSE3(pose);

AbsoluteToRelativePosition(pose,point)
RelativeToAbsolutePosition(pose,AbsoluteToRelativePosition(pose,point))

AbsolutePoint2RelativePoint3D(poseSE3,point)
RelativePoint2AbsolutePoint3D(poseSE3,AbsolutePoint2RelativePoint3D(poseSE3,point))

AbsolutePoints2RelativePoints3D(poseSE3,[point point])
RelativePoints2AbsolutePoints3D(poseSE3,AbsolutePoint2RelativePoint3D(poseSE3,[point point]))