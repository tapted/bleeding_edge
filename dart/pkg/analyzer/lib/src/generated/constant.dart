// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This code was auto-generated, is not intended to be edited, and is subject to
// significant change. Please see the README file for more information.

library engine.constant;

import 'java_core.dart';
import 'java_engine.dart' show ObjectUtilities;
import 'source.dart' show Source;
import 'error.dart' show AnalysisError, ErrorCode, CompileTimeErrorCode;
import 'scanner.dart' show Token, TokenType;
import 'ast.dart';
import 'element.dart';
import 'resolver.dart' show TypeProvider;
import 'engine.dart' show AnalysisEngine;
import 'utilities_dart.dart' show ParameterKind;

/**
 * Instances of the class `ConstantEvaluator` evaluate constant expressions to produce their
 * compile-time value. According to the Dart Language Specification: <blockquote> A constant
 * expression is one of the following:
 * * A literal number.
 * * A literal boolean.
 * * A literal string where any interpolated expression is a compile-time constant that evaluates
 * to a numeric, string or boolean value or to <b>null</b>.
 * * A literal symbol.
 * * <b>null</b>.
 * * A qualified reference to a static constant variable.
 * * An identifier expression that denotes a constant variable, class or type alias.
 * * A constant constructor invocation.
 * * A constant list literal.
 * * A constant map literal.
 * * A simple or qualified identifier denoting a top-level function or a static method.
 * * A parenthesized expression <i>(e)</i> where <i>e</i> is a constant expression.
 * * An expression of the form <i>identical(e<sub>1</sub>, e<sub>2</sub>)</i> where
 * <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions and <i>identical()</i> is
 * statically bound to the predefined dart function <i>identical()</i> discussed above.
 * * An expression of one of the forms <i>e<sub>1</sub> == e<sub>2</sub></i> or <i>e<sub>1</sub>
 * != e<sub>2</sub></i> where <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions
 * that evaluate to a numeric, string or boolean value.
 * * An expression of one of the forms <i>!e</i>, <i>e<sub>1</sub> &amp;&amp; e<sub>2</sub></i> or
 * <i>e<sub>1</sub> || e<sub>2</sub></i>, where <i>e</i>, <i>e1</sub></i> and <i>e2</sub></i> are
 * constant expressions that evaluate to a boolean value.
 * * An expression of one of the forms <i>~e</i>, <i>e<sub>1</sub> ^ e<sub>2</sub></i>,
 * <i>e<sub>1</sub> &amp; e<sub>2</sub></i>, <i>e<sub>1</sub> | e<sub>2</sub></i>, <i>e<sub>1</sub>
 * &gt;&gt; e<sub>2</sub></i> or <i>e<sub>1</sub> &lt;&lt; e<sub>2</sub></i>, where <i>e</i>,
 * <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions that evaluate to an
 * integer value or to <b>null</b>.
 * * An expression of one of the forms <i>-e</i>, <i>e<sub>1</sub> + e<sub>2</sub></i>,
 * <i>e<sub>1</sub> -e<sub>2</sub></i>, <i>e<sub>1</sub> * e<sub>2</sub></i>, <i>e<sub>1</sub> /
 * e<sub>2</sub></i>, <i>e<sub>1</sub> ~/ e<sub>2</sub></i>, <i>e<sub>1</sub> &gt;
 * e<sub>2</sub></i>, <i>e<sub>1</sub> &lt; e<sub>2</sub></i>, <i>e<sub>1</sub> &gt;=
 * e<sub>2</sub></i>, <i>e<sub>1</sub> &lt;= e<sub>2</sub></i> or <i>e<sub>1</sub> %
 * e<sub>2</sub></i>, where <i>e</i>, <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant
 * expressions that evaluate to a numeric value or to <b>null</b>.
 * * An expression of the form <i>e<sub>1</sub> ? e<sub>2</sub> : e<sub>3</sub></i> where
 * <i>e<sub>1</sub></i>, <i>e<sub>2</sub></i> and <i>e<sub>3</sub></i> are constant expressions, and
 * <i>e<sub>1</sub></i> evaluates to a boolean value.
 * </blockquote>
 */
class ConstantEvaluator {
  /**
   * The source containing the expression(s) that will be evaluated.
   */
  Source _source;

  /**
   * The type provider used to access the known types.
   */
  TypeProvider _typeProvider;

  /**
   * Initialize a newly created evaluator to evaluate expressions in the given source.
   *
   * @param source the source containing the expression(s) that will be evaluated
   * @param typeProvider the type provider used to access known types
   */
  ConstantEvaluator(Source source, TypeProvider typeProvider) {
    this._source = source;
    this._typeProvider = typeProvider;
  }

  EvaluationResult evaluate(Expression expression) {
    EvaluationResultImpl result = expression.accept(new ConstantVisitor(_typeProvider));
    if (result is ValidResult) {
      return EvaluationResult.forValue(result.value);
    }
    List<AnalysisError> errors = new List<AnalysisError>();
    for (ErrorResult_ErrorData data in (result as ErrorResult).errorData) {
      AstNode node = data.node;
      errors.add(new AnalysisError.con2(_source, node.offset, node.length, data.errorCode, []));
    }
    return EvaluationResult.forErrors(new List.from(errors));
  }
}

/**
 * The interface `DartObject` defines the behavior of objects that represent the state of a
 * Dart object.
 */
abstract class DartObject {
  /**
   * Return the boolean value of this object, or `null` if either the value of this object is
   * not known or this object is not of type 'bool'.
   *
   * @return the boolean value of this object
   */
  bool get boolValue;

  /**
   * Return the floating point value of this object, or `null` if either the value of this
   * object is not known or this object is not of type 'double'.
   *
   * @return the floating point value of this object
   */
  double get doubleValue;

  /**
   * Return the integer value of this object, or `null` if either the value of this object is
   * not known or this object is not of type 'int'.
   *
   * @return the integer value of this object
   */
  int get intValue;

  /**
   * Return the string value of this object, or `null` if either the value of this object is
   * not known or this object is not of type 'String'.
   *
   * @return the string value of this object
   */
  String get stringValue;

  /**
   * Return the run-time type of this object.
   *
   * @return the run-time type of this object
   */
  InterfaceType get type;

  /**
   * Return this object's value if it can be represented exactly, or `null` if either the
   * value cannot be represented exactly or if the value is `null`. Clients should use
   * [hasExactValue] to distinguish between these two cases.
   *
   * @return this object's value
   */
  Object get value;

  /**
   * Return `true` if this object's value can be represented exactly.
   *
   * @return `true` if this object's value can be represented exactly
   */
  bool hasExactValue();

  /**
   * Return `true` if this object represents the value 'false'.
   *
   * @return `true` if this object represents the value 'false'
   */
  bool get isFalse;

  /**
   * Return `true` if this object represents the value 'null'.
   *
   * @return `true` if this object represents the value 'null'
   */
  bool get isNull;

  /**
   * Return `true` if this object represents the value 'true'.
   *
   * @return `true` if this object represents the value 'true'
   */
  bool get isTrue;
}

/**
 * Instances of the class `EvaluationResult` represent the result of attempting to evaluate an
 * expression.
 */
class EvaluationResult {
  /**
   * Return an evaluation result representing the result of evaluating an expression that is not a
   * compile-time constant because of the given errors.
   *
   * @param errors the errors that should be reported for the expression(s) that were evaluated
   * @return the result of evaluating an expression that is not a compile-time constant
   */
  static EvaluationResult forErrors(List<AnalysisError> errors) => new EvaluationResult(null, errors);

  /**
   * Return an evaluation result representing the result of evaluating an expression that is a
   * compile-time constant that evaluates to the given value.
   *
   * @param value the value of the expression
   * @return the result of evaluating an expression that is a compile-time constant
   */
  static EvaluationResult forValue(DartObject value) => new EvaluationResult(value, null);

  /**
   * The value of the expression.
   */
  final DartObject value;

  /**
   * The errors that should be reported for the expression(s) that were evaluated.
   */
  List<AnalysisError> _errors;

  /**
   * Initialize a newly created result object with the given state. Clients should use one of the
   * factory methods: [forErrors] and [forValue].
   *
   * @param value the value of the expression
   * @param errors the errors that should be reported for the expression(s) that were evaluated
   */
  EvaluationResult(this.value, List<AnalysisError> errors) {
    this._errors = errors;
  }

  /**
   * Return an array containing the errors that should be reported for the expression(s) that were
   * evaluated. If there are no such errors, the array will be empty. The array can be empty even if
   * the expression is not a valid compile time constant if the errors would have been reported by
   * other parts of the analysis engine.
   */
  List<AnalysisError> get errors => _errors == null ? AnalysisError.NO_ERRORS : _errors;

  /**
   * Return `true` if the expression is a compile-time constant expression that would not
   * throw an exception when evaluated.
   *
   * @return `true` if the expression is a valid compile-time constant expression
   */
  bool get isValid => _errors == null;
}

/**
 * Instances of the class `ConstantFinder` are used to traverse the AST structures of all of
 * the compilation units being resolved and build a table mapping constant variable elements to the
 * declarations of those variables.
 */
class ConstantFinder extends RecursiveAstVisitor<Object> {
  /**
   * A table mapping constant variable elements to the declarations of those variables.
   */
  final Map<VariableElement, VariableDeclaration> variableMap = new Map<VariableElement, VariableDeclaration>();

  Object visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    Expression initializer = node.initializer;
    if (initializer != null && node.isConst) {
      VariableElement element = node.element;
      if (element != null) {
        variableMap[element] = node;
      }
    }
    return null;
  }
}

/**
 * Instances of the class `ConstantValueComputer` compute the values of constant variables in
 * one or more compilation units. The expected usage pattern is for the compilation units to be
 * added to this computer using the method [add] and then for the method
 * [computeValues] to be invoked exactly once. Any use of an instance after invoking the
 * method [computeValues] will result in unpredictable behavior.
 */
class ConstantValueComputer {
  /**
   * The type provider used to access the known types.
   */
  TypeProvider _typeProvider;

  /**
   * The object used to find constant variables in the compilation units that were added.
   */
  ConstantFinder _constantFinder = new ConstantFinder();

  /**
   * A graph in which the nodes are the constant variables and the edges are from each variable to
   * the other constant variables that are referenced in the head's initializer.
   */
  DirectedGraph<VariableElement> _referenceGraph = new DirectedGraph<VariableElement>();

  /**
   * A table mapping constant variables to the declarations of those variables.
   */
  Map<VariableElement, VariableDeclaration> _declarationMap;

  /**
   * Initialize a newly created constant value computer.
   *
   * @param typeProvider the type provider used to access known types
   */
  ConstantValueComputer(TypeProvider typeProvider) {
    this._typeProvider = typeProvider;
  }

  /**
   * Add the constant variables in the given compilation unit to the list of constant variables
   * whose value needs to be computed.
   *
   * @param unit the compilation unit defining the constant variables to be added
   */
  void add(CompilationUnit unit) {
    unit.accept(_constantFinder);
  }

