sil_stage raw

import Builtin
import Swift
import SwiftShims

struct Circle {
  @_hasStorage @_hasInitialValue static var radius: Int { get set }
  init()
}

// one-time initialization token for radius
sil_global private @$s8mainText6CircleV6radius_Wz : $Builtin.Word

// static Circle.radius
sil_global hidden @$s8mainText6CircleV6radiusSivpZ : $Int

// main
sil [ossa] @main : $@convention(c) (Int32, UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>) -> Int32 {
bb0(%0 : $Int32, %1 : $UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>):
  %2 = metatype $@thin Circle.Type
  // function_ref Circle.radius.unsafeMutableAddressor
  %3 = function_ref @$s8mainText6CircleV6radiusSivau : $@convention(thin) () -> Builtin.RawPointer // user: %4
  %4 = apply %3() : $@convention(thin) () -> Builtin.RawPointer // user: %5
  %5 = pointer_to_address %4 : $Builtin.RawPointer to [strict] $*Int // user: %10
  %6 = integer_literal $Builtin.IntLiteral, 20    // user: %9
  %7 = metatype $@thin Int.Type                   // user: %9
  // function_ref Int.init(_builtinIntegerLiteral:)
  %8 = function_ref @$sSi22_builtinIntegerLiteralSiBI_tcfC : $@convention(method) (Builtin.IntLiteral, @thin Int.Type) -> Int // user: %9
  %9 = apply %8(%6, %7) : $@convention(method) (Builtin.IntLiteral, @thin Int.Type) -> Int // user: %11
  %10 = begin_access [modify] [dynamic] %5 : $*Int // users: %12, %11
  assign %9 to %10 : $*Int                        // id: %11
  end_access %10 : $*Int                          // id: %12
  %13 = integer_literal $Builtin.Int32, 0         // user: %14
  %14 = struct $Int32 (%13 : $Builtin.Int32)      // user: %15
  return %14 : $Int32                             // id: %15
} // end sil function 'main'

// one-time initialization function for radius
sil private [global_init_once_fn] [ossa] @$s8mainText6CircleV6radius_WZ : $@convention(c) (Builtin.RawPointer) -> () {
bb0(%0 : $Builtin.RawPointer):
  alloc_global @$s8mainText6CircleV6radiusSivpZ   // id: %1
  %2 = global_addr @$s8mainText6CircleV6radiusSivpZ : $*Int // user: %7
  %3 = integer_literal $Builtin.IntLiteral, 9     // user: %6
  %4 = metatype $@thin Int.Type                   // user: %6
  // function_ref Int.init(_builtinIntegerLiteral:)
  %5 = function_ref @$sSi22_builtinIntegerLiteralSiBI_tcfC : $@convention(method) (Builtin.IntLiteral, @thin Int.Type) -> Int // user: %6
  %6 = apply %5(%3, %4) : $@convention(method) (Builtin.IntLiteral, @thin Int.Type) -> Int // user: %7
  store %6 to [trivial] %2 : $*Int                // id: %7
  %8 = tuple ()                                   // user: %9
  return %8 : $()                                 // id: %9
} // end sil function '$s8mainText6CircleV6radius_WZ'

// Int.init(_builtinIntegerLiteral:)
sil [transparent] [serialized] @$sSi22_builtinIntegerLiteralSiBI_tcfC : $@convention(method) (Builtin.IntLiteral, @thin Int.Type) -> Int

// Circle.radius.unsafeMutableAddressor
sil hidden [global_init] [ossa] @$s8mainText6CircleV6radiusSivau : $@convention(thin) () -> Builtin.RawPointer {
bb0:
  %0 = global_addr @$s8mainText6CircleV6radius_Wz : $*Builtin.Word // user: %1
  %1 = address_to_pointer %0 : $*Builtin.Word to $Builtin.RawPointer // user: %3
  // function_ref one-time initialization function for radius
  %2 = function_ref @$s8mainText6CircleV6radius_WZ : $@convention(c) (Builtin.RawPointer) -> () // user: %3
  %3 = builtin "once"(%1 : $Builtin.RawPointer, %2 : $@convention(c) (Builtin.RawPointer) -> ()) : $()
  %4 = global_addr @$s8mainText6CircleV6radiusSivpZ : $*Int // user: %5
  %5 = address_to_pointer %4 : $*Int to $Builtin.RawPointer // user: %6
  return %5 : $Builtin.RawPointer                 // id: %6
} // end sil function '$s8mainText6CircleV6radiusSivau'

