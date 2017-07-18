i = [28, 59, 72, 80, 142, 159];
for j = 1: length(i)
X = strcat('Trial: ',num2str(i(j)));
disp(X);
% solve for NoConstraints and Planar Constraints and Planar & Angular Constraints
test_AngularConstraints(i(j),1) 
% solve for Planar & Angular Constraints starting from NoConstraints solution
test_AngularConstraints(i(j),2) 
% solve for Planar & Angular Constraints starting from Planar solution
test_AngularConstraints(i(j),3) 
end
