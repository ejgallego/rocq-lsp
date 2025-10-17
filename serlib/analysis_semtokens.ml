(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors           *)
(************************************************************************)
(* Flèche => Semantic Token Analysis                                    *)
(************************************************************************)

module Color_info = struct

  type t = { range : Loc.t; color: string }

  let make range color = { range; color }

  let pp fmt { range; color } =
    let range = Loc.pr range in
    Format.fprintf fmt "{ range: %a; color: %s }" Pp.pp_with range color

end

module Color_analysis = struct

  type a = Color_info.t list

  let name = "color_analysis"
  let default pname =
    let range = Loc.initial ToplevelInput in
    Some [Color_info.{ range; color = pname }]

  let fold_list = List.concat

  let fold_option = function
    | Some x -> x
    | None -> []

  let fold_pair (n1, n2) = n1 @ n2
end

(* Color Info Analyzer *)
include Ser_genarg.Analyzer.Make (Color_analysis)
