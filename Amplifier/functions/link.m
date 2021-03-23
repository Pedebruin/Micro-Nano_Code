classdef link < dynamicprops & matlab.mixin.Copyable
    %{
    Handle class for a link object
    %}
    
   properties
      name;
      L;                % Length of the link. 
      w = 1;            % Initialised width [mum] (just some guess still)
      h = 25;           % General layer height [mum] (set by process)
      
      start = 0;        % Beginning of the link
      finish= 0;        % Ending of the link (end was taken, so begin-end was no option)
      
      start_init;       % Initial starting point
      finish_init;      % Initial ending point
      
      color;            % color of the plot
      lineWidth = 1;    % width of the line of the plot (can be a function of the thickness)
      free = true;      % Is it free to choose the length?
      offset = false;   % Is its position now offset, or not?
      
      parents;          % Cell array with handles to its parents :o
   end
   
   methods
       
   end
end