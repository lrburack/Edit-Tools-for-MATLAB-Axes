classdef Zoomer < AxesTool
    properties
        user_action_triggers = ["WindowScrollWheelFcn", "obj.zoom(event_data.VerticalScrollAmount * event_data.VerticalScrollCount)"]

        zoom_sensitivity = 1.1
    end
    
    methods
        function obj = Zoomer(axes)
            obj@AxesTool(axes)
        end

        % The mouse should stay in the same location on the graph
        % Difference between xlim(1) and xlim(2) should be 
        % new_dist = dist * (1 / scroll_power * sensitivity)

        % Maintain the ratio between the distance of xlim(1), pos(1) and
        % pos(1), xlim(2)

        function zoom(obj, amount)
            pos = obj.mousePosition();
            
            xdist = obj.axes.XLim(2) - obj.axes.XLim(1);
            new_xdist = xdist * obj.zoom_sensitivity ^ amount;
            x_ratio = (pos(1) - obj.axes.XLim(1)) / xdist;

            obj.axes.XLim(1) = pos(1) - (x_ratio) * new_xdist;
            obj.axes.XLim(2) = pos(1) + (1 - x_ratio) * new_xdist;

            ydist = obj.axes.YLim(2) - obj.axes.YLim(1);
            new_ydist = ydist * obj.zoom_sensitivity ^ amount;
            y_ratio = (pos(2) - obj.axes.YLim(1)) / ydist;

            obj.axes.YLim(1) = pos(2) - (y_ratio) * new_ydist;
            obj.axes.YLim(2) = pos(2) + (1 - y_ratio) * new_ydist;
        end
    end
end