-ifndef(_hive_metastore_types_included).
-define(_hive_metastore_types_included, yeah).
-include("fb303_types.hrl").


-define(hive_metastore_HiveObjectType_GLOBAL, 1).
-define(hive_metastore_HiveObjectType_DATABASE, 2).
-define(hive_metastore_HiveObjectType_TABLE, 3).
-define(hive_metastore_HiveObjectType_PARTITION, 4).
-define(hive_metastore_HiveObjectType_COLUMN, 5).

-define(hive_metastore_PrincipalType_USER, 1).
-define(hive_metastore_PrincipalType_ROLE, 2).
-define(hive_metastore_PrincipalType_GROUP, 3).

%% struct version

-record(version, {version :: string() | binary(),
                  comments :: string() | binary()}).

%% struct fieldSchema

-record(fieldSchema, {name :: string() | binary(),
                      type :: string() | binary(),
                      comment :: string() | binary()}).

%% struct type

-record(type, {name :: string() | binary(),
               type1 :: string() | binary(),
               type2 :: string() | binary(),
               fields :: list()}).

%% struct hiveObjectRef

-record(hiveObjectRef, {objectType :: integer(),
                        dbName :: string() | binary(),
                        objectName :: string() | binary(),
                        partValues :: list(),
                        columnName :: string() | binary()}).

%% struct privilegeGrantInfo

-record(privilegeGrantInfo, {privilege :: string() | binary(),
                             createTime :: integer(),
                             grantor :: string() | binary(),
                             grantorType :: integer(),
                             grantOption :: boolean()}).

%% struct hiveObjectPrivilege

-record(hiveObjectPrivilege, {hiveObject :: #hiveObjectRef{},
                              principalName :: string() | binary(),
                              principalType :: integer(),
                              grantInfo :: #privilegeGrantInfo{}}).

%% struct privilegeBag

-record(privilegeBag, {privileges :: list()}).

%% struct principalPrivilegeSet

-record(principalPrivilegeSet, {userPrivileges :: dict(),
                                groupPrivileges :: dict(),
                                rolePrivileges :: dict()}).

%% struct role

-record(role, {roleName :: string() | binary(),
               createTime :: integer(),
               ownerName :: string() | binary()}).

%% struct database

-record(database, {name :: string() | binary(),
                   description :: string() | binary(),
                   locationUri :: string() | binary(),
                   parameters :: dict(),
                   privileges :: #principalPrivilegeSet{}}).

%% struct serDeInfo

-record(serDeInfo, {name :: string() | binary(),
                    serializationLib :: string() | binary(),
                    parameters :: dict()}).

%% struct order

-record(order, {col :: string() | binary(),
                order :: integer()}).

%% struct storageDescriptor

-record(storageDescriptor, {cols :: list(),
                            location :: string() | binary(),
                            inputFormat :: string() | binary(),
                            outputFormat :: string() | binary(),
                            compressed :: boolean(),
                            numBuckets :: integer(),
                            serdeInfo :: #serDeInfo{},
                            bucketCols :: list(),
                            sortCols :: list(),
                            parameters :: dict()}).

%% struct table

-record(table, {tableName :: string() | binary(),
                dbName :: string() | binary(),
                owner :: string() | binary(),
                createTime :: integer(),
                lastAccessTime :: integer(),
                retention :: integer(),
                sd :: #storageDescriptor{},
                partitionKeys :: list(),
                parameters :: dict(),
                viewOriginalText :: string() | binary(),
                viewExpandedText :: string() | binary(),
                tableType :: string() | binary(),
                privileges :: #principalPrivilegeSet{}}).

%% struct partition

-record(partition, {values :: list(),
                    dbName :: string() | binary(),
                    tableName :: string() | binary(),
                    createTime :: integer(),
                    lastAccessTime :: integer(),
                    sd :: #storageDescriptor{},
                    parameters :: dict(),
                    privileges :: #principalPrivilegeSet{}}).

%% struct index

-record(index, {indexName :: string() | binary(),
                indexHandlerClass :: string() | binary(),
                dbName :: string() | binary(),
                origTableName :: string() | binary(),
                createTime :: integer(),
                lastAccessTime :: integer(),
                indexTableName :: string() | binary(),
                sd :: #storageDescriptor{},
                parameters :: dict(),
                deferredRebuild :: boolean()}).

%% struct schema

-record(schema, {fieldSchemas :: list(),
                 properties :: dict()}).

%% struct metaException

-record(metaException, {message :: string() | binary()}).

%% struct unknownTableException

-record(unknownTableException, {message :: string() | binary()}).

%% struct unknownDBException

-record(unknownDBException, {message :: string() | binary()}).

%% struct alreadyExistsException

-record(alreadyExistsException, {message :: string() | binary()}).

%% struct invalidObjectException

-record(invalidObjectException, {message :: string() | binary()}).

%% struct noSuchObjectException

-record(noSuchObjectException, {message :: string() | binary()}).

%% struct indexAlreadyExistsException

-record(indexAlreadyExistsException, {message :: string() | binary()}).

%% struct invalidOperationException

-record(invalidOperationException, {message :: string() | binary()}).

%% struct configValSecurityException

-record(configValSecurityException, {message :: string() | binary()}).

-endif.
