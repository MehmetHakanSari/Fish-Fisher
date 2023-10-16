classdef fish < cluster
    %terrain is the property of the one lattice
    %What class does: (At the moment)
    %An object which is a terrain has specific color 
    
    properties
        name
        LOS = 3;
        location
        ID = 11;
 
    end
    
    
    methods

        function [obj, map_pop] = wander(obj,map_pop,land_distance,boundary_distance)
            %fisherman wanders randomly. Use this command when you sure
            %there is no fish near and no land. For empty seas. Each wander
            %decrease fuel by one. 
            %distance is the distance between the ship and the boundary. 
            % 1 x 4 array. east, south, west north. 
            %some fish clusters hit land. Recheck boundary condition. 
            
            direction_b = boundary_distance > 20;
            direction_l = land_distance > 2; 
            
            [m,n] = size(obj.configuration);
            y = obj.location(1); x = obj.location(2);
            CMy = obj.CM(1); CMx = obj.CM(2);
            
            %"if eleements are 0 in direction_l, I want them to pass" 
            
            RN = rand();
            if RN < 0.25
                if direction_b(1) && direction_l(1) || land_distance(1) == 0
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = zeros(m,n); %update old positon
                    [obj.configuration, obj.location] = obj.move("east");
                    y = obj.location(1); x = obj.location(2);
%                     map_pop(obj.location(1)-obj.CM(1)+1:obj.location(1)-obj.CM(1)+m, obj.location(2)+1-obj.CM(2)+1:obj.location(2)+1-obj.CM(2)+n) = obj.configuration; %update new positon
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = obj.configuration;  %probably this one is correct. 
                end
            elseif 0.25 < RN && RN < 0.5
                if direction_b(2) && direction_l(2) || land_distance(2) == 0
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = zeros(m,n); %update old positon
%                     map_pop(obj.location(1)-obj.CM(1):obj.location(1)-obj.CM(1)+m-1, obj.location(2)-obj.CM(2)+1:obj.location(2)+1-obj.CM(2)+n-1) = zeros(m,n); %update old positon
                    [obj.configuration, obj.location] = obj.move("south");
                    y = obj.location(1); x = obj.location(2);
%                     map_pop(obj.location(1)+1-obj.CM(1)+1:obj.location(1)+1-obj.CM(1)+m, obj.location(2)-obj.CM(2)+1:obj.location(2)-obj.CM(2)+n) = obj.configuration; %update new positon
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = obj.configuration;  %probably this one is correct. 
                end
            elseif 0.5 < RN && RN < 0.75
                if direction_b(3) && direction_l(3) || land_distance(3) == 0
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = zeros(m,n); %update old positon
%                     map_pop(obj.location(1)-obj.CM(1):obj.location(1)-obj.CM(1)+m-1, obj.location(2)-obj.CM(2)+1:obj.location(2)+1-obj.CM(2)+n-1) = zeros(m,n); %update old positon
                    [obj.configuration, obj.location] = obj.move("west");
                    y = obj.location(1); x = obj.location(2);
%                     map_pop(obj.location(1)-obj.CM(1)+1:obj.location(1)-obj.CM(1)+m, obj.location(2)-1-obj.CM(2)+1:obj.location(2)-1-obj.CM(2)+n) = obj.configuration; %update new positon
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = obj.configuration;  %probably this one is correct. 
                end
            else
                if direction_b(4) && direction_l(4) || land_distance(4) == 0
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = zeros(m,n); %update old positon
%                     map_pop(obj.location(1)-obj.CM(1):obj.location(1)-obj.CM(1)+m-1, obj.location(2)-obj.CM(2)+1:obj.location(2)+1-obj.CM(2)+n-1) = zeros(m,n); %update old positon
                    [obj.configuration, obj.location] = obj.move("north");
                    y = obj.location(1); x = obj.location(2);
%                     map_pop(obj.location(1)-1-obj.CM(1)+1:obj.location(1)-1-obj.CM(1)+m, obj.location(2)-obj.CM(2)+1:obj.location(2)-obj.CM(2)+n) = obj.configuration; %update new positon
                    map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = obj.configuration;  %probably this one is correct. 
                end
            end
             
        end
        
        function [obj, map_pop] = migrate(obj,map_pop,land_distance,boundary_distance)
            %I would want to implement migration for fishes. But due to the
            %time considiration I could not. 

        end
        
        function [population, landscape_boundary, boundary] = sense(obj,location,map)
            %location in doubles
            %map is the map class defined in script.
            y = location(1); x = location(2); 
            [population, landscape, boundary] = map.get_neighberhood(x, y, obj.LOS);  %landscape can be string or ID. I did not decide at the moment.
            landscape_boundary = [0 0 0 0];
            [M,N] = size(landscape);
            landscape;
            
            %if landsacep boundary includes 0 it means that taht directions
            %LOS includes land. Keep that in mind. 
            
            %east
            c = 0;
            thereiswater = true;
%             landscape(:,N-c) ~= 366
%             any(landscape(:,N-c) ~= 366)
%             ~any(landscape(:,N-c) ~= 366) 
            
            while thereiswater
%                 if ~any(landscape(:,N-c) ~= 366)   %water ID 366
%                     thereiswater = false;
%                     landscape_boundary(1) = obj.LOS - c;
%                 end
                %I might need to updated this. I did not understand what I
                %am trying to do. 
                if ~any(landscape(:,N-c) ~= 366)   %water ID 366
                    thereiswater = false;
                    landscape_boundary(1) = obj.LOS - c;
                end
                c = c+1;
                if c == obj.LOS
                    break
                end
                
            end
            
            %south
            c = 0;
            thereiswater = true;
            while thereiswater
                if ~any(landscape(M-c,:) ~= 366)
                    thereiswater = false;
                    landscape_boundary(2) = obj.LOS - c;
                end
                if c == obj.LOS
                    break
                end
                c = c+1;
            end
            
            %west
            c = 0;
            thereiswater = true;
            while thereiswater
                if ~any(landscape(:,1+c) ~= 366)
                    thereiswater = false;
                    landscape_boundary(3) = obj.LOS - c;
                end
                if c == obj.LOS
                    break
                end
                c = c+1;
            end
            
            %north
            c = 0;
            thereiswater = true;
            while thereiswater
                if ~any(landscape(1+c,:) ~= 366)
                    thereiswater = false;
                    landscape_boundary(4) = obj.LOS - c;
                end
                if c == obj.LOS
                    break
                end
                c = c+1;
            end
                        
        end
        
        function obj = initialcheck(obj,map)
            check = map.terrain_names(obj.location(1), obj.location(2)) ~= "water" || map.population(obj.location(1), obj.location(2)) == obj.ID;
            if check
                while check
                    obj.location = randi([25 length(map.population)-25],1,2);
                    check = map.terrain_names(obj.location(1),obj.location(2)) ~= "water" || map.population(obj.location(1), obj.location(2)) == obj.ID;
                end
            end
        end
        
        function [obj, map] = save(obj,map)  %pls change name of the function.find more suitable name. 
            position = obj.generate().configuration;
            x = obj.location(2); y = obj.location(1);
            [m,n] = size(position);
            [dum, CMx] = max(sum(position,1));   %n
            [dum, CMy] = max(sum(position,2));  %m 
            map.population(y-CMy+1:y-CMy+m,x-CMx+1:x-CMx+n) = position; %11 is the ID of the fish
            obj.configuration = position;
            obj.CM = [CMy CMx];
        end
       
        
    end
end

