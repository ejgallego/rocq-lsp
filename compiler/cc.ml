(* Compiler context *)
type t =
  { root_state : Pure.State.t
  ; workspaces : (string * (Pure.Workspace.t, string) Result.t) list
  ; default : Pure.Workspace.t
  ; io : Fleche.Io.CallBack.t
  ; token : Pure.Limits.Token.t
  }
