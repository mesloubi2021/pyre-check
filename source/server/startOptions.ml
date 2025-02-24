(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

(* TODO(T132410158) Add a module-level doc comment. *)

open Base

module Watchman = struct
  type t = {
    root: PyrePath.t;
    raw: Watchman.Raw.t;
  }
end

type t = {
  environment_controls: Analysis.EnvironmentControls.t;
  source_paths: Configuration.SourcePaths.t;
  socket_path: PyrePath.t;
  watchman: Watchman.t option;
  build_system_initializer: BuildSystem.Initializer.t;
  critical_files: CriticalFile.t list;
  saved_state_action: Saved_state.Action.t option;
  skip_initial_type_check: bool;
}
