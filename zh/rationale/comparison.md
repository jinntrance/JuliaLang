#对比其他数据科学家使用的语言 

因为速度也是Julia 的制胜法宝，所以与其他语言的Benchmark 对比也放在了Julia [官网](http://julialang.org)很明显的位置。上面展示了C、Fortran的性能，通常都在优化过的C 代码性能的2倍以内，这也也把其他传统的动态语言甩了一条街。设计Julia 的一个明确目标就是，能有足够好的性能以不必回退到C 语言。这与如后的情况就形成鲜明对比：生产环境下（就算在NumPy 中），不得不使用C 来获取过得去的性能。因此，技术计算新时代的到来指日可待，而相关库文件也能用高级语言而非C或Fortran 这种。Julia 也特别能跑MATLAB 和R 样式的代码。接下来我们就详细对比对比。

## MATLAB


<script type="text/javascript" src="http://www.josephjctang.com/assets/js/analytics.js" defer="defer"></script>