%%
%% Autogenerated by Thrift Compiler (0.9.0)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(hive_service_types).

-include("hive_service_types.hrl").

-export([struct_info/1, struct_info_ext/1]).

struct_info('hiveClusterStatus') ->
  {struct, [{1, i32},
          {2, i32},
          {3, i32},
          {4, i32},
          {5, i32},
          {6, i32}]}
;

struct_info('hiveServerException') ->
  {struct, [{1, string},
          {2, i32},
          {3, string}]}
;

struct_info('i am a dummy struct') -> undefined.

struct_info_ext('hiveClusterStatus') ->
  {struct, [{1, undefined, i32, 'taskTrackers', undefined},
          {2, undefined, i32, 'mapTasks', undefined},
          {3, undefined, i32, 'reduceTasks', undefined},
          {4, undefined, i32, 'maxMapTasks', undefined},
          {5, undefined, i32, 'maxReduceTasks', undefined},
          {6, undefined, i32, 'state', undefined}]}
;

struct_info_ext('hiveServerException') ->
  {struct, [{1, undefined, string, 'message', undefined},
          {2, undefined, i32, 'errorCode', undefined},
          {3, undefined, string, 'sQLState', undefined}]}
;

struct_info_ext('i am a dummy struct') -> undefined.

