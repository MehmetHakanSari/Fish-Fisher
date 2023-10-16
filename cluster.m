classdef cluster  
    %cluster is the superclass of all clusters. The cluster can be fish,
    %forest, buffalo patches etc. 
    %the object that is cluster has properties of [size, birthrate,
    %compactness(in progress) & solitariness(in progress) ]
    
    
    
    properties
        size
        configuration
        birthrate = 4;           %outof ten
        compacteness = 1;
        solitariness = 0;
        CM                          %center of mass [CMy CMx]

    end
    
    
    methods

        function obj = generate(obj)
            %aacording to its size, I want to the function to return a
            %suitable matrix (regardless of its shape) that contains
            %obj.size number obj.ID.
            
            %position is the matrix that contains configuraiton in this
            %case. 
            
            
            
            N = obj.size;
            compact = obj.compacteness;
            away = obj.solitariness;
            if N > 5
                position = zeros(N-round(N/1.8));
                coor = [2 2];
            else
                position = zeros(N);
                coor = [2 2];
            end
            
            x = coor(1);y = coor(2);
            position(x,y) = obj.ID;
            Nnumber = 1;
            
            if compact-1 > away 
                error("Compactness lesser than solitariness. Reassign values.")
            end
            
            while ~(Nnumber == N)
                
                distance = [N-x, N-y, x-1, y-1];
                direction = distance > 1;
                
                RN = rand();
                if RN < 0.25
                    if direction(1)
                        coor = coor + [randi([1, compact]), 0];
                        x = coor(1);y = coor(2);
                        position(x,y) = obj.ID;
                    end
                elseif 0.25 < RN && RN < 0.5
                    if direction(2)
                        coor = coor + [0, randi([1, compact])];
                        x = coor(1);y = coor(2);
                        position(x,y) = obj.ID;
                    end
                elseif 0.5 < RN && RN < 0.75
                    if direction(3)
                        coor = coor + [-randi([1, compact]), 0];
                        x = coor(1);y = coor(2);
                        position(x,y) = obj.ID;
                    end
                else
                    if direction(4)
                        coor = coor + [0, -randi([1, compact])];
                        x = coor(1);y = coor(2);
                        position(x,y) = obj.ID;
                    end
                end
                Nnumber = sum(sum(position == obj.ID));
            end
            obj.configuration = position;
%             [m, n] = size(position);
%             position = [zeros(m,away) position zeros(m,away)];
%             position = [zeros(away,n+2*away); position; zeros(away,n+2*away)];
        end
        
        function obj = divide(obj)
            
        end
            
%  
        function [obj, map_pop] = update(obj,map_pop)
            %The fish configuration is updated by the map.  
            %map_pop should be updated in fisherman.hunt() function.
            %Thus fish should enter hunt().
           
            [m, n] = size(obj.configuration);
            y = obj.location(1); x = obj.location(2);
            CMy = obj.CM(1); CMx = obj.CM(2);
            fish_pop = (map_pop == obj.ID); %consist of ones and zeros
            
            obj.configuration = (fish_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n)) * obj.ID;  %added total things should be equal to m and n. Though in which direction yani. 
            
            obj.size = sum(obj.configuration(:) == obj.ID);
%             map_pop(y-CMy+1:y-CMy+m, x-CMx+1:x-CMx+n) = obj.configuration;
            
        end
        
        function  [new_conf, new_location] = move(obj,direction)
            %accoridng to given direction (e,s,w,n) the cluster moves for
            %given matrix. thus, the functiun returns a matrix includes
            %obj.size numbered %obj.ID.
            
            %I should update the configuraiton if the fishes are hunted.
            %This update will be done through the populaiton map. Though,
            %the problem is now the move command is no working as I want,
            %thus the update might consider the lefovers caused by move()
            %command. But each configuraiton has its own matrix size that
            %can be use for update. But while I update the fish
            %configuraitons via map how would I know, which school I am
            %updating. This can be done by usign location informations,
            %which might be slow for indexing etc. But if I select this
            %choice I think I have no chanche to select any other method. 
            
%             directions = ["east", "south", "west", "north"];  %just for reminding
            
            
            %I am just warning you that, 
            %The things I will write down is the simplest way of moving configuration. 
            %It can be more way complex. Due to time considiration I will
            %not emopluy suck a thing at the moment.
            
            new_conf = obj.configuration;
            if direction == "east"
                new_location = obj.location + [1,0];
            elseif direction == "south"
                new_location = obj.location + [0,1];
            elseif direction == "west"
                new_location = obj.location + [-1,0];
            elseif direction == "north"
                new_location = obj.location + [0,-1];  
            end

        end
        
        function obj = birth(obj)
            %for a given rate of birth, the cluster give offsprings. This
            %should be provided in a matrix form. So the function returns
            %obj.size + 1 numbred obj.ID matrix. 
            
            %at the moment configuration matrix size do not change. If I
            %have time left I will update that. 
            
            N = obj.size;
            [m,n] = size(obj.configuration);
%             rand()*10 <= obj.birthrate * (N/7)
            if rand()*10 <= obj.birthrate * (N/7) && obj.size < (m*n)-3 %(N/7 is the boost factor larger clusters has more chance to give birth)
                x_empty = [];
                y_empty = [];
                for i = 1:n 
                    saymalik = any(obj.configuration == 0);
                    if saymalik(i) == 1
                    x_empty = [x_empty i];
                    end
                end
                for j = 1:m
                    saymalik = any((obj.configuration)' == 0);
                    if saymalik(j) == 1
                    y_empty = [y_empty j];
                    end
                end
                
                x_index = randi([1 length(x_empty)],1);
                y_index = randi([1 length(y_empty)],1);
%                

                obj.configuration(y_index,x_index) = obj.ID;



                    %while method is like shit. So so so so slow. In stead
                    %of going random, just select one 0 and turn it to
                    %obj.ID. Or use nested loop. 
%                 while obj.size <= N
%                     y = randi([2 m-1], 1);
%                     x = randi([2 n-1], 1);
%                     
%                     if obj.configuration(y,x) == obj.ID
%                         if  obj.configuration(y,x+1) == 0       %if it is empty
%                             obj.configuration(y,x+1) = obj.ID;
%                         elseif obj.configuration(y,x-1) == 0
%                             obj.configuration(y,x-1) = obj.ID;
%                         elseif obj.configuration(y+1,x) == 0
%                             obj.configuration(y+1,x) = obj.ID;
%                         elseif obj.configuration(y-1,x) == 0
%                             obj.configuration(y-1,x) = obj.ID;
%                         end
%                     end
%                     obj.size = sum(obj.configuration(:) == obj.ID);
%                 end
                obj.configuration = obj.configuration;
                
            end
        end
        
        
    end
end
%k(school(i).location(1)-school(i).CM(1):school(i).location(1)-school(i).CM(1)+m, school(i).location(2)+1-school(i).CM(2):school(i).location(2)+1-school(i).CM(2)+n) = school(i).configuration;
