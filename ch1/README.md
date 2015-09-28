# 安装Julia 环境

本节将指导你下载并安装Julia 所需组件。其中包含如下几项：

- 安装Julia 及使用Julia shell
- 启动项 及Julia 脚本
- 包管理
- 安装与使用Julia Studio、IJulia、Sublime-IJulia、Juno及其他编辑器或IDE
- 使用Julia

本节结束后，你除了能跑Julia 外，还能编写Julia 脚本、及使用各编辑器或IDE 的众多内置功能，如此开发更舒心。

-----

本节众多冗余，捡重点不再一一翻译。

- [下载安装](http://julialang.org/downloads/) 对应系统的包.
- 在`~/.juliarc.jl` 中添加代码（比如`println(" Greetings! 你 好! 안녕하세요?")`）可在每次启动Julia 时执行。
- Julia shell 中：
    - 每行开头输入`;` 后，后续输入的会当作系统命令如linux 的`ls mkdir` 等。 
    - 使用`include("FILENAME.jl")` 可执行该脚本
    - CTRL+D 退出； CTRL+L 清屏；CTRL+C 终止命令 
    - 可用Tab 补全包名、函数等。
    
- 包管理，多数都是GitHub 上的外部包，官方包声明在 [https://github.com/JuliaLang/METADATA.jl.](https://github.com/JuliaLang/METADATA.jl) 
    - Pkg.dir(), Pkg.status(), Pkg.installed() 可以查看包安装路径及安装情况。
    - Pkg.update(), Pkg.add("PACKAGE_NAME") 可以更新或安装特定包
    
- 其他工具如：
    - [Julia Studio](http://forio.com/labs/julia-studio/)
    - [IJulia](https://github.com/JuliaLang/IJulia.jl), Julia for IPython，可在Web 上使用Julia
    - [Sublime-IJulia](https://github.com/quinnj/Sublime-IJulia) 
    - [Juno](http://junolab.org) 另一个IDE 
    
## Julia 的工作原理

Julia 使用LLVM JIT，动态生成并优化成本地机器码。所以第一次使用函数会慢一些，它解析并作类型推断，并生成机器码；第二次使用时就可沿用之前的机器码从而非常快。
比如
```julia
cubic(x)=x*x*x
```
`code_llvm(cubic,(Int64,))` 和 `code_native(cubic,(Float64,))` 即可显示`cubic` 函数对应生成的整形和浮点型参数的字节码和汇编代码。

Julia 也有GC 进行自我内存管理。