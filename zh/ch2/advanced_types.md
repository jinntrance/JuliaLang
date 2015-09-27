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
