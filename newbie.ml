(* top-level of newbie compiler *)

type actions = TOKEN (* | AST | SAST | LLVIM_IR | COMPILE *) | DEFAULT

let main () =
  let is_tag str =
    String.get str 0 = '-'
  in
  let action = 
    if (Array.length Sys.argv = 3 && is_tag Sys.argv.(1)) then                  (* tag arg *)
      List.assoc Sys.argv.(1) [ ("-t", TOKEN)   ; (* output tokens only *)
        (* 
          ("-a", AST)       ; (* output ast only*)
          ("-s", SAST)      ; (* output sast only *)
          ("-l", LLVIM_IR)  ; (* generate, do NOT check *)
          ("-c", COMPILE)     (* generate, check LLVM IR *)
         *)
      ]
    else if (Array.length Sys.argv = 2 && not (is_tag Sys.argv.(1))) then       (* no tag *)
      DEFAULT
    else                                                                        (* error *)
      raise (Failure("invalid format ./newbie [-tag] path_to_file"))
  in
  let get_channel = function
      DEFAULT     -> open_in (Sys.argv.(1))
    | _           -> open_in (Sys.argv.(2))
  in
  let lexbuf = Lexing.from_channel (get_channel action) in
  let tokens = Scanner.token [] lexbuf in
  (* let gen_ast = Parser.program tokens in *)
  (* let gen_sast = Semant.check gen_ast in *)
  match action with
      TOKEN         -> print_endline (Scanner.string_of_tokens tokens)
    (* | AST             -> print_endline (Ast.string_of_program gen_ast) *)
    (* | SAST            -> print_endline (Sast.string_of_program gen_sast) *)
    (* | LLVIM_IR        -> print_endline (LLvm.string_of_llmodule (Codegen.translate gen_sast)) *)
    (* | COMPILE         -> let m = Codegen.translate gen_sast in
         Llvm_analysis.assert_valid_module m; print_string (LLvm.string_of_llmodule m) *)
    | DEFAULT       -> print_endline (Scanner.string_of_tokens tokens)

let _ = Printexc.print main ()
