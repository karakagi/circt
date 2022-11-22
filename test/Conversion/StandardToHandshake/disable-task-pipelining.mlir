// NOTE: Assertions have been autogenerated by utils/update_mlir_test_checks.py
// RUN: circt-opt -lower-std-to-handshake="disable-task-pipelining" %s --split-input-file | FileCheck %s

// CHECK-LABEL:   handshake.func @simple_loop(
// CHECK-SAME:                                %[[VAL_0:.*]]: none, ...) -> none
// CHECK:           %[[VAL_1:.*]] = br %[[VAL_0]] : none
// CHECK:           %[[VAL_2:.*]], %[[VAL_3:.*]] = control_merge %[[VAL_1]] : none
// CHECK:           %[[VAL_4:.*]]:3 = fork [3] %[[VAL_2]] : none
// CHECK:           sink %[[VAL_3]] : index
// CHECK:           %[[VAL_5:.*]] = constant %[[VAL_4]]#1 {value = 1 : index} : index
// CHECK:           %[[VAL_6:.*]] = constant %[[VAL_4]]#0 {value = 42 : index} : index
// CHECK:           %[[VAL_7:.*]] = br %[[VAL_4]]#2 : none
// CHECK:           %[[VAL_8:.*]] = br %[[VAL_5]] : index
// CHECK:           %[[VAL_9:.*]] = br %[[VAL_6]] : index
// CHECK:           %[[VAL_10:.*]] = mux %[[VAL_11:.*]]#1 {{\[}}%[[VAL_12:.*]], %[[VAL_9]]] : index, index
// CHECK:           %[[VAL_13:.*]]:2 = fork [2] %[[VAL_10]] : index
// CHECK:           %[[VAL_14:.*]], %[[VAL_15:.*]] = control_merge %[[VAL_16:.*]], %[[VAL_7]] : none
// CHECK:           %[[VAL_11]]:2 = fork [2] %[[VAL_15]] : index
// CHECK:           %[[VAL_17:.*]] = mux %[[VAL_11]]#0 {{\[}}%[[VAL_18:.*]], %[[VAL_8]]] : index, index
// CHECK:           %[[VAL_19:.*]]:2 = fork [2] %[[VAL_17]] : index
// CHECK:           %[[VAL_20:.*]] = arith.cmpi slt, %[[VAL_19]]#1, %[[VAL_13]]#1 : index
// CHECK:           %[[VAL_21:.*]]:3 = fork [3] %[[VAL_20]] : i1
// CHECK:           %[[VAL_22:.*]], %[[VAL_23:.*]] = cond_br %[[VAL_21]]#2, %[[VAL_13]]#0 : index
// CHECK:           sink %[[VAL_23]] : index
// CHECK:           %[[VAL_24:.*]], %[[VAL_25:.*]] = cond_br %[[VAL_21]]#1, %[[VAL_14]] : none
// CHECK:           %[[VAL_26:.*]], %[[VAL_27:.*]] = cond_br %[[VAL_21]]#0, %[[VAL_19]]#0 : index
// CHECK:           sink %[[VAL_27]] : index
// CHECK:           %[[VAL_28:.*]] = merge %[[VAL_26]] : index
// CHECK:           %[[VAL_29:.*]] = merge %[[VAL_22]] : index
// CHECK:           %[[VAL_30:.*]], %[[VAL_31:.*]] = control_merge %[[VAL_24]] : none
// CHECK:           %[[VAL_32:.*]]:2 = fork [2] %[[VAL_30]] : none
// CHECK:           sink %[[VAL_31]] : index
// CHECK:           %[[VAL_33:.*]] = constant %[[VAL_32]]#0 {value = 1 : index} : index
// CHECK:           %[[VAL_34:.*]] = arith.addi %[[VAL_28]], %[[VAL_33]] : index
// CHECK:           %[[VAL_12]] = br %[[VAL_29]] : index
// CHECK:           %[[VAL_16]] = br %[[VAL_32]]#1 : none
// CHECK:           %[[VAL_18]] = br %[[VAL_34]] : index
// CHECK:           %[[VAL_35:.*]], %[[VAL_36:.*]] = control_merge %[[VAL_25]] : none
// CHECK:           sink %[[VAL_36]] : index
// CHECK:           return %[[VAL_35]] : none
// CHECK:         }
func.func @simple_loop() {
^bb0:
  cf.br ^bb1
^bb1:	// pred: ^bb0
  %c1 = arith.constant 1 : index
  %c42 = arith.constant 42 : index
  cf.br ^bb2(%c1 : index)
^bb2(%0: index):	// 2 preds: ^bb1, ^bb3
  %1 = arith.cmpi slt, %0, %c42 : index
  cf.cond_br %1, ^bb3, ^bb4
^bb3:	// pred: ^bb2
  %c1_0 = arith.constant 1 : index
  %2 = arith.addi %0, %c1_0 : index
  cf.br ^bb2(%2 : index)
^bb4:	// pred: ^bb2
  return
}

