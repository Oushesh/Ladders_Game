function [ diff_index] = calc_diff(diff_letter,Goal_len,Node_len )
%UNTITLED Summary of this function goes here
%   Function takes in letters difference, goal length and node length
%   to output the difference index
            if (Goal_len > Node_len)
                diff_index = find(diff_letter > 0);
                diff_index = [diff_index find(diff_letter < 0)];
            else
                diff_index = find(diff_letter < 0);
                diff_index = [diff_index find(diff_letter > 0)];
            end
end

