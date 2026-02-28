module Connection : sig
  type t =
    { command  : string
    ; pid      : int
    ; user     : string
    ; protocol : string
    ; port     : int
    ; state    : string option
    }

   val of_lsof_line : string -> t option
   val to_string : t -> string
end

val get_lsof_output : unit -> string list
