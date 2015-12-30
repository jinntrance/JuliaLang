## 正则表达式

要从文本中搜索和匹配，正则表达式是数据科学家不可或缺的工具。Julia 正则遵从Perl 正则的语法（完整请参阅[正则](http://www.regular-expressions.info/reference.html)）。Julia 中正则表达式是以`r`为前缀的形如`r"RegExp"` 的字符串（类似`VersionNumber`前加`v`），其类型为`Regex`，而其后缀可选`i` `s` `m` `x` 中的一个或多个。

如后是匹配电子邮件地址的例子（`＃>`显示最后结果）：

```julia
email_pattern = r".+@.+" 
input = "john.doe@mit.edu" 
println(ismatch(email_pattern, input)) #> true
```

正则 `+` 匹配一个及以上字符。因此，上例中的模式，就是匹配`@` 前后都有字符的字符串。

在第二个例子中，我们将尝试确定一个信用卡号是否有效：

```julia
visa = r"^(?:4[0-9]{12}(?:[0-9]{3})?)$" #the pattern 
input = "4457418557635128"
ismatch(visa, input) #> true 
if ismatch(visa, input) 
	println("credit card found") 
	m = match(visa, input) 
	println(m.match) #> 4457418557635128 
	println(m.offset) #> 1 
	println( m.offsets) #> [] 
end
```

`ismatch(regex, string)` 函数根据正则表达式是否匹配字符串而返回true 或false，所以我们可以在if 表达式中使用它。如果你需要匹配的详细信息，请使用`match`，而非`ismatch`。`match` 没有匹配到结果时返回`nothing`（`Nothing` 类型的对象，表示无返回结果或无打印输出），匹配到时返回类型`RegexMatch` 的对象。

该RegexMatch 对象具有以下属性：

- `match` 包含匹配到的整个字符串（在此例中，它包含完整的卡号）
- `offset` 第一个匹配到的字符串开始的位置（这里为1）
- `offsets` 类似`offset`，但包含正则里每个group 匹配到的字符串的`offset`
- `captures` 捕获：匹配的子模式（正则里的每个group）对应的字符串的数组（参见下面的举例）

另外，检查字符串是否与特定模式匹配的同时，也可匹配出子模式（`group`）对应的字符串。我们通过括号`()`包含待匹配的子模式。例如，为了捕捉在先前使用的电子邮件地址里的用户名和主机名，我们修改为：

```email_pattern = r"(.+)@(.+)"```

请注意`@` 字符前后都用括号括起来了，那么这里就有两个 `groups`。这就告诉正则引擎，我们想捕获特定的两个子串。欲知详情，见后续例子：

```julia
email_pattern = r"(.+)@(.+)" 
input = "john.doe@ mit.edu" 
m = match(email_pattern, input) 
println(m.captures) #> [" john.doe"," mit.edu"]
```
另一个例子：

```julia
m = match(r"(ju|l)(i)?(a)", "Julia") 
println(m.match) #> "lia" 
println(m.captures) #> l - i - a 
println(m.offset) #> 3 
println(m.offsets) #> 3 - 4 - 5
```

`search` 和`replace` 函数也用正则作为参数的，例如，`replace(" Julia", r" u[\ w]* l", "red")`返回`"Jredia"`。如果你想匹配全部，那么`matchall` 和 `eachmatch` 就派上用场了：

```julia
str = "The sky is blue"
reg = r"[\w]{3,}" # matches words of 3 chars or more
r = matchall(reg, str)
show(r) #> ["The","sky","blue"]
iter = eachmatch(reg, str)
for i in iter
    println("\"$(i.match)\" ")
end
``` 

该 matchall 函数针对每个匹配，从而得到`RegexMatch` 数组 。eachmatch 返回一个针对所有匹配的迭代器 `iter`，这样我们可用一个简单的for 循环遍历。屏幕输出是换行的"The", "sky", "blue" 三个字符串。

## 范围Range和数组

当我们执行 `search("Julia", "uli")` 时，其结果不是索引号，而是一个范围 `2:4` 。其表示所搜索到的字串的索引号区间。这在你必须处理范围时显得特别方便，例如，一到一千`1:1000`。这个对象的类型 `typeof(1:1000)` 的类型为`UnitRange{Int64}`。缺省情况下，Range 的步长是1，但这也可以通过第二数字指定; `0:5:100` 便给出不大于100的5的倍数。你可如下形式遍历一个范围：

```julia
for i in 1:2:9
    println(i)
end
```

此片段将在每行打印出1 3 5 7 9。

上一节在讨论了讨论字符串的`split` 函数时提及了数组类型：

```julia
a = split("A,B,C,D",",")
typeof(a) #> Array{SubString{ASCIIString},1}
show(a) #> SubString{ASCIIString}["A","B","C","D"]
``` 

Julia 的数组是非常有效、强大且灵活的。数组的类型的一般格式为`Array{Type, n}`， 其中n 代表数组维度（我们将在第5章的“集合类型”一节讨论多维数组或矩阵）。如同复杂类型，我们可以认为数组类型是通用的，并且所有的数组元素必须是相同类型的。一维数组（也称为Julia  一个向量**Vector**），可以用方括号包括并用逗号分隔来表示，例如`arr = [100, 25, 37] ` 是一个3个元素`Array{Int64,1}` 类型数组;通过这种形式可自动推断出数组对应的类型。如果你想显示声明类型为`Any`， 则可如后定义` arra = Any[100, 25, "ABC"]`。注意我们不必以指定数组的长度。Julia 自己能识别到，并允许数组按需动态增长。

数组也可以通过传递类型参数和长度构建：

```julia
arr2 = Array(Int64,5) # is a 5-element Array{Int64,1}
show(arr2) #> [0,0,0,0,0]
```

当创建如上的数组时，是不保证初始化值都为0 的（可通过“[创建数组的其他方法](#创建数组的其他方法)”一节来了解如何初始化数组）。

您可以如下形式定义类型长度为0， Float64 类型的数组：

```julia
arr3 = Float64[] #> 0-element Array{Float64,1}
``` 

要填充这个数组，可使用`push!`;例如，`push!(arr3, 1.0)` 返回Array{Float64,1} 类型的长度为1 的数组。

创建一个空数组（如`arr3 = []`）是无济于事的，因为元素类型是`Any`，而Julia 希望能推断出类型！

数组也可以使用一个范围来初始化：

```julia
arr4 = [1:7] #> 7-element Array{Int64,1}: [1,2,3,4,5,6,7]
``` 

当然，当处理大数组时，为获得较好性能，需要开始时就知道数组长度。假设你事先知道`arr2` 仅仅需要 $10^5$ 个元素。如果你调用`sizehint(arr2, 10^5)`，你就可以`push! `至少 $10^5$ 个元素，而不必让Julia 重新分配和复制已经添加的数据。如此显著提升性能。

数组是存储相同类型的值（称为元素）的序列，索引从1到元素的数量（如数学定义，但不同于大多数如Python 的其他高级语言）。如同字符串，我们可以访问使用括号访问各个元素;例如，对于`arr = [100, 25, 37]`，arr[1] 为100，arr[end] 为37。索引越界会出如下错：

```julia
arr[6] #> ERROR: BoundsError()
``` 

您还能以另一方式设置某个元素的值：

```
arr[2] = 5 #> [100, 5, 37]
```  

数组的主要属性由如下几个函数获得：

- 元素类型用`eltype(arr)` ，上例中为 Int64
- 元素的数量用`length(arr)`， 上例中为3
- 维数用`ndims(arr)`， 上例中为1
- 第n维元素的数量由 `size(arr, n)` 得， `size(arr, 1)`得 3

将数组元素由逗号和空格隔开并拼成一个字符串非常简单，如`arr4 = [1:7]`：

```julia
join(arr4, ", ") #> "1, 2, 3, 4, 5, 6, 7"
```

我们也可以用范围的语法（Python 中称为`slice`）来获取子数组：

```julia
arr4[1:3] #>#> 3-element array [1, 2, 3]
arr4[4:end] #> 3-element array [4, 5, 6, 7]
```

*Slice* 也可被被单个值或与另一个数组重新赋值：

```
arr = [1,2,3,4,5]
arr[2:4] = [8,9,10]
println(arr) #> 1 8 9 10 5
```

### 创建数组的其他方法

为方便起见， `zeros(n)` 返回所有值为0.0 的n 元数组， `ones(n)`则返回所有值为1.0 的n 元数组。

`linspace(start, stop, n)` 创建n 个等间距的，始于start，止于stop 的数组，比如：

```
eqa = linspace(0, 10, 5)
show(eqa) #> [0.0,2.5,5.0,7.5,10.0]
```

可使用`cell` 来创建一个数组，其值全是未定义的值：如`cell(4)` 创建四元数组 ` {Any,1} `,其四个值如后：

```
{#undef,#undef,#undef,#undef}
```

要用相同值填充满`arr` 数组，可用`fill!(arr, 42)`，它返回值全为42 的`arr` 数组。要创建一个包含随机整数`Int32` 的五元数组，可用如后命令：

```
v1 = rand(Int32,5)
```

执行结果为：

```
5-element Array{Int32,1}:
  -903807281
  1509373446
   476304311
 -1499387137
  -557145833
```

将其转换为 Int64类型的数组，只需执行`int64(v1)`，或`round(Int64,v1)` 即可。

### 数组常用函数

若 `b = [1:7]` 且 `c = [100,200,300]`， 则可用如后方式拼接b 和c：

```
append!(b, c) #> Now b is [1, 2, 3, 4, 5, 6, 7, 100, 200, 300]
```

数组 b因`append!` 方法的的调用而被改变，这就是为什么`append` 后有`!`的原因。这也是改变参数值的一个惯例表示。

> 
__提示__
以`!` 结尾的函数，会改变它的第一个参数的值。

同样，`push!` 和 `pop!`分别在数组末尾追加，取出一个元素。同时数组内容也被修改了：

```
pop!(b) #> 300, b is now [1, 2, 3, 4, 5, 6, 7, 100, 200]
push!(b, 42) # b is now [1, 2, 3, 4, 5, 6, 7, 100, 200, 42]
```

如果你想要在数组头部做同样的操作， 用`shift!` 和 `unshift!` 即可：

```
shift!(b) #> 1, b is now [2, 3, 4, 5, 6, 7, 100, 200, 42]
unshift!(b, 42) # b is now [42, 2, 3, 4, 5, 6, 7, 100, 200, 42]
  ```

要在数组中删除某个位置的元素，使用`splice!` 即可：

```
splice!(b,8) #> 100, b is now [42, 2, 3, 4, 5, 6, 7, 200, 42]
```

检查数组是否包含某个元素也易如反掌 ：

```
in(42, b) #> true , 
in(43, b) #> false
```

对数组排序，可用`sort!` 或 `sort`：前者将把排序后内容存于原数组， 后者原数组内容保持不变：

```
sort(b) #> [2,3,4,5,6,7,42,42,200], but b is not changed:
println(b) #> [42,2,3,4,5,6,7,200,42]
sort!(b) #>                                                    println(b) #> b is now changed to [2,3,4,5,6,7,42,42,200]
```

遍历数组，可用简单的for循环：

```
for e in arr
    print("$e ") 
end
```

如果点`.` 附加在操作符前，如`.+` 或`.*`，表示该计算操作是针对相对应的元素的。如，如果`a1 = [1, 2, 3]` 且 `a2 = [4, 5, 6]`，那么`a1 .* a2` 返回数组 `[4, 10, 18]`。换另一方式，计算向量点积可用`dot(a1, a2)`（得32），其结果与`sum(a1 .* a2)` 相等。

其它如`sin()` 这样的函数，可对数组每个元素进行计算，譬如`sin(a1)`。还有许多有用的方法，如`repeat([1, 2, 3], inner = [2])`, 产生 `[1,1,2,2,3,3]`。

`methodswith(Array)` 函数返回 358 个方法。您也可以在REPL 使用`help` 或 搜索文档以了解更多信息。

当您赋值一个数组给另一个数组，然后改变第一个数组的值，那么​​这两个数组都将改变。参见如后例子：

```
a = [1,2,4,6]
a1 = a
show(a1) #> [1,2,4,6]
a[4] = 0
show(a) #> [1,2,4,0]
show(a1) #> [1,2,4,0]
```

这是因为它们指向内存中的同一个对象。如果你不想这样，你必须创建该数组的一个副本。用`b = copy(a)` 即可。而如果数组`a` 中的某些元素也数组，则需要使用`b = deepcopy(a)` 以循环地深度拷贝。

如我们所见，相对于字符串来说数组是可变的，而作为函数参数它们是通过引用传递的。因此函数也就可以改变数组内容，如下例：

```
a = [1,2,3]
function change_array(arr)
  arr[2] = 25
end
change_array(a)
println(a) #>[ 1, 25, 3]
```

### 如何转换字符数组为字符串


假设我们有数组`arr = ['a', 'b', 'c']`。如何将所有字符拼成一个字符串？`join` 函数就可以：`join(arr)`返回字符串 `"abc"`; `utf32(arr)` 也可以。

`string(arr)` 这个函数则不行，它返回 `"['a', 'b', 'c']"`。但是 ，`string(arr...)` 却能得到`"abc"`。这是因为，`...`是拼接操作符(splice operator)（也称splat ）。它的功用是将数组内容当作独立的单个参数传入，而不是传递整个数组引用。


### 日期和时间

为了获得基本的时间信息，可以使用的`time()`函数返回如`1.408719961424e9` 的秒数。这个秒数是从Unix 系统纪元（1970年1月1日）到现在过去了多少秒。这有益于测量两个事件之间的时间间隔，例如，一个长时计算任务需要多久：

```
start_time = time()
# long computation
time_elapsed = time() - start_time
println("Time elapsed: $time_elapsed")
```

最有用的功能 `Libc.strftime(time())` 返回一形如“Sat Dec 12 23:37:51 2015”格式的字符串。

当用Julia 且想获得更多不只是大于等于0.3 的特性，可参见`Dates` 包。使用`Pkg.add("Dates")` 即可将其加入环境变量（ 这也将提供了`Dates` 模块文本相关的功能）。也有奎因·琼斯提供的`Time` 包。欲知详情，参见该文档[[https://github.com/quinnj/Datetime.jl/wiki/Datetime-Manual]]。

从Julia 0.4以后，使用内置于标准库`Dates` 模块：`Date` 用于日期， `DateTime` 用于精确到毫秒的时间。其他时区的功能可以通过 `Timezones.jl` 包添加。

`Date` 和`DateTime` 相关特性也可如下形式构建，或用只能获取更少信息的简版：

```
d = Date(2014,9,1) 返回 2014-09-01
dt = DateTime(2014,9,1,12,30,59,1) 返回 2014-09-01T12:30:59.001
```

这些对象可以被比较，求差以得到的时间间隔。日期相关的属性可以通过访问函数获取，如 `Dates.year(d), Dates.month(d), Dates.week(d),  Dates.day(d)`。其他有用的函数如：如`ayofweek, dayname, daysinmonth, dayofyear, isleapyear`等等。

### 作用域和常量

一个变量在程序中能被访问到的代码段，称作其作用域。目前为止，我们只了解了如何创建全局变量（在程序中的任何地方都可访问）。相比之下，局部范围内定义的变量只能在该范围内使用。局部范围的一个常见的​​例子是一个函数内部。全局变量常建议不用，原因之一便是是性能。如果值和类型可以在程序中随时更改，那编译器便无法优化这部分代码。

所以，限制一个变量的范围到局部最好。这可以通过将变量定义在函数或控制结构内部来完成，我们将在下面的章节中看到例子。如此，我们便能多次使用相同的变量名而不会产生名称冲突。

如后代码：

```
x = 1.0 # x is Float64
x = 1 # now x is Int
# y::Float64 = 1.0 # LoadError: "y is not defined"
function scopetest()
    println(x) # 1, x is known here, because it's in global scope
    y::Float64 = 1.0 # y must be Float64, this is not possible in global scope
end
scopetest()
println(y) #> ERROR: y not defined, only defined in scope of scopetest()
```

变量`x` 改变了它的类型，这是编译器允许的。但因为它使代码的类型不固定，也就可能产生性能问题。从第三行`y` 的定义中可以看到，类型注释仅仅可用在局部范围内（这里，在 `scopetest()`函数）。

一些代码结构定义支持局部变量的代码块儿。我们已经提到的函数块是这样的块儿，此外`for, while, try, let, type` 这些代码块儿也是支持局部作用域的。`for, while, try, let` 几个代码块儿中定义的变量，基本都是局部变量。只有当嵌入在另一个代码块儿，且外部代码块儿已定义同名变量时，该变量才不是内部代码块儿的局部变量（但是却是外部代码块儿的局部变量）。譬如：

```
function func() 
    a = 3
    for j = 10:11
        a = j # a 不是此for block 的局部变量
    end
    return a # 但a 是函数func() 的局部变量
end
```


如下的*复合表达式* ，不会引入新的作用域。一些（最好是短的）的子表达式可以拼在一个复合表达式里，你只需要以`begin`开头即可。见下例：

```
x = begin
  a = 5
  2 * a
end # now x is 10
println(a) #> a is 5 
```
`end` 之后，x 为10 和a 为 5。这也可以用`()`写作：

```
x = (a = 5; 2 * a)
```

复合表达式的值，是最后一个子表达式的值。复合表达式中声明的变量，表达式声明结束后仍然有效。

程序执行过程中不能更改的变量叫常量，用`const`声明 。换言之，它们是不可变的，其类型是编译器能推断的。以大写字母表示常量，是一个很好的习惯，就如：

```
const GC = 6.67e-11 # gravitational constant in m3/kg s2
```

Julia 定义了好些常量，比如`ARGS`（包含命令行参数的一个数组），`VERSION`（Julia 的版本），以及`OS_NAME`（操作系统名如Linux，Windows或Darwin），数学常数（如 `pi`和`e`）和日期时间常数（如``Friday, Fri, August, Aug`）。

如果你试图给一个全局常量赋予一个新的值，你会收到编译器的警告；但如果你改变它的类型，你会被提示出现错误，如下 所示：

```
julia> GC = 3.14
      Warning: redefining constant GC
julia> GC = 10
      ERROR: invalid redefinition of constant GC
``` 

常量只能赋值一次，并且它们的类型也不能改变，因此它们在VM 层面能被优化。如此，尽情的在全局范围内使用全局变量吧。

全局常量在类型方面表现得更有意思（其其保存固定的值却不尽然），因为已知确切类型的情况下，Julia 能更好的优化执行代码故而执行更快。但是，如果一个常量是一个可变的类型（ 如 `Array, Dict ` 参见 [第8章 I/O，网络和并行计算](./ch8/) ），那么你就无法将其更改为另一个不同的变量，但您可以随时更改该变量的内容：

```
julia> const ARR = [4,7,1]
julia> ARR[1] = 9
julia> show(ARR) #> [9,7,1]
julia> ARR = [1, 2, 3]
  Warning: redefining constant ARR
``` 

回顾一下本章习得，我们把玩了字符、字符串以及数组，基本如后续代码（`strings_arrays.jl`）：

```
# a newspaper headline:
str = "The Gold and Blue Loses a Bit of Its Luster"
println(str)
nchars = length(str)
println("The headline counts $nchars characters")
str2 = replace(str, "Blue", "Red")
#strings are immutable
println(str) # The Gold and Blue Loses a Bit of Its Luster
println(str2)
println("Here are the characters at position 25 to 30:")
subs = str[25:30]
print("-$(lowercase(subs))-") # "-a bit -"
println("Here are all the characters:")
for c in str
    println(c)
end
arr = split(str,' ')
show(arr)                                                         
#["The","Gold","and","Blue","Loses","a","Bit","of","Its","Luster"]
nwords = length(arr)
println("The headline counts $nwords words") # 10
println("Here are all the words:")
for word in arr
    println(word)
end
arr[4] = "Red"
show(arr) # arrays are mutable
println("Convert back to a sentence:")
nstr = join(arr, ' ')
println(nstr) # The Gold and Red Loses a Bit of Its Luster
# working with arrays:
println("arrays: calculate sum, mean and standard deviation ")
```



## 摘要

本章中，我们熟悉了Julia 的一些基本要素，如常量，变量和类型。我们还学习了如何使用基本类型，如数字、字符、字符串、范围以及非常灵活的数组类型。在下一章中，我们将深入函数的特性。大家也将发现，Julia 不愧是一个函数式语言。

