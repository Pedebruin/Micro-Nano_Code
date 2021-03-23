classdef link < dynamicprops & matlab.mixin.Copyable
    %{
    Handle class for a link object
    %}
    
   properties
      name;
      L;                % Length of the link. 
      w = 1;            % Initialised width [mum] (just some guess still)
      h = 25;           % General layer height [mum] (set by process)
      
      start;            % Beginning of the link
      finish;           % Ending of the link (end was taken, so begin-end was no option)
      slope;            % The slope of the link in degrees
      
      deform;           % How much is the link deformed? in degrees
      
      start_init;       % Initial starting point
      finish_init;      % Initial ending point
      slope_init;       % Initial slope
      
      color;            % color of the plot
      lineWidth = 1;    % width of the line of the plot (can be a function of the thickness)
      free = true;      % Is it free to choose the length?
      offset = false;   % Is its position now offset, or not?
      
      parents;          % Cell array with handles to its parents :o
   end
   
   methods
       
   end
end