function points = generatePlanePointsSimulation(nPoints, basePoint, lengthAlongAxis1, lengthAlongAxis2, parallelAxes)
% restricted to generating points on planes that are orthogonal to the 3
% main axes x,y and z

switch parallelAxes
    case('XY')
        points   = [lengthAlongAxis1*rand(1,nPoints);lengthAlongAxis2*rand(1,nPoints);zeros(1,nPoints)]...
            + [basePoint(1),basePoint(2),basePoint(3)]'*ones(1,nPoints);
    case('XZ')
        points = [lengthAlongAxis1*rand(1,nPoints);zeros(1,nPoints);lengthAlongAxis2*rand(1,nPoints)] ...
            + [basePoint(1),basePoint(2),basePoint(3)]'*ones(1,nPoints);
    case('YZ')
        points = [zeros(1,nPoints);lengthAlongAxis1*rand(1,nPoints);lengthAlongAxis2*rand(1,nPoints)] ...
            + [basePoint(1),basePoint(2),basePoint(3)]'*ones(1,nPoints);
    otherwise
            error('undefined parallel axes')
end
end
