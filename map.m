classdef map
    %UNTİTLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name 
        rbglattice %matrix ?? 
        terrain_names
        terrain_ID
        population
    end
    
    methods
        function rbglattice = import(obj)
            %Imports the map from the data
            rbglattice = double(imread(obj.name));
        end
        
        function terra = latticeinfo(obj,x,y)
           terra = terrain;
           n = length(obj.rbglattice(1,1,:));
           terra.color = reshape(obj.rbglattice(x,y,:),1,n);
%            if isequal(terra.color, [29, 85, 252])
        end
        
        function terrain_ID = get_terrainvalues(obj)
            
            X = length(obj.rbglattice(1,:,1));
            Y = length(obj.rbglattice(:,1,1));
            terrain_ID = zeros(X,Y);
           
            for i  = 1:X
                for j = 1:Y
                    terrain_ID(i,j) = sum(obj.latticeinfo(i,j).color); 
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
%             surf(obj.terrain_values,"LineStyle","none"); hold on
            surf(flip(obj.terrain_ID+obj.population),"LineStyle","none")
%             surf(obj.terrain_ID+obj.population,"LineStyle","none")
            xlim([1 length(obj.population)])
            ylim([1 length(obj.population)])
            view(2)
%            imagesc(obj.terrain_values); hold on
           
           colormap(colorized);
           
        end
        
        function [pop, ter, boundary_dis] = get_neighberhood(obj, x ,y, R)
            %learns population and terrain around for given x and y.
            %returns 5x5 array with population and terrain
            N = length(obj.rbglattice); 
           
            boundary = [x+R y+R x-R y-R];
           
            if isempty(R)
                error("LOS is not specified.")
            end

            if ((x + R < N) && (y + R < N) && (x - R > 1)  && (y - R > 1))
            pop = obj.population(y-R:y+R,x-R:x+R);
            ter = obj.terrain_ID(y-R:y+R,x-R:x+R);
            else
                if (x + R >= N)
                    boundary(1) = N;   %1 east
                end
                if (y + R >= N)
                    boundary(2) = N;   %2 south
                end
                if (x - R <= 1)
                    boundary(3) = 1;   %3 west
                end
                if (y - R <= 1)
                    boundary(4) = 1;   %4 north
                end
                boundary;
                pop = obj.population(boundary(4):boundary(2),boundary(3):boundary(1));
                ter = obj.terrain_ID(boundary(4):boundary(2),boundary(3):boundary(1));     
            end
            boundary_dis = [N-x, N-y, x-1, y-1];
        end
        
    end
end

