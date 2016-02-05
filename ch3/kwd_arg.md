## 可选参数和命名参数

定义函数时，可以给一个或多个参数指定默认值，如 `f(arg = val)`。如果调用时没有显示传入某个参数比如arg， 那么 `val` 将被作为arg 的值。可选参数的位置，跟正常的参数一样很重要；这就是为什么它们被称为**可选位置参数**。如下是一个函数f 包含可选的参数b 的例子：

```julia
f(a, b = 5) = a + b
```

若调用`f(1)`，则返回6，`f(2, 5)`返回 7，和`f(3)`返回8。但是，调用`f()` 或`f(1,2,3)` 将出错，因为没有匹配的零个或三个参数的f 函数。这些参数仍仅由位置决定：调用 `f(2, b = 5) ` 将出错 `ERROR: function f does not accept keyword arguments`。

前面学到，参数还仅仅由位置决定。为了代码更清晰，通过名字来显式调用参数也就非常有用了。这样的参数被称作**可选命名参数**[^OKA]。由于参数给出了确切的的名称，那么其顺序也就无关紧要了。但他们必须放在参数列表的最后，并用分号`;` 与位置参数区别开，如下例：

```julia
k(x; a1 = 1, a2 = 2) = x * (a1 + a2)
```

现在`k(3, a2 = 3)`返回 12，`k(3, a2 = 3, a1 = 0)` 返回9（ 所以他们的位置并不重要），但`k(3) `返回 9（证明该命名参数是可选）。一般而言，可选的位置参数和命名参数可以做如下组合：

```julia
function allargs(normal_arg, optional_positional_arg=2; keyword_arg="ABC")
    print("normal arg: $normal_arg" - )
    print("optional arg: $optional_positional_arg" - )
    print("keyword arg: $keyword_arg")
end
```

如果我们调用`allargs(1, 3, keyword_arg=4)`它将打印：

```
normal arg: 1 - optional arg: 3 - keyword arg: 4
```

一个有用的例子是，当命名参数省略简写如下：

```julia
function varargs2(;args...)
    args
end
```

调用`varargs2(k1="name1", k2="name2", k3=7)` 将返回一个`Array{Any,1}` 类型的三元素数组的元素 ：`(:k1,"name1") (:k2,"name2") (:k3,7)`。现在，args 是键值对的一个列表，其中每个key 来自于命名参数对应的名称的集合，同时它也是一个以冒号`:`作前缀的符号（参照[第二章](../ch2/) 的字符串、变量、类型和基本运算）。


[^OPA]: optional positional arguments
[^OKA]: optional keyword arguments
