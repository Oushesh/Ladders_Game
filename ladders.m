% Ladders is a word game where a player tries to get from one word, the 
% start word? to another, the goal word? in as few steps as possible. 
% In each step, the player must either add one letter to the word from
% the previous step, or take away one letter, and then rearrange the 
% letters to make a new word.

%Oushesh Haradhun oushesh@gmail.com

%Note: Startword and Goalword have to be written
%      in small characters with a comma in between
%      and the words within inverted commas
function [solutions] = ladders(startword, goalword)
    %% 1.Read in wordList into string array
    %Words = textread('wordList.txt','%s');
    filename='wordList.txt';
    Words = importdata(filename);
    
     %% 2.setting up initial variables
    solutions = 0;
    Frontier = find(strcmp(Words,startword));
    Parents{1} = Frontier;
    % at the beginning exploredset is an empty array
    exploredset = [];
    % Create array with the number of letters of each data element
    Lengths = cellfun(@length, Words);
    minimum_len = min(Lengths);
    maximum_len = max(Lengths);
    % Create cell array with the indices of each data element, sorted by
    % their lengths
    INDEX = cell(maximum_len,1);
    
    %Defining word length, character length and the alphabets
    words_length = length(Words);
    
    character = 'a':'z';
    character_len = length(character);
    
    %% 3. Definition of Current Node and Goal with their properties
    %~~ Create structure array for the current node and the goal
    %~~ defining Node and Goal data as stutcture data types
    %~~ to be used later
    Node = struct;
    Goal = struct;
    
     Goal.index = find(strcmp(goalword,Words));
    Goal.state = goalword;
    Goal.length = Lengths(Goal.index);
    %% 3.Check if the startword and goalword are in the dataset
    fehler = 0;
    if isempty(find(strcmp(Words,startword),1))
        fehler = 2;
    elseif isempty(find(strcmp(Words,goalword),1))
        fehler = 3;
    end
    %% array with character frequency appearance
    for mm=minimum_len:maximum_len
        INDEX{mm} = find(Lengths==mm);
    end
    % Create array with occurrences of each letter for each data element 
    Letters = zeros(words_length,character_len);      
    for mm=1:words_length
        Letters(mm,:) = histc(Words{mm},character);
    end
    
    Goal.letters = Letters(Goal.index,:);
    
    %% doing the search
    % Search Technique: BFS adpated & implemented 
    while (fehler == 0)
        % Define node properties like its parent
        % index, state & length
        
        Node.parent = Parents{1};
        Node.index = Frontier(1);
        Node.state = Words(Node.index);
        Node.length = Lengths(Node.index);
        Node.letters = Letters(Node.index,:);
        % Check in case we did not reach the goal. If no, we break
        if (strcmp(Node.state,Goal.state)==0)
            % if we did not reache the goal, 
            %we update the explored, frontier and parents sets
            exploredset = [exploredset; Node.index];
            
            %empty sets for first frontier and 
            % also parents
            Frontier(1) = [];
            Parents(1) = [];
            % Build a difference node between the current node and the goal
            % node
            Difference.letters = Goal.letters-Node.letters;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Calling in the function calc.diff
            Difference.index=calc_diff(Difference.letters,Goal.length,Node.length);
            Difference.length = length(Difference.index);
            
            % Create zero array with zeros
            % rows for each differnt letter
            Branches = zeros(Difference.length,character_len);
            for mm=1:Difference.length
                
                diff=Difference.letters(Difference.index(mm));
                Branches(mm,Difference.index(mm)) = sign(diff);
                
                % make new combinations
                % of letters
                Combinations.letters = Node.letters+Branches(mm,:);
                % sum the values of the columns
                Combinations.length = sum(Combinations.letters);
                
                % Check if there are words existing for the new letter
                % combinations
                more_possibilities = 0;
                comb_idx=INDEX{Combinations.length};
                
                for nn=1:length(comb_idx)
                    if (Letters(comb_idx(nn),:)==Combinations.letters)
                        more_possibilities = more_possibilities +1;
                        Frontier = [Frontier; comb_idx(nn)];
                        Parents = [Parents [Node.parent;comb_idx(nn)]];
                    else
                        % do nothing
                    end
                end
                % Remove indices of found children from the INDEX array
                
                total=length(Frontier)-more_possibilities+1;
                for (nn=total:length(Frontier))
                    comb_idx(comb_idx==Frontier(nn)) = [];
                end
            end
            % Check if there are any new childs existing
            if (isempty(Frontier)==0)
                % do nothing
            else
                fehler = 1;
                break
            end
        else
            break
        end
    end
    %% 4.writing solutions to search problem
    output_txt=fopen('output.txt','w');
    if (fehler==0)
        solutions = 1;
            for mm=1:length(Parents{1})
                Path{mm} = Words{Parents{1}(mm)};
                fprintf(output_txt,[Path{mm},'\n']);
            end
            output = Path
    elseif (fehler==1)
        printf('no solution')
    elseif (fehler==2)
        printf('Startword not found in wordlist')
    else
        printf('Goalword not found in wordlist')
    end
    fclose(output_txt);
end