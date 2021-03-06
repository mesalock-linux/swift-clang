//===--- CheckerBase.td - Checker TableGen classes ------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  This file defines the TableGen core definitions for checkers
//
//===----------------------------------------------------------------------===//

/// Describes a package. Every checker is a part of a package, for example,
/// 'NullDereference' is part of the 'core' package, hence it's full name is
/// 'core.NullDereference'.
/// Example:
///   def Core : Package<"core">;
class Package<string name> {
  string       PackageName = name;
  Package ParentPackage;
}

/// Describes a 'super' package that holds another package inside it. This is
/// used to nest packages in one another. One may, for example, create the
/// 'builtin' package inside 'core', thus creating the package 'core.builtin'.
/// Example:
///   def CoreBuiltin : Package<"builtin">, ParentPackage<Core>;
class ParentPackage<Package P> { Package ParentPackage = P; }

/// A description. May be displayed to the user when clang is invoked with
/// a '-help'-like command line option.
class HelpText<string text> { string HelpText = text; }

/// Describes what kind of documentation exists for the checker.
class DocumentationEnum<bits<2> val> {
  bits<2> Documentation = val;
}
def NotDocumented : DocumentationEnum<0>;
def HasDocumentation : DocumentationEnum<1>;
def HasAlphaDocumentation : DocumentationEnum<2>;

class Documentation<DocumentationEnum val> {
  bits<2> Documentation = val.Documentation;
}

/// Describes a checker. Every builtin checker has to be registered with the use
/// of this class (out-of-trunk checkers loaded from plugins obviously don't).
/// Note that a checker has a name (e.g.: 'NullDereference'), and a fullname,
/// that is autogenerated with the help of the ParentPackage field, that also
/// includes package names (e.g.: 'core.NullDereference').
/// Example:
///   def DereferenceChecker : Checker<"NullDereference">,
///     HelpText<"Check for dereferences of null pointers">;
class Checker<string name = ""> {
  string        CheckerName = name;
  string        HelpText;
  list<Checker> Dependencies;
  bits<2>       Documentation;
  Package       ParentPackage;
}

/// Describes dependencies in between checkers. For example, InnerPointerChecker
/// relies on information MallocBase gathers.
/// Example:
///   def InnerPointerChecker : Checker<"InnerPointer">,
///     HelpText<"Check for inner pointers of C++ containers used after "
///              "re/deallocation">,
///     Dependencies<[MallocBase]>;
class Dependencies<list<Checker> Deps = []> {
  list<Checker> Dependencies = Deps;
}
