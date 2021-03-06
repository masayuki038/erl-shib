%%
%% Autogenerated by Thrift Compiler (0.9.0)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(queryplan_types).

-include("queryplan_types.hrl").

-export([struct_info/1, struct_info_ext/1]).

struct_info('adjacency') ->
  {struct, [{1, string},
          {2, {list, string}},
          {3, i32}]}
;

struct_info('graph') ->
  {struct, [{1, i32},
          {2, {list, string}},
          {3, {list, {struct, {'queryplan_types', 'adjacency'}}}}]}
;

struct_info('operator') ->
  {struct, [{1, string},
          {2, i32},
          {3, {map, string, string}},
          {4, {map, string, i64}},
          {5, bool},
          {6, bool}]}
;

struct_info('task') ->
  {struct, [{1, string},
          {2, i32},
          {3, {map, string, string}},
          {4, {map, string, i64}},
          {5, {struct, {'queryplan_types', 'graph'}}},
          {6, {list, {struct, {'queryplan_types', 'operator'}}}},
          {7, bool},
          {8, bool}]}
;

struct_info('stage') ->
  {struct, [{1, string},
          {2, i32},
          {3, {map, string, string}},
          {4, {map, string, i64}},
          {5, {list, {struct, {'queryplan_types', 'task'}}}},
          {6, bool},
          {7, bool}]}
;

struct_info('query') ->
  {struct, [{1, string},
          {2, string},
          {3, {map, string, string}},
          {4, {map, string, i64}},
          {5, {struct, {'queryplan_types', 'graph'}}},
          {6, {list, {struct, {'queryplan_types', 'stage'}}}},
          {7, bool},
          {8, bool}]}
;

struct_info('queryPlan') ->
  {struct, [{1, {list, {struct, {'queryplan_types', 'query'}}}},
          {2, bool},
          {3, bool}]}
;

struct_info('i am a dummy struct') -> undefined.

struct_info_ext('adjacency') ->
  {struct, [{1, undefined, string, 'node', undefined},
          {2, undefined, {list, string}, 'children', []},
          {3, undefined, i32, 'adjacencyType', undefined}]}
;

struct_info_ext('graph') ->
  {struct, [{1, undefined, i32, 'nodeType', undefined},
          {2, undefined, {list, string}, 'roots', []},
          {3, undefined, {list, {struct, {'queryplan_types', 'adjacency'}}}, 'adjacencyList', []}]}
;

struct_info_ext('operator') ->
  {struct, [{1, undefined, string, 'operatorId', undefined},
          {2, undefined, i32, 'operatorType', undefined},
          {3, undefined, {map, string, string}, 'operatorAttributes', dict:new()},
          {4, undefined, {map, string, i64}, 'operatorCounters', dict:new()},
          {5, undefined, bool, 'done', undefined},
          {6, undefined, bool, 'started', undefined}]}
;

struct_info_ext('task') ->
  {struct, [{1, undefined, string, 'taskId', undefined},
          {2, undefined, i32, 'taskType', undefined},
          {3, undefined, {map, string, string}, 'taskAttributes', dict:new()},
          {4, undefined, {map, string, i64}, 'taskCounters', dict:new()},
          {5, optional, {struct, {'queryplan_types', 'graph'}}, 'operatorGraph', #graph{}},
          {6, optional, {list, {struct, {'queryplan_types', 'operator'}}}, 'operatorList', []},
          {7, undefined, bool, 'done', undefined},
          {8, undefined, bool, 'started', undefined}]}
;

struct_info_ext('stage') ->
  {struct, [{1, undefined, string, 'stageId', undefined},
          {2, undefined, i32, 'stageType', undefined},
          {3, undefined, {map, string, string}, 'stageAttributes', dict:new()},
          {4, undefined, {map, string, i64}, 'stageCounters', dict:new()},
          {5, undefined, {list, {struct, {'queryplan_types', 'task'}}}, 'taskList', []},
          {6, undefined, bool, 'done', undefined},
          {7, undefined, bool, 'started', undefined}]}
;

struct_info_ext('query') ->
  {struct, [{1, undefined, string, 'queryId', undefined},
          {2, undefined, string, 'queryType', undefined},
          {3, undefined, {map, string, string}, 'queryAttributes', dict:new()},
          {4, undefined, {map, string, i64}, 'queryCounters', dict:new()},
          {5, undefined, {struct, {'queryplan_types', 'graph'}}, 'stageGraph', #graph{}},
          {6, undefined, {list, {struct, {'queryplan_types', 'stage'}}}, 'stageList', []},
          {7, undefined, bool, 'done', undefined},
          {8, undefined, bool, 'started', undefined}]}
;

struct_info_ext('queryPlan') ->
  {struct, [{1, undefined, {list, {struct, {'queryplan_types', 'query'}}}, 'queries', []},
          {2, undefined, bool, 'done', undefined},
          {3, undefined, bool, 'started', undefined}]}
;

struct_info_ext('i am a dummy struct') -> undefined.

