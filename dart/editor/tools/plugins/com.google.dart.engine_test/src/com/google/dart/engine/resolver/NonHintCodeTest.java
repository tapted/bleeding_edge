/*
 * Copyright (c) 2013, the Dart project authors.
 * 
 * Licensed under the Eclipse Public License v1.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 * 
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package com.google.dart.engine.resolver;

import com.google.dart.engine.source.Source;

public class NonHintCodeTest extends ResolverTestCase {
  public void test_deadCode_deadBlock_conditionalElse_debugConst() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = true;",
        "f() {",
        "  DEBUG ? 1 : 2;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_conditionalIf_debugConst() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = false;",
        "f() {",
        "  DEBUG ? 1 : 2;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_else() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = true;",
        "f() {",
        "  if(DEBUG) {} else {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_if_debugConst_prefixedIdentifier() throws Exception {
    Source source = addSource(createSource(//
        "class A {",
        "  static const bool DEBUG = false;",
        "}",
        "f() {",
        "  if(A.DEBUG) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_if_debugConst_prefixedIdentifier2() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib2.dart';",
        "f() {",
        "  if(A.DEBUG) {}",
        "}"));
    addSource("/lib2.dart", createSource(//
        "library lib2;",
        "class A {",
        "  static const bool DEBUG = false;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_if_debugConst_propertyAccessor() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib2.dart' as LIB;",
        "f() {",
        "  if(LIB.A.DEBUG) {}",
        "}"));
    addSource("/lib2.dart", createSource(//
        "library lib2;",
        "class A {",
        "  static const bool DEBUG = false;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_if_debugConst_simpleIdentifier() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = false;",
        "f() {",
        "  if(DEBUG) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadBlock_while_debugConst() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = false;",
        "f() {",
        "  while(DEBUG) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadCatch_onCatchSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {}",
        "f() {",
        "  try {} on B catch (e) {} on A catch (e) {} catch (e) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadOperandLHS_and_debugConst() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = false;",
        "f() {",
        "  bool b = DEBUG && false;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_deadCode_deadOperandLHS_or_debugConst() throws Exception {
    Source source = addSource(createSource(//
        "const bool DEBUG = true;",
        "f() {",
        "  bool b = DEBUG || true;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_divisionOptimization() throws Exception {
    Source source = addSource(createSource(//
        "f(int x, int y) {",
        "  var v = x / y.toInt();",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_divisionOptimization_supressIfDivisionNotDefinedInCore() throws Exception {
    Source source = addSource(createSource(//
        "f(x, y) {",
        "  var v = (x / y).toInt();",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_divisionOptimization_supressIfDivisionOverridden() throws Exception {
    Source source = addSource(createSource(//
        "class A {",
        "  num operator /(x) { return x; }",
        "}",
        "f(A x, A y) {",
        "  var v = (x / y).toInt();",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_duplicateImport_as() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "import 'lib1.dart' as one;",
        "A a;",
        "one.A a2;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "class A {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_duplicateImport_hide() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "import 'lib1.dart' hide A;",
        "A a;",
        "B b;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "class A {}",
        "class B {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_duplicateImport_show() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "import 'lib1.dart' show A;",
        "A a;",
        "B b;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "class A {}",
        "class B {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_missingReturn_emptyFunctionBody() throws Exception {
    Source source = addSource(createSource(//
        "abstract class A {",
        "  int m();",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_missingReturn_expressionFunctionBody() throws Exception {
    Source source = addSource(createSource(//
    "int f() => 0;"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_missingReturn_noReturnType() throws Exception {
    Source source = addSource(createSource(//
    "f() {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_missingReturn_voidReturnType() throws Exception {
    Source source = addSource(createSource(//
    "void f() {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overriddingPrivateMember_sameLibrary() throws Exception {
    Source source = addSource(createSource(//
        "class A {",
        "  _m(int x) => 0;",
        "}",
        "class B extends A {",
        "  _m(int x) => 0;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideEqualsButNotHashCode() throws Exception {
    Source source = addSource(createSource(//
        "class A {",
        "  bool operator ==(x) { return x; }",
        "  get hashCode => 0;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingGetter_inInterface() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  int get m => 0;",
        "}",
        "class B implements A {",
        "  @override",
        "  int get m => 1;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingGetter_inSuperclass() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  int get m => 0;",
        "}",
        "class B extends A {",
        "  @override",
        "  int get m => 1;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingMethod_inInterface() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  int m() => 0;",
        "}",
        "class B implements A {",
        "  @override",
        "  int m() => 1;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingMethod_inSuperclass() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  int m() => 0;",
        "}",
        "class B extends A {",
        "  @override",
        "  int m() => 1;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingSetter_inInterface() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  set m(int x) {}",
        "}",
        "class B implements A {",
        "  @override",
        "  set m(int x) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_overrideOnNonOverridingSetter_inSuperclass() throws Exception {
    Source source = addSource(createSource(//
        "library dart.core;",
        "const override = null;",
        "class A {",
        "  set m(int x) {}",
        "}",
        "class B extends A {",
        "  @override",
        "  set m(int x) {}",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_proxy_annotation_prefixed() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "@proxy",
        "class A {}",
        "f(var a) {",
        "  a = new A();",
        "  a.m();",
        "  var x = a.g;",
        "  a.s = 1;",
        "  var y = a + a;",
        "  a++;",
        "  ++a;",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_proxy_annotation_prefixed2() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "@proxy",
        "class A {}",
        "class B {",
        "  f(var a) {",
        "    a = new A();",
        "    a.m();",
        "    var x = a.g;",
        "    a.s = 1;",
        "    var y = a + a;",
        "    a++;",
        "    ++a;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_proxy_annotation_prefixed3() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "class B {",
        "  f(var a) {",
        "    a = new A();",
        "    a.m();",
        "    var x = a.g;",
        "    a.s = 1;",
        "    var y = a + a;",
        "    a++;",
        "    ++a;",
        "  }",
        "}",
        "@proxy",
        "class A {}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedGetter_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  get b => 0;",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    return a.b;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedMethod_assignmentExpression_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator +(B b) {return new B();}",
        "}",
        "f(var a, var a2) {",
        "  a = new A();",
        "  a2 = new A();",
        "  a += a2;",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedMethod_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  b() {}",
        "}",
        "f() {",
        "  var a = new A();",
        "  a.b();",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_binaryExpression_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator +(B b) {}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a + 1;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_indexBoth_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator [](int index) {}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a[0]++;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_indexGetter_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator [](int index) {}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a[0];",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_indexSetter_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator []=(i, v) {}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a[0] = 1;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_postfixExpression() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator +(B b) {return new B();}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a++;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedOperator_prefixExpression() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  operator +(B b) {return new B();}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    ++a;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_undefinedSetter_inSubtype() throws Exception {
    Source source = addSource(createSource(//
        "class A {}",
        "class B extends A {",
        "  set b(x) {}",
        "}",
        "f(var a) {",
        "  if(a is A) {",
        "    a.b = 0;",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
  }

  public void test_unnecessaryCast_13855_parameter_A() throws Exception {
    // dartbug.com/13855, dartbug.com/13732
    Source source = addSource(createSource(//
        "class A{",
        "  a() {}",
        "}",
        "class B<E> {",
        "  E e;",
        "  m() {",
        "    (e as A).a();",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unnecessaryCast_dynamic_type() throws Exception {
    Source source = addSource(createSource(//
        "m(v) {",
        "  var b = v as Object;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unnecessaryCast_type_dynamic() throws Exception {
    Source source = addSource(createSource(//
        "m(v) {",
        "  var b = Object as dynamic;",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unusedImport_annotationOnDirective() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "@A()",
        "import 'lib1.dart';"));
    Source source2 = addSource("/lib1.dart", createSource(//
        "library lib1;",
        "class A {",
        "  const A() {}",
        "}"));
    resolve(source);
    assertErrors(source);
    verify(source, source2);
  }

  public void test_unusedImport_core_library() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'dart:core';"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unusedImport_export() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "Two two;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "export 'lib2.dart';",
        "class One {}"));
    addSource("/lib2.dart", createSource(//
        "library lib2;",
        "class Two {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unusedImport_export_infiniteLoop() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "Two two;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "export 'lib2.dart';",
        "class One {}"));
    addSource("/lib2.dart", createSource(//
        "library lib2;",
        "export 'lib3.dart';",
        "class Two {}"));
    addSource("/lib3.dart", createSource(//
        "library lib3;",
        "export 'lib2.dart';",
        "class Three {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unusedImport_export2() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart';",
        "Three three;"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "export 'lib2.dart';",
        "class One {}"));
    addSource("/lib2.dart", createSource(//
        "library lib2;",
        "export 'lib3.dart';",
        "class Two {}"));
    addSource("/lib3.dart", createSource(//
        "library lib3;",
        "class Three {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_unusedImport_prefix_topLevelFunction() throws Exception {
    Source source = addSource(createSource(//
        "library L;",
        "import 'lib1.dart' hide topLevelFunction;",
        "import 'lib1.dart' as one show topLevelFunction;",
        "class A {",
        "  static void x() {",
        "    One o;",
        "    one.topLevelFunction();",
        "  }",
        "}"));
    addSource("/lib1.dart", createSource(//
        "library lib1;",
        "class One {}",
        "topLevelFunction() {}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_useOfVoidResult_implicitReturnValue() throws Exception {
    Source source = addSource(createSource(//
        "f() {}",
        "class A {",
        "  n() {",
        "    var a = f();",
        "  }",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }

  public void test_useOfVoidResult_nonVoidReturnValue() throws Exception {
    Source source = addSource(createSource(//
        "int f() => 1;",
        "g() {",
        "  var a = f();",
        "}"));
    resolve(source);
    assertNoErrors(source);
    verify(source);
  }
}
