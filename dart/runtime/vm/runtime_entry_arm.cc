// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "vm/globals.h"
#if defined(TARGET_ARCH_ARM)

#include "vm/runtime_entry.h"

#include "vm/assembler.h"
#include "vm/simulator.h"
#include "vm/stub_code.h"

namespace dart {

#define __ assembler->


// Generate code to call into the stub which will call the runtime
// function. Input for the stub is as follows:
//   SP : points to the arguments and return value array.
//   R5 : address of the runtime function to call.
//   R4 : number of arguments to the call.
void RuntimeEntry::Call(Assembler* assembler) const {
  // Compute the effective address. When running under the simulator,
  // this is a redirection address that forces the simulator to call
  // into the runtime system.
  uword entry = GetEntryPoint();
#if defined(USING_SIMULATOR)
  entry = Simulator::RedirectExternalReference(entry, argument_count());
#endif
  if (is_leaf()) {
    ExternalLabel label(name(), entry);
    __ BranchLink(&label);
  } else {
    __ LoadImmediate(R5, entry);
    __ LoadImmediate(R4, argument_count());
    __ BranchLink(&StubCode::CallToRuntimeLabel());
  }
}

}  // namespace dart

#endif  // defined TARGET_ARCH_ARM
