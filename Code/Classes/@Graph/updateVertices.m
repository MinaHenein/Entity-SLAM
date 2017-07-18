function [obj] = updateVertices(obj,config,system,dVertices)
%UPDATEVERTICES updates vertices with vector dX
%   loop over vertices, increment values

for j = 1:obj.nVertices
    jBlock = blockMap(system,j,'vertex');
	switch obj.vertices(j).type
	    case 'pose'
		obj.vertices(j).value = config.relativeToAbsolutePoseHandle(obj.vertices(j).value,dVertices(jBlock));

	    case 'plane'
		obj.vertices(j).value = obj.vertices(j).value + dVertices(jBlock);
		if obj.vertices(j).value(4) < 0
		    obj.vertices(j).value = -obj.vertices(j).value;
		end
	    otherwise
		obj.vertices(j).value = obj.vertices(j).value + dVertices(jBlock);
	end

end

end