// -----

// CHECK-LABEL:   handshake.func @simpleDiamond(
// CHECK-SAME:                                  %[[VAL_0:.*]]: i1,
// CHECK-SAME:                                  %[[VAL_1:.*]]: i64,
// CHECK-SAME:                                  %[[VAL_2:.*]]: none, ...) -> none
// CHECK:           %[[VAL_3:.*]] = merge %[[VAL_0]] : i1
// CHECK:           %[[VAL_4:.*]]:2 = fork [2] %[[VAL_3]] : i1
// CHECK:           %[[VAL_5:.*]] = merge %[[VAL_1]] : i64
// CHECK:           %[[VAL_6:.*]], %[[VAL_7:.*]] = cond_br %[[VAL_4]]#1, %[[VAL_5]] : i64
// CHECK:           %[[VAL_8:.*]], %[[VAL_9:.*]] = cond_br %[[VAL_4]]#0, %[[VAL_2]] : none
// CHECK:           %[[VAL_10:.*]], %[[VAL_11:.*]] = control_merge %[[VAL_8]] : none
// CHECK:           sink %[[VAL_11]] : index
// CHECK:           %[[VAL_12:.*]] = merge %[[VAL_6]] : i64
// CHECK:           %[[VAL_13:.*]] = br %[[VAL_10]] : none
// CHECK:           %[[VAL_14:.*]] = br %[[VAL_12]] : i64
// CHECK:           %[[VAL_15:.*]], %[[VAL_16:.*]] = control_merge %[[VAL_9]] : none
// CHECK:           sink %[[VAL_16]] : index
// CHECK:           %[[VAL_17:.*]] = merge %[[VAL_7]] : i64
// CHECK:           %[[VAL_18:.*]] = br %[[VAL_15]] : none
// CHECK:           %[[VAL_19:.*]] = br %[[VAL_17]] : i64
// CHECK:           %[[VAL_20:.*]], %[[VAL_21:.*]] = control_merge %[[VAL_18]], %[[VAL_13]] : none
// CHECK:           %[[VAL_22:.*]] = mux %[[VAL_21]] {{\[}}%[[VAL_19]], %[[VAL_14]]] : index, i64
// CHECK:           sink %[[VAL_22]] : i64
// CHECK:           return %[[VAL_20]] : none
// CHECK:         }
func.func @simpleDiamond(%arg0: i1, %arg1: i64) {
  cf.cond_br %arg0, ^bb1(%arg1: i64), ^bb2(%arg1: i64)
^bb1(%v1: i64):  // pred: ^bb0
  cf.br ^bb3(%v1: i64)
^bb2(%v2: i64):  // pred: ^bb0
  cf.br ^bb3(%v2: i64)
^bb3(%v3: i64):  // 2 preds: ^bb1, ^bb2
  return
}