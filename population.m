classdef population
    %population stores the distribution of the species into the map  
    
    properties
        lattice 
    end
    
    methods
        function [pop, ter] = getneighberhood(obj, x ,y)
            %learns population and terrain around for given x and y.
            %returns 5x5 array with population and terrain
             pop = obj.lattice(x+2:x-2,y+2:y-2);

        end
        
        function terra = latticeinfo(obj,x,y)
           terra = terrain;
           n = length(obj.rbglattice(1,1,:));
           terra.color = reshape(obj.rbglattice(x,y,:),1,n);
%            if isequal(terra.color, [29, 85, 252])
        end
        
        function terrain_values = get_terrainvalues(obj)
            
            X = length(obj.rbglattice(1,:,1));
            Y = length(obj.rbglattice(:,1,1));
            terrain_values = zeros(X,Y);
           
            for i  = 1:X
                for j = 1:Y
                    terrain_values(i,j) = sum(obj.latticeinfo(i,j).color); 
                end
            end
            
        end
        
        function terrain_names = get_terrainnames(obj)
            
            X = length(obj.rbglattice(1,:,1));
            Y = length(obj.rbglattice(:,1,1));
            terrain_names = strings(X,Y);
            for i  = 1:X
                for j = 1:Y
                    a = obj.latticeinfo(i,j).color;
                    if isequal(a, [29, 85, 252])
                        terrain_names(i,j) = "water";
                    elseif isequal(a, [3, 55, 211])
                        terrain_names(i,j) = "water_medium";
                    elseif isequal(a, [2, 38, 145])
                        terrain_names(i,j) = "water_deep";
                    elseif isequal(a, [28, 232, 48])
                        terrain_names(i,j) = "grass";
                    end
                end
            end
            
        end
        
        
        function visualize(obj, colorized)
           imagesc(obj.terrain_values)
           colormap(colorized);
        end
        
    end
end

