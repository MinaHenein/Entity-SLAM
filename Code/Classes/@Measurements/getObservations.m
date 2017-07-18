function [observationIndexes] = getObservations(obj,value,property)
%GETOBSERVATIONS returns indexes of observations where
%observation.(property) == value
%   inputs:
%       obj = Measurements Class instance
%       value = target property value
%       property = string, name of property desired

%get values of all observations, convert empty to NaN, store in array
propertyValues = {obj.observations.(property)}';
empties = cellfun('isempty',propertyValues);
propertyValues(empties) = {NaN};
propertyValues = cell2mat(propertyValues);

%find observations that have target value
iObservations = [propertyValues==value];
observationIndexes = [obj.observations(iObservations).index]';