  /**
   * Compute values for all of the constant variables in the compilation units that were added.
   */
  void computeValues() {
    _declarationMap = _constantFinder.variableMap;
    for (MapEntry<VariableElement, VariableDeclaration> entry in getMapEntrySet(_declarationMap)) {
      VariableElement element = entry.getKey();
      ReferenceFinder referenceFinder = new ReferenceFinder(element, _referenceGraph);
      _referenceGraph.addNode(element);
      entry.getValue().initializer.accept(referenceFinder);
    }
    while (!_referenceGraph.isEmpty) {
      VariableElement element = _referenceGraph.removeSink();
      while (element != null) {
        computeValueFor(element);
        element = _referenceGraph.removeSink();
      }
      if (!_referenceGraph.isEmpty) {
        List<VariableElement> variablesInCycle = _referenceGraph.findCycle();
        if (variablesInCycle == null) {
          //
          // This should not happen. Either the graph should be empty, or there should be at least
          // one sink, or there should be a cycle. If this does happen we exit to prevent an
          // infinite loop.
          //
          AnalysisEngine.instance.logger.logError("Exiting constant value computer with ${_referenceGraph.nodeCount} variables that are neither sinks nor in a cycle");
          return;
        }
        for (VariableElement variable in variablesInCycle) {
          generateCycleError(variablesInCycle, variable);
        }
        _referenceGraph.removeAllNodes(variablesInCycle);
      }
    }
  }

  /**
   * Compute a value for the given variable.
   *
   * @param variable the variable for which a value is to be computed
   */
  void computeValueFor(VariableElement variable) {
    VariableDeclaration declaration = _declarationMap[variable];
    if (declaration == null) {
      //
      // The declaration will be null when the variable was added to the graph as a result of being
      // referenced by another variable but is not defined in the compilation units that were added
      // to this computer. In such cases, the variable should already have a value associated with
      // it, but we don't bother to check because there's nothing we can do about it at this point.
      //
      return;
    }
    EvaluationResultImpl result = declaration.initializer.accept(new ConstantVisitor(_typeProvider));
    (variable as VariableElementImpl).evaluationResult = result;
    if (result is ErrorResult) {
      List<AnalysisError> errors = new List<AnalysisError>();
      for (ErrorResult_ErrorData data in result.errorData) {
        AstNode node = data.node;
        Source source = variable.getAncestor((element) => element is CompilationUnitElement).source;
        errors.add(new AnalysisError.con2(source, node.offset, node.length, data.errorCode, []));
      }
    }
  }

  /**
   * Generate an error indicating that the given variable is not a valid compile-time constant
   * because it references at least one of the variables in the given cycle, each of which directly
   * or indirectly references the variable.
   *
   * @param variablesInCycle the variables in the cycle that includes the given variable
   * @param variable the variable that is not a valid compile-time constant
   */
  void generateCycleError(List<VariableElement> variablesInCycle, VariableElement variable) {
  }
}

/**
 * Instances of the class `ConstantVisitor` evaluate constant expressions to produce their
 * compile-time value. According to the Dart Language Specification: <blockquote> A constant
 * expression is one of the following:
 * * A literal number.
 * * A literal boolean.
 * * A literal string where any interpolated expression is a compile-time constant that evaluates
 * to a numeric, string or boolean value or to <b>null</b>.
 * * A literal symbol.
 * * <b>null</b>.
 * * A qualified reference to a static constant variable.
 * * An identifier expression that denotes a constant variable, class or type alias.
 * * A constant constructor invocation.
 * * A constant list literal.
 * * A constant map literal.
 * * A simple or qualified identifier denoting a top-level function or a static method.
 * * A parenthesized expression <i>(e)</i> where <i>e</i> is a constant expression.
 * * An expression of the form <i>identical(e<sub>1</sub>, e<sub>2</sub>)</i> where
 * <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions and <i>identical()</i> is
 * statically bound to the predefined dart function <i>identical()</i> discussed above.
 * * An expression of one of the forms <i>e<sub>1</sub> == e<sub>2</sub></i> or <i>e<sub>1</sub>
 * != e<sub>2</sub></i> where <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions
 * that evaluate to a numeric, string or boolean value.
 * * An expression of one of the forms <i>!e</i>, <i>e<sub>1</sub> &amp;&amp; e<sub>2</sub></i> or
 * <i>e<sub>1</sub> || e<sub>2</sub></i>, where <i>e</i>, <i>e1</sub></i> and <i>e2</sub></i> are
 * constant expressions that evaluate to a boolean value.
 * * An expression of one of the forms <i>~e</i>, <i>e<sub>1</sub> ^ e<sub>2</sub></i>,
 * <i>e<sub>1</sub> &amp; e<sub>2</sub></i>, <i>e<sub>1</sub> | e<sub>2</sub></i>, <i>e<sub>1</sub>
 * &gt;&gt; e<sub>2</sub></i> or <i>e<sub>1</sub> &lt;&lt; e<sub>2</sub></i>, where <i>e</i>,
 * <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant expressions that evaluate to an
 * integer value or to <b>null</b>.
 * * An expression of one of the forms <i>-e</i>, <i>e<sub>1</sub> + e<sub>2</sub></i>,
 * <i>e<sub>1</sub> - e<sub>2</sub></i>, <i>e<sub>1</sub> * e<sub>2</sub></i>, <i>e<sub>1</sub> /
 * e<sub>2</sub></i>, <i>e<sub>1</sub> ~/ e<sub>2</sub></i>, <i>e<sub>1</sub> &gt;
 * e<sub>2</sub></i>, <i>e<sub>1</sub> &lt; e<sub>2</sub></i>, <i>e<sub>1</sub> &gt;=
 * e<sub>2</sub></i>, <i>e<sub>1</sub> &lt;= e<sub>2</sub></i> or <i>e<sub>1</sub> %
 * e<sub>2</sub></i>, where <i>e</i>, <i>e<sub>1</sub></i> and <i>e<sub>2</sub></i> are constant
 * expressions that evaluate to a numeric value or to <b>null</b>.
 * * An expression of the form <i>e<sub>1</sub> ? e<sub>2</sub> : e<sub>3</sub></i> where
 * <i>e<sub>1</sub></i>, <i>e<sub>2</sub></i> and <i>e<sub>3</sub></i> are constant expressions, and
 * <i>e<sub>1</sub></i> evaluates to a boolean value.
 * </blockquote>
 */
class ConstantVisitor extends UnifyingAstVisitor<EvaluationResultImpl> {
  /**
   * The type provider used to access the known types.
   */
  TypeProvider _typeProvider;

  /**
   * An shared object representing the value 'null'.
   */
  DartObjectImpl _nullObject;

  /**
   * Initialize a newly created constant visitor.
   *
   * @param typeProvider the type provider used to access known types
   */
  ConstantVisitor(TypeProvider typeProvider) {
    this._typeProvider = typeProvider;
  }

  EvaluationResultImpl visitAdjacentStrings(AdjacentStrings node) {
    EvaluationResultImpl result = null;
    for (StringLiteral string in node.strings) {
      if (result == null) {
        result = string.accept(this);
      } else {
        result = result.concatenate(_typeProvider, node, string.accept(this));
      }
    }
    return result;
  }

