classdef AxesTool < handle
    properties
        axes
    end

    methods (Access = public)
        function obj = AxesTool(axes)
            obj.axes = axes;
        end
        
        % Overridable callbacks for user interaction (called by AxesToolbar)
        function userAction(obj, interact_object, event_data, callback_name)
            if ~isprop(obj, "user_action_triggers") || isempty(obj.user_action_triggers)
                warning("No user actions configured for the enabled tool");
                return;
            end
            if mod(length(obj.user_action_triggers), 2) ~= 0
                warning("Invalid user actions configured for the enabled tool");
                return;
            end
            
            action_ind = find(contains(obj.user_action_triggers, callback_name), 1);

            if ~isempty(action_ind)
                fcn = obj.user_action_triggers(action_ind + 1);
                eval(fcn);
            end
        end

        % Gets the mouse coordinates over the axes
        function [pos, over_ax] = mousePosition(obj)
            x = obj.axes.CurrentPoint(1,1);
            y = obj.axes.CurrentPoint(1,2);
            
            % Get the current visual field on the axes
            xrange = xlim(obj.axes);
            yrange = ylim(obj.axes);
            
            % If the coords are outside of the axes, set them to the limits
            over_ax = true;
            if x < xrange(1)
                over_ax = false;
                x = xrange(1);
            elseif x > xrange(2)
                over_ax = false;
                x = xrange(2);
            end
            if y < yrange(1)
                over_ax = false;
                y = yrange(1);
            elseif y > yrange(2)
                over_ax = false;
                y = yrange(2);
            end

            pos = [x, y];
        end

        function saveToVersionHistory(obj)
            % Make sure the current axes object has the version properties
            addpropsafe(obj.axes, version_history, {});
            addpropsafe(obj.axes, version_index, 0);

            % Make a copy of the object without version properties to add
            % to the version history array.
            new_version = copy(obj.axes);
            delete(new_version.version_history);
            delete(new_version.version_index);
            
            % Increment the version index by one
            obj.axes.version_ind = obj.axes.version_ind + 1;
            % add the new version to the array
            obj.axes.version_history{obj.axes.version_ind} = new_version;
            % delete all versions that existed after the current version ind
            obj.axes.version_history = obj.axes.version_history{1:obj.axes.version_ind};
        end
    end
end