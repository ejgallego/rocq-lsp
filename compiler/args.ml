module Display = struct
  type t =
    | Verbose
    | Normal
    | Quiet
end

type t =
  { cmdline : Coq.Workspace.CmdLine.t
  ; roots : string list  (** workspace root(s) *)
  ; files : string list  (** files to compile *)
  ; debug : bool  (** run in debug mode *)
  ; display : Display.t  (** display level *)
  ; plugins : string list  (** Flèche plugins to load *)
  ; trace_file : string option  (** Save flame profile to file *)
  ; max_errors : int option
        (** Maximum erros before aborting the compilation *)
  ; coq_diags_level : int
        (** Whether to include feedback messages in the diagnostics *)
  ; record_comments : bool  (** Record comments (experimental) *)
  ; save_vof : bool         (** Save a vof file  *)
  ; load_vof : bool         (** Load a vof file instead of compiling  *)
  }

let compute_default_plugins ~no_vo ~plugins =
  if no_vo then plugins else "coq-lsp.plugin.save_vo" :: plugins
