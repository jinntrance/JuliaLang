#对比其他数据科学家使用的语言 

因为速度也是Julia 的制胜法宝，所以与其他语言的Benchmark 对比也放在了Julia [官网](http://julialang.org)很明显的位置。上面展示了C、Fortran的性能，通常都在优化过的C 代码性能的2倍以内，这也也把其他传统的动态语言甩了一条街。设计Julia 的一个明确目标就是，能有足够好的性能以不必回退到C 语言。这与如后的情况就形成鲜明对比：生产环境下（就算在NumPy 中），不得不使用C 来获取过得去的性能。因此，技术计算新时代的到来指日可待，而相关库文件也能用高级语言而非C或Fortran 这种。Julia 也特别能跑MATLAB 和R 样式的代码。接下来我们就详细对比对比。

## MATLAB

对MATLAB 用户来说，Julia 乍看就很像；Julia 句法与MATLAB 本来就很相似，只是Julia 面向更通用的编程而已。Julia 中的很多函数名，也能跟MATLAB/Octave 对应上（而跟R 里的函数名却对不上）；但是底层计算实现却大相径庭。MATLAB 传统上所应用的线性代数领域，Julia 也有同等的应用空间和应用能力；然而，Julia 不会让你因版权费而大伤脑筋。此外，Benchmark 结果表明Julia 在不同类型操作上，速度是MATLAB/Octave 的10 到 1000 倍。Julia 也向MATLAB 编程提供了接口包`MATLAB.jl`[^MATLAB.jl]

## R

此前，R 是统计领域备受推崇的开发语言。而现在Julia 也业已证明了如R 一样适用于该领域，并且会有10 倍到1000 倍的性能提升。在MATLAB 中做统计和在R 中做线性代数同样让人抓狂，但Julia 却能轻松玩转此两种。Julia 比基于向量类型的R 有更丰富的类型系统。一些统计专家如 _Douglas Bates_ 也强烈支持并推崇Julia。Julia 也提供一个接口给R 语言：`Rif.jl`[^Rif.jl]

## Python

跟Python 对比，Julia 也有10 倍到30 倍的性能优势。然而，Julia 把如Python 的代码编译成机器码，并获得如C 的性能。此外，你也可以使用如后的包在Julia 中调用Python 函数`PyCall`[^PyCall]

因为上述语言中有大量的现存库，对于注重实践的数据科学家来说，如果实际问题需要，他们还是希望能混编Julia 和其他语言如R、Python 的。

Julia 也能应用与数据分析和大数据，因为这些都涉及预测分析、问题建模。这些问题通常都可归约为线性代数算法、图形分析技术，而这些也是Julia 擅长的。

在高性能计算领域，对Julia 这样的语言已是虚位以待。领域专家使用Julia 可以快速并轻便地实验、描述问题，而使用高性能计算跟使用PC 机一样。换言之，一门能让用户快速上手而不必细究底层机器架构的编程语言，正是这个领域非常欢迎的。


[^MATLAB.jl]: [https://github.com/JuliaLang/MATLAB.jl](https://github.com/JuliaLang/MATLAB.jl)
[^Rif.jl]: [https://github.com/lgautier/Rif.jl](https://github.com/lgautier/Rif.jl)
[^PyCall]: [https://github.com/stevengj/PyCall.jl](https://github.com/stevengj/PyCall.jl)