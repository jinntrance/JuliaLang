# Julia 在其他编程语言中的地位

Julia 让曾经水火不容的两项技术握手言和了：

- 一者动态、无类型、解释型（诸如Python, Ruby, Perl, MATLAB/Octave, R）
- 另者静态、有类型、编译型（譬如C, C++, Fortran, Fortress）

但Julia 是怎样兼有前者的灵活性与后者的速度的呢？

Julia 没有静态编译的步骤。机器码都是实时由基于LLVM[^LLVM]的即时编译器[^JIT]产生。此编译器，伴随着设计此语言的初衷，就能在数值、技术、科学计算中实现最佳的性能。性能的关键因素是类型信息TI[^TI]，类型是由自动且智能的类型推断引擎维护。这样就能让让变量只存数据，而不必维护类型信息。


[^LLVM]: Low Level Virtual Machine
[^JIT]: JIT Compiler
[^TI]: Type Information