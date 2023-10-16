classdef fisherman 
    %terrain is the property of the one lattice
    %What class does: (At the moment)
    %An object which is a terrain has specific color 
    
    properties
        name
        radar_radius = 30;
        source = 0;
        fuel = 0;
        location
        status = "illegal";
        ID = 61;
    end
    
    
    methods

        function [obj, map_pop] = wander(obj,map_pop,distance)
            %fisherman wanders randomly. Use this command when you sure
            %there is no fish near and no land. For empty seas. Each wander
            %decrease fuel by one. 
            %distance is the distance between the ship and the boundary. 
            % 1 x 4 array. east, south, west north. 
            
            direction = distance > 10;
            
            RN = rand();
            if RN < 0.25
                if direction(1)  %east
                    map_pop(obj.location(1), obj.location(2)) = 0; %update old positon
                    obj.location = obj.location + [0, 1];
                    map_pop(obj.location(1), obj.location(2)) = obj.ID; %update new positon
                end
            elseif 0.25 < RN && RN < 0.5
                if direction(2)  %south 
                    map_pop(obj.location(1), obj.location(2)) = 0; %update old positon
                    obj.location = obj.location + [1, 0];
                    map_pop(obj.location(1), obj.location(2)) = obj.ID; %update new positon
                end
            elseif 0.5 < RN && RN < 0.75
                if direction(3)  %west
                    map_pop(obj.location(1), obj.location(2)) = 0; %update old positon
                    obj.location = obj.location + [0, -1];
                    map_pop(obj.location(1), obj.location(2)) = obj.ID; %update new positon
                end
            else
                if direction(4)  %north
                    map_pop(obj.location(1), obj.location(2)) = 0; %update old positon
                    obj.location = obj.location + [-1, 0];
                    map_pop(obj.location(1), obj.location(2)) = obj.ID; %update new positon
                end
            end
             
            obj.fuel = obj.fuel - 1;
        end
        
        function [obj, map_pop] = hunt(obj,map_pop)
            
            y = obj.location(1); x = obj.location(2);
            hunt_matrix = map_pop(y-1:y+1,x-1:x+1);
            
            hunting_possibility = 0.8; %hunting possibility is 0.8
            
            tot = sum(hunt_matrix(:) == 11);
                
            for i = 1:length(hunt_matrix)
                for j = 1:length(hunt_matrix)
                    if (1-hunting_possibility) < rand()
                        hunt_matrix(j,i) = 0;
                    end
                end
            end
            
            obj.source = obj.source + tot - sum(hunt_matrix(:) == 11);
            map_pop(y-1:y+1,x-1:x+1) = hunt_matrix;
 
        end
        
        function [obj,map_pop,all_schools] = chase(obj, map_pop,distance,all_schools)
            %fish_school is one school class is fish. Thats what you can
            %envoke fish methods in this function. 
            %but which fish school will I sent to chase() function. Damn!
            %send all school. select the closest schoold and update its
            %configuraiton
            
            
            N = length(map_pop);
            fish_pop = (map_pop == 11);
            k = true;
            y = obj.location(1); x = obj.location(2);  
            %%% select the closest school. Thus, the return of the
            %%% all_schools with different configurated school can be
            %%% satisfied. 
            dummy_distance = 1000;
            chased_fish_cluster = 0;
            for sch = 1:length(all_schools)
                y_fish = all_schools(sch).location(1) ; x_fish = all_schools(sch).location(2);
                
                ship_cluster_distance = sqrt((y_fish - y)^2 + (x_fish - x)^2);
                
                if ship_cluster_distance < dummy_distance   %if the new found distance smaller than the previous one
                    dummy_distance = ship_cluster_distance;    %then update dummy_distance, if it is larger, I dont care.
                    chased_fish_cluster = sch;
                end
            end
            
            
            c = 1;
            if ~(y-c < 1 || y+c > N || x-c < 1 || x+c > N) 
                while k
                    radar_matrix = map_pop(y-c:y+c,x-c:x+c);
                    fish_check = (radar_matrix == 11);
                    if c == 1
                        if sum(any(fish_check)) > 0 %if the fish is nearby
                            [obj,map_pop] = obj.hunt(map_pop);  %map_pop is the map after the fish is hunted. 
                            [fish_school, map_pop] = all_schools(chased_fish_cluster).update(map_pop);
                            all_schools(chased_fish_cluster) = fish_school;
                        end
                        posib_x = [];
                        posib_y = [];
                        direction = [0 0];
                    else                       %find locaiton of nearest fish.
                        %I will linear search. It is the worst way of doing
                        %it. I do not recomemmend any one to implement this
                        %search algorithm. Just time considiration I did not work
                        %better one. And realize that, it is second nested
                        %loop I write. I am off writing algorithms really.
                        
                        posib_x = [];
                        posib_y = [];
                        xsearch  = any(fish_check);
                        ysearch  = any(fish_check');
                        for i = 1:2*c+1
                            if xsearch(i) == 1   % x search.
                                posib_x = [posib_x i];
                            end
                            if ysearch(i) == 1  % y search
                                posib_y = [posib_y i];
                            end
                        end
                        
%                         if c == 22
%                             break
%                         end
                        
                        b = 1000;
                        nearst_fish = [0 0];
                        for i = 1:length(posib_x)
                            for j = 1:length(posib_y)
                                q = posib_x(i);
                                w = posib_y(j);

                                
                                a = sqrt((w - y)^2 + (q - x)^2);
                                if a < b   %if the new found distance smaller than the previous one
                                    b = a;    %then update also save coordinates
                                    nearst_fish(1) = w;
                                    nearst_fish(2) = q;
                                end
                            end
                        end
                        direction = [0 0];
                        % c+1 is the locaiton of y. It is in the middle 1 2 . . . y . . . 2*c+1
                        if nearst_fish(1) < c + 1 %if the fish is in north
                            direction(1) = -1;
                        elseif nearst_fish(1) > c + 1
                            direction(1) = +1;    %if the fish is in south
                        end
                        if nearst_fish(2) < c + 1 %if the fish is in west
                            direction(2) = -1;
                        elseif nearst_fish(2) > c + 1
                            direction(2) = +1;    %if the fish is in east
                        end
                    end
                    c = c+1;
%                     if c > obj.radar_radius
%                         break
%                     end
                    if ~isempty(posib_x)   % or use posib_y
                        k = false;
                    end
                    if (y-c < 1 || y+c > N || x-c < 1 || x+c > N) %boundray. 
                        k = false;
                    end
 
                end
                map_pop(obj.location(1), obj.location(2)) = 0;
                obj.location = obj.location + direction;
                map_pop(obj.location(1), obj.location(2)) = obj.ID;
                obj.fuel = obj.fuel - 1;
            else
                obj.wander(map_pop, distance)
            end
            
            

        end
        
%         
%         function dock()
%             
%         end
        
        function [population, landscape, boundary] = radar(obj,location,map)
            %locaiton in doubles
            %map is the map class defined in script.
            R = obj.radar_radius;
            x = location(2); y = location(1);
            [population, landscape, boundary] = map.get_neighberhood(x, y, R);
            
        end
        
        function obj = initialcheck(obj,map)
            check = map.terrain_names(obj.location(1), obj.location(2)) ~= "water" || map.population(obj.location(1), obj.location(2)) == obj.ID;
            if check
                while check
                    obj.location = randi([1 length(map.population)],1,2);
                    check = map.terrain_names(obj.location(1),obj.location(2)) ~= "water" || map.population(obj.location(1), obj.location(2)) == obj.ID;
                end
            end
        end
        
        function [obj, map] = register(obj,map)
            map.population(obj.location(1), obj.location(2)) = obj.ID; %61 is the code of the fisherman
            obj.status = "legal";
        end
        
    end
end