  EvaluationResultImpl visitBinaryExpression(BinaryExpression node) {
    EvaluationResultImpl leftResult = node.leftOperand.accept(this);
    EvaluationResultImpl rightResult = node.rightOperand.accept(this);
    TokenType operatorType = node.operator.type;
    // 'null' is almost never good operand
    if (operatorType != TokenType.BANG_EQ && operatorType != TokenType.EQ_EQ) {
      if (leftResult is ValidResult && leftResult.isNull || rightResult is ValidResult && rightResult.isNull) {
        return error(node, CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
      }
    }
    // evaluate operator
    while (true) {
      if (operatorType == TokenType.AMPERSAND) {
        return leftResult.bitAnd(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.AMPERSAND_AMPERSAND) {
        return leftResult.logicalAnd(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.BANG_EQ) {
        return leftResult.notEqual(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.BAR) {
        return leftResult.bitOr(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.BAR_BAR) {
        return leftResult.logicalOr(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.CARET) {
        return leftResult.bitXor(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.EQ_EQ) {
        return leftResult.equalEqual(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.GT) {
        return leftResult.greaterThan(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.GT_EQ) {
        return leftResult.greaterThanOrEqual(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.GT_GT) {
        return leftResult.shiftRight(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.LT) {
        return leftResult.lessThan(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.LT_EQ) {
        return leftResult.lessThanOrEqual(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.LT_LT) {
        return leftResult.shiftLeft(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.MINUS) {
        return leftResult.minus(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.PERCENT) {
        return leftResult.remainder(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.PLUS) {
        return leftResult.add(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.STAR) {
        return leftResult.times(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.SLASH) {
        return leftResult.divide(_typeProvider, node, rightResult);
      } else if (operatorType == TokenType.TILDE_SLASH) {
        return leftResult.integerDivide(_typeProvider, node, rightResult);
      } else {
        // TODO(brianwilkerson) Figure out which error to report.
        return error(node, null);
      }
      break;
    }
  }

  EvaluationResultImpl visitBooleanLiteral(BooleanLiteral node) => valid(_typeProvider.boolType, BoolState.from(node.value));

  EvaluationResultImpl visitConditionalExpression(ConditionalExpression node) {
    Expression condition = node.condition;
    EvaluationResultImpl conditionResult = condition.accept(this);
    EvaluationResultImpl thenResult = node.thenExpression.accept(this);
    EvaluationResultImpl elseResult = node.elseExpression.accept(this);
    if (conditionResult is ErrorResult) {
      return union(union(conditionResult as ErrorResult, thenResult), elseResult);
    } else if (!(conditionResult as ValidResult).isBool) {
      return new ErrorResult.con1(condition, CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL);
    } else if (thenResult is ErrorResult) {
      return union(thenResult, elseResult);
    } else if (elseResult is ErrorResult) {
      return elseResult;
    }
    conditionResult = conditionResult.applyBooleanConversion(_typeProvider, condition);
    if (conditionResult is ErrorResult) {
      return conditionResult;
    }
    ValidResult validResult = conditionResult as ValidResult;
    if (validResult.isTrue) {
      return thenResult;
    } else if (validResult.isFalse) {
      return elseResult;
    }
    InterfaceType thenType = (thenResult as ValidResult).value.type;
    InterfaceType elseType = (elseResult as ValidResult).value.type;
    return validWithUnknownValue(thenType.getLeastUpperBound(elseType) as InterfaceType);
  }

  EvaluationResultImpl visitDoubleLiteral(DoubleLiteral node) => valid(_typeProvider.doubleType, new DoubleState(node.value));

  EvaluationResultImpl visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!node.isConst) {
      // TODO(brianwilkerson) Figure out which error to report.
      return error(node, null);
    }
    ConstructorElement constructor = node.staticElement;
    if (constructor != null && constructor.isConst) {
      NodeList<Expression> arguments = node.argumentList.arguments;
      int argumentCount = arguments.length;
      List<DartObjectImpl> argumentValues = new List<DartObjectImpl>(argumentCount);
      Map<String, DartObjectImpl> namedArgumentValues = new Map<String, DartObjectImpl>();
      for (int i = 0; i < argumentCount; i++) {
        Expression argument = arguments[i];
        if (argument is NamedExpression) {
          NamedExpression namedExpression = argument;
          String name = namedExpression.name.label.name;
          namedArgumentValues[name] = valueOf(namedExpression.expression);
          argumentValues[i] = null2;
        } else {
          argumentValues[i] = valueOf(argument);
        }
      }
      InterfaceType definingClass = constructor.returnType as InterfaceType;
      if (definingClass.element.library.isDartCore) {
        String className = definingClass.name;
        if (className == "Symbol" && argumentCount == 1) {
          String argumentValue = argumentValues[0].stringValue;
          if (argumentValue != null) {
            return valid(definingClass, new SymbolState(argumentValue));
          }
        }
      }
      Map<String, DartObjectImpl> fieldMap = new Map<String, DartObjectImpl>();
      List<ParameterElement> parameters = constructor.parameters;
      int parameterCount = parameters.length;
      for (int i = 0; i < parameterCount; i++) {
        ParameterElement parameter = parameters[i];
        if (parameter.isInitializingFormal) {
          String fieldName = (parameter as FieldFormalParameterElement).field.name;
          if (identical(parameter.parameterKind, ParameterKind.NAMED)) {
            DartObjectImpl argumentValue = namedArgumentValues[parameter.name];
            if (argumentValue != null) {
              fieldMap[fieldName] = argumentValue;
            }
          } else if (i < argumentCount) {
            fieldMap[fieldName] = argumentValues[i];
          }
        }
      }
      // TODO(brianwilkerson) This doesn't handle fields initialized in an initializer. We should be
      // able to handle fields initialized by the superclass' constructor fairly easily, but other
      // initializers will be harder.
      return valid(definingClass, new GenericState(fieldMap));
    }
    // TODO(brianwilkerson) Figure out which error to report.
    return error(node, null);
  }

  EvaluationResultImpl visitIntegerLiteral(IntegerLiteral node) => valid(_typeProvider.intType, new IntState(node.value));

  EvaluationResultImpl visitInterpolationExpression(InterpolationExpression node) {
    EvaluationResultImpl result = node.expression.accept(this);
    if (result is ValidResult && !result.isBoolNumStringOrNull) {
      return error(node, CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL_NUM_STRING);
    }
    return result.performToString(_typeProvider, node);
  }

  EvaluationResultImpl visitInterpolationString(InterpolationString node) => valid(_typeProvider.stringType, new StringState(node.value));

  EvaluationResultImpl visitListLiteral(ListLiteral node) {
    if (node.constKeyword == null) {
      return new ErrorResult.con1(node, CompileTimeErrorCode.MISSING_CONST_IN_LIST_LITERAL);
    }
    ErrorResult result = null;
    List<DartObjectImpl> elements = new List<DartObjectImpl>();
    for (Expression element in node.elements) {
      EvaluationResultImpl elementResult = element.accept(this);
      result = union(result, elementResult);
      if (elementResult is ValidResult) {
        elements.add(elementResult.value);
      }
    }
    if (result != null) {
      return result;
    }
    return valid(_typeProvider.listType, new ListState(new List.from(elements)));
  }

  EvaluationResultImpl visitMapLiteral(MapLiteral node) {
    if (node.constKeyword == null) {
      return new ErrorResult.con1(node, CompileTimeErrorCode.MISSING_CONST_IN_MAP_LITERAL);
    }
    ErrorResult result = null;
    Map<DartObjectImpl, DartObjectImpl> map = new Map<DartObjectImpl, DartObjectImpl>();
    for (MapLiteralEntry entry in node.entries) {
      EvaluationResultImpl keyResult = entry.key.accept(this);
      EvaluationResultImpl valueResult = entry.value.accept(this);
      result = union(result, keyResult);
      result = union(result, valueResult);
      if (keyResult is ValidResult && valueResult is ValidResult) {
        map[keyResult.value] = valueResult.value;
      }
    }
    if (result != null) {
      return result;
    }
    return valid(_typeProvider.mapType, new MapState(map));
  }

  EvaluationResultImpl visitMethodInvocation(MethodInvocation node) {
    Element element = node.methodName.staticElement;
    if (element is FunctionElement) {
      FunctionElement function = element;
      if (function.name == "identical") {
        NodeList<Expression> arguments = node.argumentList.arguments;
        if (arguments.length == 2) {
          Element enclosingElement = function.enclosingElement;
          if (enclosingElement is CompilationUnitElement) {
            LibraryElement library = enclosingElement.library;
            if (library.isDartCore) {
              EvaluationResultImpl leftArgument = arguments[0].accept(this);
              EvaluationResultImpl rightArgument = arguments[1].accept(this);
              return leftArgument.equalEqual(_typeProvider, node, rightArgument);
            }
          }
        }
      }
    }
    // TODO(brianwilkerson) Figure out which error to report.
    return error(node, null);
  }

  EvaluationResultImpl visitNamedExpression(NamedExpression node) => node.expression.accept(this);

  EvaluationResultImpl visitNode(AstNode node) => error(node, null);

  EvaluationResultImpl visitNullLiteral(NullLiteral node) => new ValidResult(null2);

  EvaluationResultImpl visitParenthesizedExpression(ParenthesizedExpression node) => node.expression.accept(this);

  EvaluationResultImpl visitPrefixedIdentifier(PrefixedIdentifier node) {
    // validate prefix
    SimpleIdentifier prefixNode = node.prefix;
    Element prefixElement = prefixNode.staticElement;
    if (prefixElement is! PrefixElement) {
      EvaluationResultImpl prefixResult = prefixNode.accept(this);
      if (prefixResult is! ValidResult) {
        return error(node, null);
      }
    }
    // validate prefixed identifier
    return getConstantValue(node, node.staticElement);
  }

  EvaluationResultImpl visitPrefixExpression(PrefixExpression node) {
    EvaluationResultImpl operand = node.operand.accept(this);
    if (operand is ValidResult && operand.isNull) {
      return error(node, CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
    }
    while (true) {
      if (node.operator.type == TokenType.BANG) {
        return operand.logicalNot(_typeProvider, node);
      } else if (node.operator.type == TokenType.TILDE) {
        return operand.bitNot(_typeProvider, node);
      } else if (node.operator.type == TokenType.MINUS) {
        return operand.negated(_typeProvider, node);
      } else {
        // TODO(brianwilkerson) Figure out which error to report.
        return error(node, null);
      }
      break;
    }
  }

  EvaluationResultImpl visitPropertyAccess(PropertyAccess node) => getConstantValue(node, node.propertyName.staticElement);

  EvaluationResultImpl visitSimpleIdentifier(SimpleIdentifier node) => getConstantValue(node, node.staticElement);

  EvaluationResultImpl visitSimpleStringLiteral(SimpleStringLiteral node) => valid(_typeProvider.stringType, new StringState(node.value));

  EvaluationResultImpl visitStringInterpolation(StringInterpolation node) {
    EvaluationResultImpl result = null;
    for (InterpolationElement element in node.elements) {
      if (result == null) {
        result = element.accept(this);
      } else {
        result = result.concatenate(_typeProvider, node, element.accept(this));
      }
    }
    return result;
  }

  EvaluationResultImpl visitSymbolLiteral(SymbolLiteral node) {
    JavaStringBuilder builder = new JavaStringBuilder();
    List<Token> components = node.components;
    for (int i = 0; i < components.length; i++) {
      if (i > 0) {
        builder.appendChar(0x2E);
      }
      builder.append(components[i].lexeme);
    }
    return valid(_typeProvider.symbolType, new SymbolState(builder.toString()));
  }

  /**
   * Return a result object representing an error associated with the given node.
   *
   * @param node the AST node associated with the error
   * @param code the error code indicating the nature of the error
   * @return a result object representing an error associated with the given node
   */
  ErrorResult error(AstNode node, ErrorCode code) => new ErrorResult.con1(node, code == null ? CompileTimeErrorCode.INVALID_CONSTANT : code);

  /**
   * Return the constant value of the static constant represented by the given element.
   *
   * @param node the node to be used if an error needs to be reported
   * @param element the element whose value is to be returned
   * @return the constant value of the static constant
   */
  EvaluationResultImpl getConstantValue(AstNode node, Element element) {
    if (element is PropertyAccessorElement) {
      element = (element as PropertyAccessorElement).variable;
    }
    if (element is VariableElementImpl) {
      VariableElementImpl variableElementImpl = element;
      EvaluationResultImpl value = variableElementImpl.evaluationResult;
      if (variableElementImpl.isConst && value != null) {
        return value;
      }
    } else if (element is ExecutableElement) {
      ExecutableElement function = element;
      if (function.isStatic) {
        return valid(_typeProvider.functionType, new FunctionState(function));
      }
    } else if (element is ClassElement || element is FunctionTypeAliasElement) {
      return valid(_typeProvider.typeType, new TypeState(element));
    }
    // TODO(brianwilkerson) Figure out which error to report.
    return error(node, null);
  }

  /**
   * Return an object representing the value 'null'.
   *
   * @return an object representing the value 'null'
   */
  DartObjectImpl get null2 {
    if (_nullObject == null) {
      _nullObject = new DartObjectImpl(_typeProvider.nullType, NullState.NULL_STATE);
    }
    return _nullObject;
  }

  /**
   * Return the union of the errors encoded in the given results.
   *
   * @param leftResult the first set of errors, or `null` if there was no previous collection
   *          of errors
   * @param rightResult the errors to be added to the collection, or a valid result if there are no
   *          errors to be added
   * @return the union of the errors encoded in the given results
   */
  ErrorResult union(ErrorResult leftResult, EvaluationResultImpl rightResult) {
    if (rightResult is ErrorResult) {
      if (leftResult != null) {
        return new ErrorResult.con2(leftResult, rightResult);
      } else {
        return rightResult;
      }
    }
    return leftResult;
  }

  ValidResult valid(InterfaceType type, InstanceState state) => new ValidResult(new DartObjectImpl(type, state));

  ValidResult validWithUnknownValue(InterfaceType type) {
    if (type.element.library.isDartCore) {
      String typeName = type.name;
      if (typeName == "bool") {
        return valid(type, BoolState.UNKNOWN_VALUE);
      } else if (typeName == "double") {
        return valid(type, DoubleState.UNKNOWN_VALUE);
      } else if (typeName == "int") {
        return valid(type, IntState.UNKNOWN_VALUE);
      } else if (typeName == "String") {
        return valid(type, StringState.UNKNOWN_VALUE);
      }
    }
    return valid(type, GenericState.UNKNOWN_VALUE);
  }

  /**
   * Return the value of the given expression, or a representation of 'null' if the expression
   * cannot be evaluated.
   *
   * @param expression the expression whose value is to be returned
   * @return the value of the given expression
   */
  DartObjectImpl valueOf(Expression expression) {
    EvaluationResultImpl expressionValue = expression.accept(this);
    if (expressionValue is ValidResult) {
      return expressionValue.value;
    }
    return null2;
  }
}

/**
 * Instances of the class `DirectedGraph` implement a directed graph in which the nodes are
 * arbitrary (client provided) objects and edges are represented implicitly. The graph will allow an
 * edge from any node to any other node, including itself, but will not represent multiple edges
 * between the same pair of nodes.
 *
 * @param N the type of the nodes in the graph
 */
class DirectedGraph<N> {
  /**
   * The table encoding the edges in the graph. An edge is represented by an entry mapping the head
   * to a set of tails. Nodes that are not the head of any edge are represented by an entry mapping
   * the node to an empty set of tails.
   */
  Map<N, Set<N>> _edges = new Map<N, Set<N>>();

  /**
   * Add an edge from the given head node to the given tail node. Both nodes will be a part of the
   * graph after this method is invoked, whether or not they were before.
   *
   * @param head the node at the head of the edge
   * @param tail the node at the tail of the edge
   */
  void addEdge(N head, N tail) {
    //
    // First, ensure that the tail is a node known to the graph.
    //
    Set<N> tails = _edges[tail];
    if (tails == null) {
      _edges[tail] = new Set<N>();
    }
    //
    // Then create the edge.
    //
    tails = _edges[head];
    if (tails == null) {
      tails = new Set<N>();
      _edges[head] = tails;
    }
    tails.add(tail);
  }

  /**
   * Add the given node to the set of nodes in the graph.
   *
   * @param node the node to be added
   */
  void addNode(N node) {
    Set<N> tails = _edges[node];
    if (tails == null) {
      _edges[node] = new Set<N>();
    }
  }

  /**
   * Return a list of nodes that form a cycle, or `null` if there are no cycles in this graph.
   *
   * @return a list of nodes that form a cycle
   */
  List<N> findCycle() => null;

  /**
   * Return the number of nodes in this graph.
   *
   * @return the number of nodes in this graph
   */
  int get nodeCount => _edges.length;

  /**
   * Return a set containing the tails of edges that have the given node as their head. The set will
   * be empty if there are no such edges or if the node is not part of the graph. Clients must not
   * modify the returned set.
   *
   * @param head the node at the head of all of the edges whose tails are to be returned
   * @return a set containing the tails of edges that have the given node as their head
   */
  Set<N> getTails(N head) {
    Set<N> tails = _edges[head];
    if (tails == null) {
      return new Set<N>();
    }
    return tails;
  }

  /**
   * Return `true` if this graph is empty.
   *
   * @return `true` if this graph is empty
   */
  bool get isEmpty => _edges.isEmpty;

  /**
   * Remove all of the given nodes from this graph. As a consequence, any edges for which those
   * nodes were either a head or a tail will also be removed.
   *
   * @param nodes the nodes to be removed
   */
  void removeAllNodes(List<N> nodes) {
    for (N node in nodes) {
      removeNode(node);
    }
  }

  /**
   * Remove the edge from the given head node to the given tail node. If there was no such edge then
   * the graph will be unmodified: the number of edges will be the same and the set of nodes will be
   * the same (neither node will either be added or removed).
   *
   * @param head the node at the head of the edge
   * @param tail the node at the tail of the edge
   * @return `true` if the graph was modified as a result of this operation
   */
  void removeEdge(N head, N tail) {
    Set<N> tails = _edges[head];
    if (tails != null) {
      tails.remove(tail);
    }
  }

  /**
   * Remove the given node from this graph. As a consequence, any edges for which that node was
   * either a head or a tail will also be removed.
   *
   * @param node the node to be removed
   */
  void removeNode(N node) {
    _edges.remove(node);
    for (Set<N> tails in _edges.values) {
      tails.remove(node);
    }
  }

  /**
   * Find one node (referred to as a sink node) that has no outgoing edges (that is, for which there
   * are no edges that have that node as the head of the edge) and remove it from this graph. Return
   * the node that was removed, or `null` if there are no such nodes either because the graph
   * is empty or because every node in the graph has at least one outgoing edge. As a consequence of
   * removing the node from the graph any edges for which that node was a tail will also be removed.
   *
   * @return the sink node that was removed
   */
  N removeSink() {
    N sink = findSink();
    if (sink == null) {
      return null;
    }
    removeNode(sink);
    return sink;
  }

  /**
   * Return one node that has no outgoing edges (that is, for which there are no edges that have
   * that node as the head of the edge), or `null` if there are no such nodes.
   *
   * @return a sink node
   */
  N findSink() {
    for (N key in _edges.keys) {
      if (_edges[key].isEmpty) return key;
    }
    return null;
  }
}

/**
 * Instances of the class `ErrorResult` represent the result of evaluating an expression that
 * is not a valid compile time constant.
 */
class ErrorResult extends EvaluationResultImpl {
  /**
   * The errors that prevent the expression from being a valid compile time constant.
   */
  List<ErrorResult_ErrorData> _errors = new List<ErrorResult_ErrorData>();

  /**
   * Initialize a newly created result representing the error with the given code reported against
   * the given node.
   *
   * @param node the node against which the error should be reported
   * @param errorCode the error code for the error to be generated
   */
  ErrorResult.con1(AstNode node, ErrorCode errorCode) {
    _errors.add(new ErrorResult_ErrorData(node, errorCode));
  }

  /**
   * Initialize a newly created result to represent the union of the errors in the given result
   * objects.
   *
   * @param firstResult the first set of results being merged
   * @param secondResult the second set of results being merged
   */
  ErrorResult.con2(ErrorResult firstResult, ErrorResult secondResult) {
    _errors.addAll(firstResult._errors);
    _errors.addAll(secondResult._errors);
  }

  EvaluationResultImpl add(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.addToError(node, this);

  EvaluationResultImpl applyBooleanConversion(TypeProvider typeProvider, AstNode node) => this;

  EvaluationResultImpl bitAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitAndError(node, this);

  EvaluationResultImpl bitNot(TypeProvider typeProvider, Expression node) => this;

  EvaluationResultImpl bitOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitOrError(node, this);

  EvaluationResultImpl bitXor(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitXorError(node, this);

  EvaluationResultImpl concatenate(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand) => rightOperand.concatenateError(node, this);

  EvaluationResultImpl divide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.divideError(node, this);

  EvaluationResultImpl equalEqual(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand) => rightOperand.equalEqualError(node, this);

  bool equalValues(TypeProvider typeProvider, EvaluationResultImpl result) => false;

  List<ErrorResult_ErrorData> get errorData => _errors;

  EvaluationResultImpl greaterThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.greaterThanError(node, this);

  EvaluationResultImpl greaterThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.greaterThanOrEqualError(node, this);

  EvaluationResultImpl integerDivide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.integerDivideError(node, this);

  EvaluationResultImpl integerDivideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl lessThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.lessThanError(node, this);

  EvaluationResultImpl lessThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.lessThanOrEqualError(node, this);

  EvaluationResultImpl logicalAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.logicalAndError(node, this);

  EvaluationResultImpl logicalNot(TypeProvider typeProvider, Expression node) => this;

  EvaluationResultImpl logicalOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.logicalOrError(node, this);

  EvaluationResultImpl minus(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.minusError(node, this);

  EvaluationResultImpl negated(TypeProvider typeProvider, Expression node) => this;

  EvaluationResultImpl notEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.notEqualError(node, this);

  EvaluationResultImpl performToString(TypeProvider typeProvider, AstNode node) => this;

  EvaluationResultImpl remainder(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.remainderError(node, this);

  EvaluationResultImpl shiftLeft(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.shiftLeftError(node, this);

  EvaluationResultImpl shiftRight(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.shiftRightError(node, this);

  EvaluationResultImpl times(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.timesError(node, this);

  EvaluationResultImpl addToError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl addToValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl bitAndError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl bitAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl bitOrError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl bitOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl bitXorError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl bitXorValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl concatenateError(Expression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl concatenateValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand) => this;

  EvaluationResultImpl divideError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl divideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl equalEqualError(Expression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl equalEqualValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand) => this;

  EvaluationResultImpl greaterThanError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl greaterThanOrEqualError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl greaterThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl greaterThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl integerDivideError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl lessThanError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl lessThanOrEqualError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl lessThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl lessThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl logicalAndError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl logicalAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl logicalOrError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl logicalOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl minusError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl minusValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl notEqualError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl notEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl remainderError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl remainderValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl shiftLeftError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl shiftLeftValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl shiftRightError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl shiftRightValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;

  EvaluationResultImpl timesError(BinaryExpression node, ErrorResult leftOperand) => new ErrorResult.con2(this, leftOperand);

  EvaluationResultImpl timesValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) => this;
}

class ErrorResult_ErrorData {
  /**
   * The node against which the error should be reported.
   */
  final AstNode node;

  /**
   * The error code for the error to be generated.
   */
  final ErrorCode errorCode;

  /**
   * Initialize a newly created data holder to represent the error with the given code reported
   * against the given node.
   *
   * @param node the node against which the error should be reported
   * @param errorCode the error code for the error to be generated
   */
  ErrorResult_ErrorData(this.node, this.errorCode);
}

/**
 * Instances of the class `InternalResult` represent the result of attempting to evaluate a
 * expression.
 */
abstract class EvaluationResultImpl {
  EvaluationResultImpl add(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  /**
   * Return the result of applying boolean conversion to this result.
   *
   * @param typeProvider the type provider used to access known types
   * @param node the node against which errors should be reported
   * @return the result of applying boolean conversion to the given value
   */
  EvaluationResultImpl applyBooleanConversion(TypeProvider typeProvider, AstNode node);

  EvaluationResultImpl bitAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl bitNot(TypeProvider typeProvider, Expression node);

  EvaluationResultImpl bitOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl bitXor(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl concatenate(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl divide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl equalEqual(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand);

  bool equalValues(TypeProvider typeProvider, EvaluationResultImpl result);

  EvaluationResultImpl greaterThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl greaterThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl integerDivide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl lessThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl lessThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl logicalAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl logicalNot(TypeProvider typeProvider, Expression node);

  EvaluationResultImpl logicalOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl minus(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl negated(TypeProvider typeProvider, Expression node);

  EvaluationResultImpl notEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl performToString(TypeProvider typeProvider, AstNode node);

  EvaluationResultImpl remainder(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl shiftLeft(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl shiftRight(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl times(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand);

  EvaluationResultImpl addToError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl addToValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl bitAndError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl bitAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl bitOrError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl bitOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl bitXorError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl bitXorValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl concatenateError(Expression node, ErrorResult leftOperand);

  EvaluationResultImpl concatenateValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand);

  EvaluationResultImpl divideError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl divideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl equalEqualError(Expression node, ErrorResult leftOperand);

  EvaluationResultImpl equalEqualValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand);

  EvaluationResultImpl greaterThanError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl greaterThanOrEqualError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl greaterThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl greaterThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl integerDivideError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl integerDivideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl lessThanError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl lessThanOrEqualError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl lessThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl lessThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl logicalAndError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl logicalAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl logicalOrError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl logicalOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl minusError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl minusValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl notEqualError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl notEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl remainderError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl remainderValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl shiftLeftError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl shiftLeftValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl shiftRightError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl shiftRightValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);

  EvaluationResultImpl timesError(BinaryExpression node, ErrorResult leftOperand);

  EvaluationResultImpl timesValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand);
}

/**
 * Instances of the class `ReferenceFinder` add reference information for a given variable to
 * the bi-directional mapping used to order the evaluation of constants.
 */
class ReferenceFinder extends RecursiveAstVisitor<Object> {
  /**
   * The element representing the variable whose initializer will be visited.
   */
  VariableElement _source;

  /**
   * A graph in which the nodes are the constant variables and the edges are from each variable to
   * the other constant variables that are referenced in the head's initializer.
   */
  DirectedGraph<VariableElement> _referenceGraph;

  /**
   * Initialize a newly created reference finder to find references from the given variable to other
   * variables and to add those references to the given graph.
   *
   * @param source the element representing the variable whose initializer will be visited
   * @param referenceGraph a graph recording which variables (heads) reference which other variables
   *          (tails) in their initializers
   */
  ReferenceFinder(VariableElement source, DirectedGraph<VariableElement> referenceGraph) {
    this._source = source;
    this._referenceGraph = referenceGraph;
  }

  Object visitSimpleIdentifier(SimpleIdentifier node) {
    Element element = node.staticElement;
    if (element is PropertyAccessorElement) {
      element = (element as PropertyAccessorElement).variable;
    }
    if (element is VariableElement) {
      VariableElement variable = element as VariableElement;
      if (variable.isConst) {
        _referenceGraph.addEdge(_source, variable);
      }
    }
    return null;
  }
}

/**
 * Instances of the class `ValidResult` represent the result of attempting to evaluate a valid
 * compile time constant expression.
 */
class ValidResult extends EvaluationResultImpl {
  /**
   * The value of the expression.
   */
  final DartObjectImpl value;

  /**
   * Initialize a newly created result to represent the given value.
   *
   * @param value the value of the expression
   */
  ValidResult(this.value);

  EvaluationResultImpl add(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.addToValid(typeProvider, node, this);

  /**
   * Return the result of applying boolean conversion to this result.
   *
   * @param node the node against which errors should be reported
   * @return the result of applying boolean conversion to the given value
   */
  EvaluationResultImpl applyBooleanConversion(TypeProvider typeProvider, AstNode node) {
    try {
      return valueOf(value.convertToBool(typeProvider));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl bitAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitAndValid(typeProvider, node, this);

  EvaluationResultImpl bitNot(TypeProvider typeProvider, Expression node) {
    try {
      return valueOf(value.bitNot(typeProvider));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl bitOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitOrValid(typeProvider, node, this);

  EvaluationResultImpl bitXor(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.bitXorValid(typeProvider, node, this);

  EvaluationResultImpl concatenate(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand) => rightOperand.concatenateValid(typeProvider, node, this);

  EvaluationResultImpl divide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.divideValid(typeProvider, node, this);

  EvaluationResultImpl equalEqual(TypeProvider typeProvider, Expression node, EvaluationResultImpl rightOperand) => rightOperand.equalEqualValid(typeProvider, node, this);

  bool equalValues(TypeProvider typeProvider, EvaluationResultImpl result) {
    if (result is! ValidResult) {
      return false;
    }
    return value == (result as ValidResult).value;
  }

  EvaluationResultImpl greaterThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.greaterThanValid(typeProvider, node, this);

  EvaluationResultImpl greaterThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.greaterThanOrEqualValid(typeProvider, node, this);

  EvaluationResultImpl integerDivide(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.integerDivideValid(typeProvider, node, this);

  /**
   * Return `true` if this object represents an object whose type is 'bool'.
   *
   * @return `true` if this object represents a boolean value
   */
  bool get isBool => value.isBool;

  /**
   * Return `true` if this object represents an object whose type is either 'bool', 'num',
   * 'String', or 'Null'.
   *
   * @return `true` if this object represents either a boolean, numeric, string or null value
   */
  bool get isBoolNumStringOrNull => value.isBoolNumStringOrNull;

  /**
   * Return `true` if this result represents the value 'false'.
   *
   * @return `true` if this result represents the value 'false'
   */
  bool get isFalse => value.isFalse;

  /**
   * Return `true` if this result represents the value 'null'.
   *
   * @return `true` if this result represents the value 'null'
   */
  bool get isNull => value.isNull;

  /**
   * Return `true` if this result represents the value 'true'.
   *
   * @return `true` if this result represents the value 'true'
   */
  bool get isTrue => value.isTrue;

  /**
   * Return `true` if this object represents an instance of a user-defined class.
   *
   * @return `true` if this object represents an instance of a user-defined class
   */
  bool get isUserDefinedObject => value.isUserDefinedObject;

  EvaluationResultImpl lessThan(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.lessThanValid(typeProvider, node, this);

  EvaluationResultImpl lessThanOrEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.lessThanOrEqualValid(typeProvider, node, this);

  EvaluationResultImpl logicalAnd(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.logicalAndValid(typeProvider, node, this);

  EvaluationResultImpl logicalNot(TypeProvider typeProvider, Expression node) {
    try {
      return valueOf(value.logicalNot(typeProvider));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl logicalOr(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.logicalOrValid(typeProvider, node, this);

  EvaluationResultImpl minus(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.minusValid(typeProvider, node, this);

  EvaluationResultImpl negated(TypeProvider typeProvider, Expression node) {
    try {
      return valueOf(value.negated(typeProvider));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl notEqual(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.notEqualValid(typeProvider, node, this);

  EvaluationResultImpl performToString(TypeProvider typeProvider, AstNode node) {
    try {
      return valueOf(value.performToString(typeProvider));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl remainder(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.remainderValid(typeProvider, node, this);

  EvaluationResultImpl shiftLeft(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.shiftLeftValid(typeProvider, node, this);

  EvaluationResultImpl shiftRight(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.shiftRightValid(typeProvider, node, this);

  EvaluationResultImpl times(TypeProvider typeProvider, BinaryExpression node, EvaluationResultImpl rightOperand) => rightOperand.timesValid(typeProvider, node, this);

  String toString() {
    if (value == null) {
      return "null";
    }
    return value.toString();
  }

  EvaluationResultImpl addToError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl addToValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.add(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl bitAndError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl bitAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.bitAnd(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl bitOrError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl bitOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.bitOr(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl bitXorError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl bitXorValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.bitXor(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl concatenateError(Expression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl concatenateValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.concatenate(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl divideError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl divideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.divide(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl equalEqualError(Expression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl equalEqualValid(TypeProvider typeProvider, Expression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.equalEqual(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl greaterThanError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl greaterThanOrEqualError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl greaterThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.greaterThanOrEqual(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl greaterThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.greaterThan(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl integerDivideError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl integerDivideValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.integerDivide(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl lessThanError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl lessThanOrEqualError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl lessThanOrEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.lessThanOrEqual(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl lessThanValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.lessThan(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl logicalAndError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl logicalAndValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.logicalAnd(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl logicalOrError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl logicalOrValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.logicalOr(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl minusError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl minusValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.minus(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl notEqualError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl notEqualValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.notEqual(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl remainderError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl remainderValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.remainder(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl shiftLeftError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl shiftLeftValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.shiftLeft(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl shiftRightError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl shiftRightValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.shiftRight(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  EvaluationResultImpl timesError(BinaryExpression node, ErrorResult leftOperand) => leftOperand;

  EvaluationResultImpl timesValid(TypeProvider typeProvider, BinaryExpression node, ValidResult leftOperand) {
    try {
      return valueOf(leftOperand.value.times(typeProvider, value));
    } on EvaluationException catch (exception) {
      return error(node, exception.errorCode);
    }
  }

  /**
   * Return a result object representing an error associated with the given node.
   *
   * @param node the AST node associated with the error
   * @param code the error code indicating the nature of the error
   * @return a result object representing an error associated with the given node
   */
  ErrorResult error(AstNode node, ErrorCode code) => new ErrorResult.con1(node, code);

  /**
   * Return a result object representing the given value.
   *
   * @param value the value to be represented as a result object
   * @return a result object representing the given value
   */
  ValidResult valueOf(DartObjectImpl value) => new ValidResult(value);
}

/**
 * Instances of the class `BoolState` represent the state of an object representing a boolean
 * value.
 */
class BoolState extends InstanceState {
  /**
   * The value of this instance.
   */
  final bool value;

  /**
   * An instance representing the boolean value 'false'.
   */
  static BoolState FALSE_STATE = new BoolState(false);

  /**
   * An instance representing the boolean value 'true'.
   */
  static BoolState TRUE_STATE = new BoolState(true);

  /**
   * A state that can be used to represent a boolean whose value is not known.
   */
  static BoolState UNKNOWN_VALUE = new BoolState(null);

  /**
   * Return the boolean state representing the given boolean value.
   *
   * @param value the value to be represented
   * @return the boolean state representing the given boolean value
   */
  static BoolState from(bool value) => value ? BoolState.TRUE_STATE : BoolState.FALSE_STATE;

  /**
   * Initialize a newly created state to represent the given value.
   *
   * @param value the value of this instance
   */
  BoolState(this.value);

  BoolState convertToBool() => this;

  StringState convertToString() {
    if (value == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(value ? "true" : "false");
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is BoolState) {
      bool rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return BoolState.from(identical(value, rightValue));
    } else if (rightOperand is DynamicState) {
      return UNKNOWN_VALUE;
    }
    return FALSE_STATE;
  }

  bool operator ==(Object object) => object is BoolState && identical(value, object.value);

  String get typeName => "bool";

  bool hasExactValue() => true;

  int get hashCode => value == null ? 0 : (value ? 2 : 3);

  /**
   * Return `true` if this object represents an object whose type is 'bool'.
   *
   * @return `true` if this object represents a boolean value
   */
  bool get isBool => true;

  bool get isBoolNumStringOrNull => true;

  BoolState logicalAnd(InstanceState rightOperand) {
    assertBool(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return value ? rightOperand.convertToBool() : FALSE_STATE;
  }

  BoolState logicalNot() {
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return value ? FALSE_STATE : TRUE_STATE;
  }

  BoolState logicalOr(InstanceState rightOperand) {
    assertBool(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return value ? TRUE_STATE : rightOperand.convertToBool();
  }

  String toString() => value == null ? "-unknown-" : (value ? "true" : "false");
}

/**
 * Instances of the class `DartObjectImpl` represent an instance of a Dart class.
 */
class DartObjectImpl implements DartObject {
  /**
   * The run-time type of this object.
   */
  final InterfaceType type;

  /**
   * The state of the object.
   */
  InstanceState _state;

  /**
   * Initialize a newly created object to have the given type and state.
   *
   * @param type the run-time type of this object
   * @param state the state of the object
   */
  DartObjectImpl(this.type, InstanceState state) {
    this._state = state;
  }

  /**
   * Return the result of invoking the '+' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '+' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl add(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    InstanceState result = _state.add(rightOperand._state);
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("add returned a ${result.runtimeType.toString()}");
  }

  /**
   * Return the result of invoking the '&' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl bitAnd(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.bitAnd(rightOperand._state));

  /**
   * Return the result of invoking the '~' operator on this object.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of invoking the '~' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl bitNot(TypeProvider typeProvider) => new DartObjectImpl(typeProvider.intType, _state.bitNot());

  /**
   * Return the result of invoking the '|' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '|' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl bitOr(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.bitOr(rightOperand._state));

  /**
   * Return the result of invoking the '^' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '^' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl bitXor(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.bitXor(rightOperand._state));

  /**
   * Return the result of invoking the ' ' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the ' ' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl concatenate(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.stringType, _state.concatenate(rightOperand._state));

  /**
   * Return the result of applying boolean conversion to this object.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of applying boolean conversion to this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl convertToBool(TypeProvider typeProvider) {
    InterfaceType boolType = typeProvider.boolType;
    if (identical(type, boolType)) {
      return this;
    }
    return new DartObjectImpl(boolType, _state.convertToBool());
  }

  /**
   * Return the result of invoking the '/' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '/' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl divide(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    InstanceState result = _state.divide(rightOperand._state);
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("divide returned a ${result.runtimeType.toString()}");
  }

  /**
   * Return the result of invoking the '==' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '==' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl equalEqual(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    if (type != rightOperand.type) {
      String typeName = type.name;
      if (!(typeName == "bool" || typeName == "double" || typeName == "int" || typeName == "num" || typeName == "String" || typeName == "Null" || type.isDynamic)) {
        throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL_NUM_STRING);
      }
    }
    return new DartObjectImpl(typeProvider.boolType, _state.equalEqual(rightOperand._state));
  }

  bool operator ==(Object object) {
    if (object is! DartObjectImpl) {
      return false;
    }
    DartObjectImpl dartObject = object as DartObjectImpl;
    return type == dartObject.type && _state == dartObject._state;
  }

  bool get boolValue {
    if (_state is BoolState) {
      return (_state as BoolState).value;
    }
    return null;
  }

  double get doubleValue {
    if (_state is DoubleState) {
      return (_state as DoubleState).value;
    }
    return null;
  }

  int get intValue {
    if (_state is IntState) {
      return (_state as IntState).value;
    }
    return null;
  }

  String get stringValue {
    if (_state is StringState) {
      return (_state as StringState).value;
    }
    return null;
  }

  Object get value => _state.value;

  /**
   * Return the result of invoking the '&gt;' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl greaterThan(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.greaterThan(rightOperand._state));

  /**
   * Return the result of invoking the '&gt;=' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;=' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl greaterThanOrEqual(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.greaterThanOrEqual(rightOperand._state));

  bool hasExactValue() => _state.hasExactValue();

  int get hashCode => ObjectUtilities.combineHashCodes(type.hashCode, _state.hashCode);

  /**
   * Return the result of invoking the '~/' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '~/' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl integerDivide(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.integerDivide(rightOperand._state));

  /**
   * Return `true` if this object represents an object whose type is 'bool'.
   *
   * @return `true` if this object represents a boolean value
   */
  bool get isBool => _state.isBool;

  /**
   * Return `true` if this object represents an object whose type is either 'bool', 'num',
   * 'String', or 'Null'.
   *
   * @return `true` if this object represents either a boolean, numeric, string or null value
   */
  bool get isBoolNumStringOrNull => _state.isBoolNumStringOrNull;

  bool get isFalse => _state is BoolState && identical((_state as BoolState).value, false);

  bool get isNull => _state is NullState;

  bool get isTrue => _state is BoolState && identical((_state as BoolState).value, true);

  /**
   * Return `true` if this object represents an instance of a user-defined class.
   *
   * @return `true` if this object represents an instance of a user-defined class
   */
  bool get isUserDefinedObject => _state is GenericState;

  /**
   * Return the result of invoking the '&lt;' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl lessThan(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.lessThan(rightOperand._state));

  /**
   * Return the result of invoking the '&lt;=' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;=' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl lessThanOrEqual(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.lessThanOrEqual(rightOperand._state));

  /**
   * Return the result of invoking the '&&' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&&' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl logicalAnd(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.logicalAnd(rightOperand._state));

  /**
   * Return the result of invoking the '!' operator on this object.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of invoking the '!' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl logicalNot(TypeProvider typeProvider) => new DartObjectImpl(typeProvider.boolType, _state.logicalNot());

  /**
   * Return the result of invoking the '||' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '||' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl logicalOr(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.boolType, _state.logicalOr(rightOperand._state));

  /**
   * Return the result of invoking the '-' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '-' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl minus(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    InstanceState result = _state.minus(rightOperand._state);
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("minus returned a ${result.runtimeType.toString()}");
  }

  /**
   * Return the result of invoking the '-' operator on this object.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of invoking the '-' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl negated(TypeProvider typeProvider) {
    InstanceState result = _state.negated();
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("negated returned a ${result.runtimeType.toString()}");
  }

  /**
   * Return the result of invoking the '!=' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '!=' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl notEqual(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    if (type != rightOperand.type) {
      String typeName = type.name;
      if (typeName != "bool" && typeName != "double" && typeName != "int" && typeName != "num" && typeName != "String") {
        return new DartObjectImpl(typeProvider.boolType, BoolState.TRUE_STATE);
      }
    }
    return new DartObjectImpl(typeProvider.boolType, _state.equalEqual(rightOperand._state).logicalNot());
  }

  /**
   * Return the result of converting this object to a String.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of converting this object to a String
   * @throws EvaluationException if the object cannot be converted to a String
   */
  DartObjectImpl performToString(TypeProvider typeProvider) {
    InterfaceType stringType = typeProvider.stringType;
    if (identical(type, stringType)) {
      return this;
    }
    return new DartObjectImpl(stringType, _state.convertToString());
  }

  /**
   * Return the result of invoking the '%' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '%' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl remainder(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    InstanceState result = _state.remainder(rightOperand._state);
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("remainder returned a ${result.runtimeType.toString()}");
  }

  /**
   * Return the result of invoking the '&lt;&lt;' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;&lt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl shiftLeft(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.shiftLeft(rightOperand._state));

  /**
   * Return the result of invoking the '&gt;&gt;' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;&gt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl shiftRight(TypeProvider typeProvider, DartObjectImpl rightOperand) => new DartObjectImpl(typeProvider.intType, _state.shiftRight(rightOperand._state));

  /**
   * Return the result of invoking the '*' operator on this object with the given argument.
   *
   * @param typeProvider the type provider used to find known types
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '*' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  DartObjectImpl times(TypeProvider typeProvider, DartObjectImpl rightOperand) {
    InstanceState result = _state.times(rightOperand._state);
    if (result is IntState) {
      return new DartObjectImpl(typeProvider.intType, result);
    } else if (result is DoubleState) {
      return new DartObjectImpl(typeProvider.doubleType, result);
    } else if (result is NumState) {
      return new DartObjectImpl(typeProvider.numType, result);
    }
    // We should never get here.
    throw new IllegalStateException("times returned a ${result.runtimeType.toString()}");
  }

  String toString() => "${type.displayName} (${_state.toString()})";
}

/**
 * Instances of the class `DoubleState` represent the state of an object representing a
 * double.
 */
class DoubleState extends NumState {
  /**
   * The value of this instance.
   */
  final double value;

  /**
   * A state that can be used to represent a double whose value is not known.
   */
  static DoubleState UNKNOWN_VALUE = new DoubleState(null);

  /**
   * Initialize a newly created state to represent a double with the given value.
   *
   * @param value the value of this instance
   */
  DoubleState(this.value);

  NumState add(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value + rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value + rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  StringState convertToString() {
    if (value == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(value.toString());
  }

  NumState divide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value / rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value / rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value == rightValue);
    } else if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value == rightValue.toDouble());
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  bool operator ==(Object object) => object is DoubleState && (value == object.value);

  String get typeName => "double";

  BoolState greaterThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value > rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value > rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState greaterThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value >= rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value >= rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  bool hasExactValue() => true;

  int get hashCode => value == null ? 0 : value.hashCode;

  IntState integerDivide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return IntState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return IntState.UNKNOWN_VALUE;
      }
      double result = value / rightValue.toDouble();
      return new IntState(result.toInt());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return IntState.UNKNOWN_VALUE;
      }
      double result = value / rightValue;
      return new IntState(result.toInt());
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return IntState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  bool get isBoolNumStringOrNull => true;

  BoolState lessThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value < rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value < rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState lessThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value <= rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value <= rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState minus(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value - rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value - rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState negated() {
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return new DoubleState(-(value));
  }

  NumState remainder(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value % rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value % rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState times(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value * rightValue.toDouble());
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new DoubleState(value * rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  String toString() => value == null ? "-unknown-" : value.toString();
}

/**
 * Instances of the class `DynamicState` represent the state of an object representing a Dart
 * object for which there is no type information.
 */
class DynamicState extends InstanceState {
  /**
   * The unique instance of this class.
   */
  static DynamicState DYNAMIC_STATE = new DynamicState();

  NumState add(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return unknownNum(rightOperand);
  }

  IntState bitAnd(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  IntState bitNot() => IntState.UNKNOWN_VALUE;

  IntState bitOr(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  IntState bitXor(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  StringState concatenate(InstanceState rightOperand) {
    assertString(rightOperand);
    return StringState.UNKNOWN_VALUE;
  }

  BoolState convertToBool() => BoolState.UNKNOWN_VALUE;

  StringState convertToString() => StringState.UNKNOWN_VALUE;

  NumState divide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return unknownNum(rightOperand);
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  String get typeName => "dynamic";

  BoolState greaterThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState greaterThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  IntState integerDivide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  bool get isBool => true;

  bool get isBoolNumStringOrNull => true;

  BoolState lessThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState lessThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState logicalAnd(InstanceState rightOperand) {
    assertBool(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState logicalNot() => BoolState.UNKNOWN_VALUE;

  BoolState logicalOr(InstanceState rightOperand) {
    assertBool(rightOperand);
    return rightOperand.convertToBool();
  }

  NumState minus(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return unknownNum(rightOperand);
  }

  NumState negated() => NumState.UNKNOWN_VALUE;

  NumState remainder(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return unknownNum(rightOperand);
  }

  IntState shiftLeft(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  IntState shiftRight(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    return IntState.UNKNOWN_VALUE;
  }

  NumState times(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return unknownNum(rightOperand);
  }

  /**
   * Return an object representing an unknown numeric value whose type is based on the type of the
   * right-hand operand.
   *
   * @param rightOperand the operand whose type will determine the type of the result
   * @return an object representing an unknown numeric value
   */
  NumState unknownNum(InstanceState rightOperand) {
    if (rightOperand is IntState) {
      return IntState.UNKNOWN_VALUE;
    } else if (rightOperand is DoubleState) {
      return DoubleState.UNKNOWN_VALUE;
    }
    return NumState.UNKNOWN_VALUE;
  }
}

/**
 * Instances of the class `EvaluationException` represent a run-time exception that would be
 * thrown during the evaluation of Dart code.
 */
class EvaluationException extends JavaException {
  /**
   * The error code associated with the exception.
   */
  final ErrorCode errorCode;

  /**
   * Initialize a newly created exception to have the given error code.
   *
   * @param errorCode the error code associated with the exception
   */
  EvaluationException(this.errorCode);
}

/**
 * Instances of the class `FunctionState` represent the state of an object representing a
 * function.
 */
class FunctionState extends InstanceState {
  /**
   * The element representing the function being modeled.
   */
  ExecutableElement _element;

  /**
   * Initialize a newly created state to represent the given function.
   *
   * @param element the element representing the function being modeled
   */
  FunctionState(ExecutableElement element) {
    this._element = element;
  }

  StringState convertToString() {
    if (_element == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(_element.name);
  }

  bool operator ==(Object object) => object is FunctionState && (_element == object._element);

  BoolState equalEqual(InstanceState rightOperand) {
    if (_element == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is FunctionState) {
      ExecutableElement rightElement = rightOperand._element;
      if (rightElement == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(_element == rightElement);
    } else if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  String get typeName => "Function";

  int get hashCode => _element == null ? 0 : _element.hashCode;

  String toString() => _element == null ? "-unknown-" : _element.name;
}

/**
 * Instances of the class `GenericState` represent the state of an object representing a Dart
 * object for which there is no more specific state.
 */
class GenericState extends InstanceState {
  /**
   * The values of the fields of this instance.
   */
  Map<String, DartObjectImpl> _fieldMap = new Map<String, DartObjectImpl>();

  /**
   * A state that can be used to represent an object whose state is not known.
   */
  static GenericState UNKNOWN_VALUE = new GenericState(new Map<String, DartObjectImpl>());

  /**
   * Initialize a newly created state to represent a newly created object.
   *
   * @param fieldMap the values of the fields of this instance
   */
  GenericState(Map<String, DartObjectImpl> fieldMap) {
    this._fieldMap = fieldMap;
  }

  StringState convertToString() => StringState.UNKNOWN_VALUE;

  bool operator ==(Object object) {
    if (object is! GenericState) {
      return false;
    }
    GenericState state = object as GenericState;
    Set<String> otherFields = new Set<String>();
    for (String fieldName in _fieldMap.keys.toSet()) {
      if (_fieldMap[fieldName] != state._fieldMap[fieldName]) {
        return false;
      }
      otherFields.remove(fieldName);
    }
    for (String fieldName in otherFields) {
      if (state._fieldMap[fieldName] != _fieldMap[fieldName]) {
        return false;
      }
    }
    return true;
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.from(this == rightOperand);
  }

  String get typeName => "user defined type";

  int get hashCode {
    int hashCode = 0;
    for (DartObjectImpl value in _fieldMap.values) {
      hashCode += value.hashCode;
    }
    return hashCode;
  }
}

/**
 * The class `InstanceState` defines the behavior of objects representing the state of a Dart
 * object.
 */
abstract class InstanceState {
  /**
   * Return the result of invoking the '+' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '+' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState add(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState bitAnd(InstanceState rightOperand) {
    assertIntOrNull(this);
    assertIntOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '~' operator on this object.
   *
   * @return the result of invoking the '~' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState bitNot() {
    assertIntOrNull(this);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '|' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '|' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState bitOr(InstanceState rightOperand) {
    assertIntOrNull(this);
    assertIntOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '^' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '^' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState bitXor(InstanceState rightOperand) {
    assertIntOrNull(this);
    assertIntOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the ' ' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the ' ' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  StringState concatenate(InstanceState rightOperand) {
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of applying boolean conversion to this object.
   *
   * @param typeProvider the type provider used to find known types
   * @return the result of applying boolean conversion to this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState convertToBool() => BoolState.FALSE_STATE;

  /**
   * Return the result of converting this object to a String.
   *
   * @return the result of converting this object to a String
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  StringState convertToString();

  /**
   * Return the result of invoking the '/' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '/' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState divide(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '==' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '==' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState equalEqual(InstanceState rightOperand);

  /**
   * Return the name of the type of this value.
   *
   * @return the name of the type of this value
   */
  String get typeName;

  /**
   * Return this object's value if it can be represented exactly, or `null` if either the
   * value cannot be represented exactly or if the value is `null`. Clients should use
   * [hasExactValue] to distinguish between these two cases.
   *
   * @return this object's value
   */
  Object get value => null;

  /**
   * Return the result of invoking the '&gt;' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState greaterThan(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&gt;=' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;=' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState greaterThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return `true` if this object's value can be represented exactly.
   *
   * @return `true` if this object's value can be represented exactly
   */
  bool hasExactValue() => false;

  /**
   * Return the result of invoking the '~/' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '~/' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState integerDivide(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return `true` if this object represents an object whose type is 'bool'.
   *
   * @return `true` if this object represents a boolean value
   */
  bool get isBool => false;

  /**
   * Return `true` if this object represents an object whose type is either 'bool', 'num',
   * 'String', or 'Null'.
   *
   * @return `true` if this object represents either a boolean, numeric, string or null value
   */
  bool get isBoolNumStringOrNull => false;

  /**
   * Return the result of invoking the '&lt;' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState lessThan(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&lt;=' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;=' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState lessThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&&' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&&' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState logicalAnd(InstanceState rightOperand) {
    assertBool(this);
    assertBool(rightOperand);
    return BoolState.FALSE_STATE;
  }

  /**
   * Return the result of invoking the '!' operator on this object.
   *
   * @return the result of invoking the '!' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState logicalNot() {
    assertBool(this);
    return BoolState.TRUE_STATE;
  }

  /**
   * Return the result of invoking the '||' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '||' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  BoolState logicalOr(InstanceState rightOperand) {
    assertBool(this);
    assertBool(rightOperand);
    return rightOperand.convertToBool();
  }

  /**
   * Return the result of invoking the '-' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '-' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState minus(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '-' operator on this object.
   *
   * @return the result of invoking the '-' operator on this object
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState negated() {
    assertNumOrNull(this);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '%' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '%' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState remainder(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&lt;&lt;' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&lt;&lt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState shiftLeft(InstanceState rightOperand) {
    assertIntOrNull(this);
    assertIntOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '&gt;&gt;' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '&gt;&gt;' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  IntState shiftRight(InstanceState rightOperand) {
    assertIntOrNull(this);
    assertIntOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Return the result of invoking the '*' operator on this object with the given argument.
   *
   * @param rightOperand the right-hand operand of the operation
   * @return the result of invoking the '*' operator on this object with the given argument
   * @throws EvaluationException if the operator is not appropriate for an object of this kind
   */
  NumState times(InstanceState rightOperand) {
    assertNumOrNull(this);
    assertNumOrNull(rightOperand);
    throw new EvaluationException(CompileTimeErrorCode.INVALID_CONSTANT);
  }

  /**
   * Throw an exception if the given state does not represent a boolean value.
   *
   * @param state the state being tested
   * @throws EvaluationException if the given state does not represent a boolean value
   */
  void assertBool(InstanceState state) {
    if (!(state is BoolState || state is DynamicState)) {
      throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL);
    }
  }

  /**
   * Throw an exception if the given state does not represent a boolean, numeric, string or null
   * value.
   *
   * @param state the state being tested
   * @throws EvaluationException if the given state does not represent a boolean, numeric, string or
   *           null value
   */
  void assertBoolNumStringOrNull(InstanceState state) {
    if (!(state is BoolState || state is DoubleState || state is IntState || state is NumState || state is StringState || state is NullState || state is DynamicState)) {
      throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL_NUM_STRING);
    }
  }

  /**
   * Throw an exception if the given state does not represent an integer or null value.
   *
   * @param state the state being tested
   * @throws EvaluationException if the given state does not represent an integer or null value
   */
  void assertIntOrNull(InstanceState state) {
    if (!(state is IntState || state is NumState || state is NullState || state is DynamicState)) {
      throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_INT);
    }
  }

  /**
   * Throw an exception if the given state does not represent a boolean, numeric, string or null
   * value.
   *
   * @param state the state being tested
   * @throws EvaluationException if the given state does not represent a boolean, numeric, string or
   *           null value
   */
  void assertNumOrNull(InstanceState state) {
    if (!(state is DoubleState || state is IntState || state is NumState || state is NullState || state is DynamicState)) {
      throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_NUM);
    }
  }

  /**
   * Throw an exception if the given state does not represent a String value.
   *
   * @param state the state being tested
   * @throws EvaluationException if the given state does not represent a String value
   */
  void assertString(InstanceState state) {
    if (!(state is StringState || state is DynamicState)) {
      throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL);
    }
  }
}

/**
 * Instances of the class `IntState` represent the state of an object representing an int.
 */
class IntState extends NumState {
  /**
   * The value of this instance.
   */
  final int value;

  /**
   * A state that can be used to represent an int whose value is not known.
   */
  static IntState UNKNOWN_VALUE = new IntState(null);

  /**
   * Initialize a newly created state to represent an int with the given value.
   *
   * @param value the value of this instance
   */
  IntState(this.value);

  NumState add(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      if (rightOperand is DoubleState) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value + rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return new DoubleState(value.toDouble() + rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  IntState bitAnd(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value & rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  IntState bitNot() {
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return new IntState(~value);
  }

  IntState bitOr(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value | rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  IntState bitXor(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value ^ rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  StringState convertToString() {
    if (value == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(value.toString());
  }

  NumState divide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      if (rightOperand is DoubleState) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      } else if (rightValue == 0) {
        return new DoubleState(value.toDouble() / rightValue.toDouble());
      }
      return new IntState(value ~/ rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return new DoubleState(value.toDouble() / rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value == rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(rightValue == value.toDouble());
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  bool operator ==(Object object) => object is IntState && (value == object.value);

  String get typeName => "int";

  BoolState greaterThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.compareTo(rightValue) > 0);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.toDouble() > rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState greaterThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.compareTo(rightValue) >= 0);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.toDouble() >= rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  bool hasExactValue() => true;

  int get hashCode => value == null ? 0 : value.hashCode;

  IntState integerDivide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      } else if (rightValue == 0) {
        throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_IDBZE);
      }
      return new IntState(value ~/ rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      double result = value.toDouble() / rightValue;
      return new IntState(result.toInt());
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  bool get isBoolNumStringOrNull => true;

  BoolState lessThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.compareTo(rightValue) < 0);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.toDouble() < rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  BoolState lessThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.compareTo(rightValue) <= 0);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value.toDouble() <= rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return BoolState.UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState minus(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      if (rightOperand is DoubleState) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value - rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return new DoubleState(value.toDouble() - rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState negated() {
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    return new IntState(-value);
  }

  NumState remainder(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      if (rightOperand is DoubleState) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      } else if (rightValue == 0) {
        return new DoubleState(value.toDouble() % rightValue.toDouble());
      }
      return new IntState(value.remainder(rightValue));
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return new DoubleState(value.toDouble() % rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  IntState shiftLeft(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      } else if (rightValue.bitLength > 31) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value << rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  IntState shiftRight(InstanceState rightOperand) {
    assertIntOrNull(rightOperand);
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      } else if (rightValue.bitLength > 31) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value >> rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  NumState times(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (value == null) {
      if (rightOperand is DoubleState) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return UNKNOWN_VALUE;
    }
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new IntState(value * rightValue);
    } else if (rightOperand is DoubleState) {
      double rightValue = rightOperand.value;
      if (rightValue == null) {
        return DoubleState.UNKNOWN_VALUE;
      }
      return new DoubleState(value.toDouble() * rightValue);
    } else if (rightOperand is DynamicState || rightOperand is NumState) {
      return UNKNOWN_VALUE;
    }
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  String toString() => value == null ? "-unknown-" : value.toString();
}

/**
 * The unique instance of the class `ListState` represents the state of an object representing
 * a list.
 */
class ListState extends InstanceState {
  /**
   * The elements of the list.
   */
  List<DartObjectImpl> _elements;

  /**
   * Initialize a newly created state to represent a list with the given elements.
   *
   * @param elements the elements of the list
   */
  ListState(List<DartObjectImpl> elements) {
    this._elements = elements;
  }

  StringState convertToString() => StringState.UNKNOWN_VALUE;

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.from(this == rightOperand);
  }

  bool operator ==(Object object) {
    if (object is! ListState) {
      return false;
    }
    List<DartObjectImpl> otherElements = (object as ListState)._elements;
    int count = _elements.length;
    if (otherElements.length != count) {
      return false;
    } else if (count == 0) {
      return true;
    }
    for (int i = 0; i < count; i++) {
      if (_elements[i] != otherElements[i]) {
        return false;
      }
    }
    return true;
  }

  String get typeName => "List";

  List<Object> get value {
    int count = _elements.length;
    List<Object> result = new List<Object>(count);
    for (int i = 0; i < count; i++) {
      DartObjectImpl element = _elements[i];
      if (!element.hasExactValue()) {
        return null;
      }
      result[i] = element.value;
    }
    return result;
  }

  bool hasExactValue() {
    int count = _elements.length;
    for (int i = 0; i < count; i++) {
      if (!_elements[i].hasExactValue()) {
        return false;
      }
    }
    return true;
  }

  int get hashCode {
    int value = 0;
    int count = _elements.length;
    for (int i = 0; i < count; i++) {
      value = (value << 3) ^ _elements[i].hashCode;
    }
    return value;
  }
}

/**
 * The unique instance of the class `ListState` represents the state of an object representing
 * a map.
 */
class MapState extends InstanceState {
  /**
   * The entries in the map.
   */
  Map<DartObjectImpl, DartObjectImpl> _entries;

  /**
   * Initialize a newly created state to represent a map with the given entries.
   *
   * @param entries the entries in the map
   */
  MapState(Map<DartObjectImpl, DartObjectImpl> entries) {
    this._entries = entries;
  }

  StringState convertToString() => StringState.UNKNOWN_VALUE;

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.from(this == rightOperand);
  }

  bool operator ==(Object object) {
    if (object is! MapState) {
      return false;
    }
    Map<DartObjectImpl, DartObjectImpl> otherElements = (object as MapState)._entries;
    int count = _entries.length;
    if (otherElements.length != count) {
      return false;
    } else if (count == 0) {
      return true;
    }
    for (MapEntry<DartObjectImpl, DartObjectImpl> entry in getMapEntrySet(_entries)) {
      DartObjectImpl key = entry.getKey();
      DartObjectImpl value = entry.getValue();
      DartObjectImpl otherValue = otherElements[key];
      if (value != otherValue) {
        return false;
      }
    }
    return true;
  }

  String get typeName => "Map";

  Map<Object, Object> get value {
    Map<Object, Object> result = new Map<Object, Object>();
    for (MapEntry<DartObjectImpl, DartObjectImpl> entry in getMapEntrySet(_entries)) {
      DartObjectImpl key = entry.getKey();
      DartObjectImpl value = entry.getValue();
      if (!key.hasExactValue() || !value.hasExactValue()) {
        return null;
      }
      result[key.value] = value.value;
    }
    return result;
  }

  bool hasExactValue() {
    for (MapEntry<DartObjectImpl, DartObjectImpl> entry in getMapEntrySet(_entries)) {
      if (!entry.getKey().hasExactValue() || !entry.getValue().hasExactValue()) {
        return false;
      }
    }
    return true;
  }

  int get hashCode {
    int value = 0;
    for (DartObjectImpl key in _entries.keys.toSet()) {
      value = (value << 3) ^ key.hashCode;
    }
    return value;
  }
}

/**
 * The unique instance of the class `NullState` represents the state of the value 'null'.
 */
class NullState extends InstanceState {
  /**
   * An instance representing the boolean value 'true'.
   */
  static NullState NULL_STATE = new NullState();

  BoolState convertToBool() {
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  StringState convertToString() => new StringState("null");

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.from(rightOperand is NullState);
  }

  bool operator ==(Object object) => object is NullState;

  String get typeName => "Null";

  bool hasExactValue() => true;

  int get hashCode => 0;

  bool get isBoolNumStringOrNull => true;

  BoolState logicalNot() {
    throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION);
  }

  String toString() => "null";
}

/**
 * Instances of the class `NumState` represent the state of an object representing a number of
 * an unknown type (a 'num').
 */
class NumState extends InstanceState {
  /**
   * A state that can be used to represent a number whose value is not known.
   */
  static NumState UNKNOWN_VALUE = new NumState();

  NumState add(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return UNKNOWN_VALUE;
  }

  StringState convertToString() => StringState.UNKNOWN_VALUE;

  NumState divide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return UNKNOWN_VALUE;
  }

  bool operator ==(Object object) => object is NumState;

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  String get typeName => "num";

  BoolState greaterThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState greaterThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  int get hashCode => 7;

  IntState integerDivide(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    if (rightOperand is IntState) {
      int rightValue = rightOperand.value;
      if (rightValue == null) {
        return IntState.UNKNOWN_VALUE;
      } else if (rightValue == 0) {
        throw new EvaluationException(CompileTimeErrorCode.CONST_EVAL_THROWS_IDBZE);
      }
    } else if (rightOperand is DynamicState) {
      return IntState.UNKNOWN_VALUE;
    }
    return IntState.UNKNOWN_VALUE;
  }

  bool get isBoolNumStringOrNull => true;

  BoolState lessThan(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  BoolState lessThanOrEqual(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return BoolState.UNKNOWN_VALUE;
  }

  NumState minus(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return UNKNOWN_VALUE;
  }

  NumState negated() => UNKNOWN_VALUE;

  NumState remainder(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return UNKNOWN_VALUE;
  }

  NumState times(InstanceState rightOperand) {
    assertNumOrNull(rightOperand);
    return UNKNOWN_VALUE;
  }

  String toString() => "-unknown-";
}

/**
 * Instances of the class `StringState` represent the state of an object representing a
 * string.
 */
class StringState extends InstanceState {
  /**
   * The value of this instance.
   */
  final String value;

  /**
   * A state that can be used to represent a double whose value is not known.
   */
  static StringState UNKNOWN_VALUE = new StringState(null);

  /**
   * Initialize a newly created state to represent the given value.
   *
   * @param value the value of this instance
   */
  StringState(this.value);

  StringState concatenate(InstanceState rightOperand) {
    if (value == null) {
      return UNKNOWN_VALUE;
    }
    if (rightOperand is StringState) {
      String rightValue = rightOperand.value;
      if (rightValue == null) {
        return UNKNOWN_VALUE;
      }
      return new StringState("${value}${rightValue}");
    } else if (rightOperand is DynamicState) {
      return UNKNOWN_VALUE;
    }
    return super.concatenate(rightOperand);
  }

  StringState convertToString() => this;

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is StringState) {
      String rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value == rightValue);
    } else if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  bool operator ==(Object object) => object is StringState && (value == object.value);

  String get typeName => "String";

  bool hasExactValue() => true;

  int get hashCode => value == null ? 0 : value.hashCode;

  bool get isBoolNumStringOrNull => true;

  String toString() => value == null ? "-unknown-" : "'${value}'";
}

/**
 * Instances of the class `StringState` represent the state of an object representing a
 * symbol.
 */
class SymbolState extends InstanceState {
  /**
   * The value of this instance.
   */
  final String value;

  /**
   * Initialize a newly created state to represent the given value.
   *
   * @param value the value of this instance
   */
  SymbolState(this.value);

  StringState convertToString() {
    if (value == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(value);
  }

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (value == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is SymbolState) {
      String rightValue = rightOperand.value;
      if (rightValue == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(value == rightValue);
    } else if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  bool operator ==(Object object) => object is SymbolState && (value == object.value);

  String get typeName => "Symbol";

  bool hasExactValue() => true;

  int get hashCode => value == null ? 0 : value.hashCode;

  String toString() => value == null ? "-unknown-" : "#${value}";
}

/**
 * Instances of the class `TypeState` represent the state of an object representing a type.
 */
class TypeState extends InstanceState {
  /**
   * The element representing the type being modeled.
   */
  Element _element;

  /**
   * Initialize a newly created state to represent the given value.
   *
   * @param element the element representing the type being modeled
   */
  TypeState(Element element) {
    this._element = element;
  }

  StringState convertToString() {
    if (_element == null) {
      return StringState.UNKNOWN_VALUE;
    }
    return new StringState(_element.name);
  }

  bool operator ==(Object object) => object is TypeState && (_element == object._element);

  BoolState equalEqual(InstanceState rightOperand) {
    assertBoolNumStringOrNull(rightOperand);
    if (_element == null) {
      return BoolState.UNKNOWN_VALUE;
    }
    if (rightOperand is TypeState) {
      Element rightElement = rightOperand._element;
      if (rightElement == null) {
        return BoolState.UNKNOWN_VALUE;
      }
      return BoolState.from(_element == rightElement);
    } else if (rightOperand is DynamicState) {
      return BoolState.UNKNOWN_VALUE;
    }
    return BoolState.FALSE_STATE;
  }

  String get typeName => "Type";

  int get hashCode => _element == null ? 0 : _element.hashCode;

  String toString() => _element == null ? "-unknown-" : _element.name;
}