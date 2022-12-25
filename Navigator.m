classdef Navigator < AxesTool
    
    properties
        user_action_triggers = ["WindowButtonDownFcn", "obj.startPan(obj.mousePosition())",...
            "WindowButtonUpFcn", "obj.endPan()", ...
            "WindowButtonMotionFcn", "obj.pan(obj.mousePosition())", ...
            "WindowScrollWheelFcn", "obj.zoom(event_data.VerticalScrollAmount * event_data.VerticalScrollCount)"]
        pan_position
        pan_active

        zoom_sensitivity = 1.1
    end
    
    methods
        function obj = Navigator(axes)
            obj@AxesTool(axes)
        end
        
        function startPan(obj, start_position)
            obj.pan_active = true;
            obj.pan_position = start_position;
        end

        function endPan(obj)
            obj.pan_position = NaN;
            obj.pan_active = false;
        end

        function pan(obj, current_position)
            if obj.pan_active
                obj.axes.XLim = obj.axes.XLim + obj.pan_position(1) - current_position(1);
                obj.axes.YLim = obj.axes.YLim + obj.pan_position(2) - current_position(2);
            end
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