// static Circle.radius.getter
sil hidden [transparent] [ossa] @$s8mainText6CircleV6radiusSivgZ : $@convention(method) (@thin Circle.Type) -> Int {
// %0 "self"                                      // user: %1
bb0(%0 : $@thin Circle.Type):
  debug_value %0 : $@thin Circle.Type, let, name "self", argno 1, implicit // id: %1
  // function_ref Circle.radius.unsafeMutableAddressor
  %2 = function_ref @$s8mainText6CircleV6radiusSivau : $@convention(thin) () -> Builtin.RawPointer // user: %3
  %3 = apply %2() : $@convention(thin) () -> Builtin.RawPointer // user: %4
  %4 = pointer_to_address %3 : $Builtin.RawPointer to [strict] $*Int // user: %5
  %5 = begin_access [read] [dynamic] %4 : $*Int   // users: %7, %6
  %6 = load [trivial] %5 : $*Int                  // user: %8
  end_access %5 : $*Int                           // id: %7
  return %6 : $Int                                // id: %8
} // end sil function '$s8mainText6CircleV6radiusSivgZ'

// static Circle.radius.setter
sil hidden [transparent] [ossa] @$s8mainText6CircleV6radiusSivsZ : $@convention(method) (Int, @thin Circle.Type) -> () {
// %0 "value"                                     // users: %8, %2
// %1 "self"                                      // user: %3
bb0(%0 : $Int, %1 : $@thin Circle.Type):
  debug_value %0 : $Int, let, name "value", argno 1, implicit // id: %2
  debug_value %1 : $@thin Circle.Type, let, name "self", argno 2, implicit // id: %3
  // function_ref Circle.radius.unsafeMutableAddressor
  %4 = function_ref @$s8mainText6CircleV6radiusSivau : $@convention(thin) () -> Builtin.RawPointer // user: %5
  %5 = apply %4() : $@convention(thin) () -> Builtin.RawPointer // user: %6
  %6 = pointer_to_address %5 : $Builtin.RawPointer to [strict] $*Int // user: %7
  %7 = begin_access [modify] [dynamic] %6 : $*Int // users: %9, %8
  assign %0 to %7 : $*Int                         // id: %8
  end_access %7 : $*Int                           // id: %9
  %10 = tuple ()                                  // user: %11
  return %10 : $()                                // id: %11
} // end sil function '$s8mainText6CircleV6radiusSivsZ'

// static Circle.radius.modify
sil hidden [transparent] [ossa] @$s8mainText6CircleV6radiusSivMZ : $@yield_once @convention(method) (@thin Circle.Type) -> @yields @inout Int {
// %0 "self"                                      // user: %1
bb0(%0 : $@thin Circle.Type):
  debug_value %0 : $@thin Circle.Type, let, name "self", argno 1, implicit // id: %1
  // function_ref Circle.radius.unsafeMutableAddressor
  %2 = function_ref @$s8mainText6CircleV6radiusSivau : $@convention(thin) () -> Builtin.RawPointer // user: %3
  %3 = apply %2() : $@convention(thin) () -> Builtin.RawPointer // user: %4
  %4 = pointer_to_address %3 : $Builtin.RawPointer to [strict] $*Int // user: %5
  %5 = begin_access [modify] [dynamic] %4 : $*Int // users: %7, %10, %6
  yield %5 : $*Int, resume bb1, unwind bb2        // id: %6

bb1:                                              // Preds: bb0
  end_access %5 : $*Int                           // id: %7
  %8 = tuple ()                                   // user: %9
  return %8 : $()                                 // id: %9

bb2:                                              // Preds: bb0
  end_access %5 : $*Int                           // id: %10
  unwind                                          // id: %11
} // end sil function '$s8mainText6CircleV6radiusSivMZ'

// Circle.init()
sil hidden [ossa] @$s8mainText6CircleVACycfC : $@convention(method) (@thin Circle.Type) -> Circle {
// %0 "$metatype"
bb0(%0 : $@thin Circle.Type):
  %1 = alloc_box ${ var Circle }, var, name "self" // user: %2
  %2 = mark_uninitialized [rootself] %1 : ${ var Circle } // users: %5, %3
  %3 = project_box %2 : ${ var Circle }, 0        // user: %4
  %4 = load [trivial] %3 : $*Circle               // user: %6
  destroy_value %2 : ${ var Circle }              // id: %5
  return %4 : $Circle                             // id: %6
} // end sil function '$s8mainText6CircleVACycfC'



// Mappings from '#fileID' to '#filePath':
//   'mainText/mainText.swift' => 'mainText.swift'


