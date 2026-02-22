
module type S = sig
  type t

  val empty : t

  val set : t -> key:string -> value:string -> t

  val get : t -> key:string -> string option

  val to_list : t -> (string * string) list

end
