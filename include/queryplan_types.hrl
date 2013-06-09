-ifndef(_queryplan_types_included).
-define(_queryplan_types_included, yeah).

-define(queryplan_AdjacencyType_CONJUNCTIVE, 0).
-define(queryplan_AdjacencyType_DISJUNCTIVE, 1).

-define(queryplan_NodeType_OPERATOR, 0).
-define(queryplan_NodeType_STAGE, 1).

-define(queryplan_OperatorType_JOIN, 0).
-define(queryplan_OperatorType_MAPJOIN, 1).
-define(queryplan_OperatorType_EXTRACT, 2).
-define(queryplan_OperatorType_FILTER, 3).
-define(queryplan_OperatorType_FORWARD, 4).
-define(queryplan_OperatorType_GROUPBY, 5).
-define(queryplan_OperatorType_LIMIT, 6).
-define(queryplan_OperatorType_SCRIPT, 7).
-define(queryplan_OperatorType_SELECT, 8).
-define(queryplan_OperatorType_TABLESCAN, 9).
-define(queryplan_OperatorType_FILESINK, 10).
-define(queryplan_OperatorType_REDUCESINK, 11).
-define(queryplan_OperatorType_UNION, 12).
-define(queryplan_OperatorType_UDTF, 13).
-define(queryplan_OperatorType_LATERALVIEWJOIN, 14).
-define(queryplan_OperatorType_LATERALVIEWFORWARD, 15).
-define(queryplan_OperatorType_HASHTABLESINK, 16).
-define(queryplan_OperatorType_HASHTABLEDUMMY, 17).

-define(queryplan_TaskType_MAP, 0).
-define(queryplan_TaskType_REDUCE, 1).
-define(queryplan_TaskType_OTHER, 2).

-define(queryplan_StageType_CONDITIONAL, 0).
-define(queryplan_StageType_COPY, 1).
-define(queryplan_StageType_DDL, 2).
-define(queryplan_StageType_MAPRED, 3).
-define(queryplan_StageType_EXPLAIN, 4).
-define(queryplan_StageType_FETCH, 5).
-define(queryplan_StageType_FUNC, 6).
-define(queryplan_StageType_MAPREDLOCAL, 7).
-define(queryplan_StageType_MOVE, 8).
-define(queryplan_StageType_STATS, 9).

%% struct adjacency

-record(adjacency, {node :: string() | binary(),
                    children :: list(),
                    adjacencyType :: integer()}).

%% struct graph

-record(graph, {nodeType :: integer(),
                roots :: list(),
                adjacencyList :: list()}).

%% struct operator

-record(operator, {operatorId :: string() | binary(),
                   operatorType :: integer(),
                   operatorAttributes :: dict(),
                   operatorCounters :: dict(),
                   done :: boolean(),
                   started :: boolean()}).

%% struct task

-record(task, {taskId :: string() | binary(),
               taskType :: integer(),
               taskAttributes :: dict(),
               taskCounters :: dict(),
               operatorGraph :: #graph{},
               operatorList :: list(),
               done :: boolean(),
               started :: boolean()}).

%% struct stage

-record(stage, {stageId :: string() | binary(),
                stageType :: integer(),
                stageAttributes :: dict(),
                stageCounters :: dict(),
                taskList :: list(),
                done :: boolean(),
                started :: boolean()}).

%% struct query

-record(query, {queryId :: string() | binary(),
                queryType :: string() | binary(),
                queryAttributes :: dict(),
                queryCounters :: dict(),
                stageGraph :: #graph{},
                stageList :: list(),
                done :: boolean(),
                started :: boolean()}).

%% struct queryPlan

-record(queryPlan, {queries :: list(),
                    done :: boolean(),
                    started :: boolean()}).

-endif.
