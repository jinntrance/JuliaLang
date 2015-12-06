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


