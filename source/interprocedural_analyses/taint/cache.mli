(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open Analysis
open Interprocedural

type t

exception BuildCacheOnly

val try_load
  :  scheduler:Scheduler.t ->
  saved_state:Configuration.StaticAnalysis.SavedState.t ->
  configuration:Configuration.Analysis.t ->
  decorator_configuration:Analysis.DecoratorPreprocessing.Configuration.t ->
  enabled:bool ->
  t

val save
  :  maximum_overrides:int option ->
  analyze_all_overrides_targets:Interprocedural.Target.Set.t ->
  attribute_targets:Interprocedural.Target.Set.t ->
  skip_analysis_targets:Interprocedural.Target.Set.t ->
  skip_overrides_targets:Ast.Reference.SerializableSet.t ->
  skipped_overrides:Interprocedural.OverrideGraph.skipped_overrides ->
  override_graph_shared_memory:Interprocedural.OverrideGraph.SharedMemory.t ->
  initial_callables:FetchCallables.t ->
  call_graph_shared_memory:Interprocedural.CallGraph.DefineCallGraphSharedMemory.t ->
  whole_program_call_graph:Interprocedural.CallGraph.WholeProgramCallGraph.t ->
  global_constants:Interprocedural.GlobalConstants.SharedMemory.t ->
  t ->
  unit

val type_environment : t -> (unit -> TypeEnvironment.t) -> TypeEnvironment.t * t

val class_hierarchy_graph
  :  t ->
  (unit -> ClassHierarchyGraph.Heap.t) ->
  ClassHierarchyGraph.Heap.t * t

val initial_callables : t -> (unit -> FetchCallables.t) -> FetchCallables.t * t

val class_interval_graph
  :  t ->
  (unit -> ClassIntervalSetGraph.Heap.t) ->
  ClassIntervalSetGraph.Heap.t * t

val metadata_to_json : t -> Yojson.Safe.t

val override_graph
  :  skip_overrides_targets:Ast.Reference.SerializableSet.t ->
  maximum_overrides:int option ->
  analyze_all_overrides_targets:Interprocedural.Target.Set.t ->
  t ->
  (skip_overrides_targets:Ast.Reference.SerializableSet.t ->
  maximum_overrides:int option ->
  analyze_all_overrides_targets:Interprocedural.Target.Set.t ->
  unit ->
  Interprocedural.OverrideGraph.whole_program_overrides) ->
  Interprocedural.OverrideGraph.whole_program_overrides * t

val call_graph
  :  attribute_targets:Interprocedural.Target.Set.t ->
  skip_analysis_targets:Interprocedural.Target.Set.t ->
  definitions:Interprocedural.Target.t list ->
  t ->
  (attribute_targets:Interprocedural.Target.Set.t ->
  skip_analysis_targets:Interprocedural.Target.Set.t ->
  definitions:Interprocedural.Target.t list ->
  unit ->
  Interprocedural.CallGraph.call_graphs) ->
  Interprocedural.CallGraph.call_graphs * t

val global_constants
  :  t ->
  (unit -> Interprocedural.GlobalConstants.SharedMemory.t) ->
  Interprocedural.GlobalConstants.SharedMemory.t * t
