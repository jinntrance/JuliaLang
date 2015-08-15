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
- Julia shell 中
    - 每行开头输入`;` 后，后续输入的会当作系统命令如linux 的`ls mkdir` 等。 
    - 使用`include("FILENAME.jl")` 可执行该脚本