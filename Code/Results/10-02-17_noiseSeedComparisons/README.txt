Previous testing suggested that even when no constraints applied, drift increased if points were close to planes as opposed to more widely distributed.
This should not be happening.

Experiments with points close and far from planes show that this was observed because the random noise was fixed. The figures in this folder show that arrangement of points does not effect drift.
Titles of figures include rngSeed used.
Noise levels used were:

stdPosePose    = [0.02,0.02,0.02,pi/90,pi/90,pi/90]';
stdPosePoint   = [0.02,0.02,0.02]';

stdSurface     = 0.01;
OR
stdSurface     = 100*0.01;
