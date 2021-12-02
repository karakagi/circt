//===- MooreTypes.cpp - Implement the Moore types -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implement the Moore dialect type system.
//
//===----------------------------------------------------------------------===//

#include "circt/Dialect/Moore/MooreTypes.h"
#include "circt/Dialect/Moore/MooreDialect.h"

#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace circt;
using namespace circt::moore;

//===----------------------------------------------------------------------===//
// TableGen generated logic.
//===----------------------------------------------------------------------===//

// Provide the autogenerated implementation guts for the Op classes.
#define GET_TYPEDEF_CLASSES
#include "circt/Dialect/Moore/MooreTypes.cpp.inc"

//===----------------------------------------------------------------------===//
// Register types to dialect
//===----------------------------------------------------------------------===//

/// Parses a type registered to this dialect
Type MooreDialect::parseType(DialectAsmParser &parser) const {
  llvm::StringRef mnemonic;
  auto loc = parser.getCurrentLocation();
  if (parser.parseKeyword(&mnemonic))
    return Type();
  Type type;
  auto parseResult = generatedTypeParser(parser, mnemonic, type);
  if (parseResult.hasValue())
    return type;
  parser.emitError(loc, "Failed to parse type moore.") << mnemonic << "\n";
  return Type();
}

/// Print a type registered to this dialect
void MooreDialect::printType(Type type, DialectAsmPrinter &printer) const {
  if (succeeded(generatedTypePrinter(type, printer)))
    return;
  llvm_unreachable("unexpected 'moore' type kind");
}

void MooreDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "circt/Dialect/Moore/MooreTypes.cpp.inc"
      >();
}