-ifndef(_hive_service_types_included).
-define(_hive_service_types_included, yeah).
-include("fb303_types.hrl").
-include("hive_metastore_types.hrl").
-include("queryplan_types.hrl").


-define(hive_service_JobTrackerState_INITIALIZING, 1).
-define(hive_service_JobTrackerState_RUNNING, 2).

%% struct hiveClusterStatus

-record(hiveClusterStatus, {taskTrackers :: integer(),
                            mapTasks :: integer(),
                            reduceTasks :: integer(),
                            maxMapTasks :: integer(),
                            maxReduceTasks :: integer(),
                            state :: integer()}).

%% struct hiveServerException

-record(hiveServerException, {message :: string() | binary(),
                              errorCode :: integer(),
                              sQLState :: string() | binary()}).

-endif.
