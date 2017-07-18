function [points, planes] = generateCubePoints(sideLength, nPoints)

N = 3; 
d = randi(N,1,nPoints);  
s = randi(2,1,nPoints)-1;  
points = rand(N,nPoints);  
for i=1:nPoints  
  points(d(i),i)=s(i);  
end 
points = sideLength*points;

planes= zeros(1,nPoints);
for i=1:nPoints
    if(points(1,i)==0)
        planes(1,i) = 1;
    end
    if(points(2,i)==0)
        planes(1,i) = 3;
    end
    if(points(3,i)==0)
        planes(1,i) = 5;
    end
    if(points(1,i)==sideLength)
        planes(1,i) = 2;
    end
    if(points(2,i)==sideLength)
        planes(1,i) = 4;
    end
    if(points(3,i)==sideLength)
        planes(1,i) = 6;
    end
end
