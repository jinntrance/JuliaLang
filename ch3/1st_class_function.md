## 高阶函数及闭包

在本节中，我们将展示Julia 函数的奇妙与灵活。首先，函数有自己的类型在REPL键入`typeof(mult)` 返回`Function` 。函数也可以被赋值给一个变量：

```
julia> m = mult 
julia> m(6, 6) #> 36
```

这在匿名函数的使用过程中非常有用，如`c = x -> x + 2`, 或：

```
julia> plustwo = function (x)
                     x + 2
                 end
(anonymous function)
julia> plustwo(3)
5
```

操作符也是一个函数，只是它写在两个参数中间而已，形如`x + y` 等价于 `+(x, y)` 。实际上，执行时第一种形式会被解析成第二种形式。我们可以在REPL确认 `+(3, 4)` 返回7 和 而`typeof(+)`返回`Function` 。

一个函数的参数可以是另外一个函数 （ 或多个函数）， 如后定义的一个函数计算另一个函数`f` 的梯度 ：

```julia
function numerical_derivative(f, x, dx=0.01)
  derivative = (f(x+dx) - f(x-dx))/(2*dx)
  return derivative
end
```

上面这个函数就可以把匿名函数`f` 当作一个参数做如后调用`numerical_derivative(f, 1, 0.001)`:

```julia
f = x -> 2x^2 + 30x + 9
println(numerical_derivative(f, 1, 0.001)) #> 33.99999999999537 
```

函数的返回值也可以是另一个函数（或多个函数） 。如后代码中的函数返回值就是一个计算梯度的函数。

```julia
function derivative(f)
    return function(x)  
  # pick a small value for h
        h = x == 0 ? sqrt(eps(Float64)) : sqrt(eps(Float64)) * x
        xph = x + h
        dx = xph - x
        f1 = f(xph) # evaluate f at x + h
        f0 = f(x) # evaluate f at x
        return (f1 - f0) / dx  # divide by h
    end
end
```

如我们所见，上面都是比较好的匿名函数的实例。而如后则是返回返回两个匿名函数的例子：

```julia
function counter()
    n = 0
    () -> n += 1, () -> n = 0
end
```

我们可以将返回的函数赋值给另外的变量：`(addOne, reset) = counter()`；也注意到上例中`n` 是一个局部变量：

```
julia> n
ERROR: n not defined
```

当我们反复调用 addOne 时可见到如后结果：

```julia
addOne() #=> 1
addOne() #=> 2
addOne() #=> 3
reset()  #=> 0
```


如我们所见，在`counter` 函数里 ， 变量 n 只在匿名函数中使用，亦即只可在`addOne` 和`reset`中操作。这两个函数都是封闭式的使用 n，这就是为什么叫这闭包 。

柯里化（Currying, 也称偏函数应用[^PF]）是指：将一个多参数函数调用，变成一系列的单参数函数调用。下面是函数柯里化的例子：

```julia
function add(x)
    return function f(y)
        return x + y
    end
end
```

上例输出将是`add (generic function with 1 method)`。调用`add(1)(2)`得3。上例可更简洁地写作`add(x) = f(y) = x + y `。或者加入一个匿名函数 则为`add(x) = y -> x + y`。传递函数时柯里化是非常有用的，后面讲解 Map, filters, list comprehensions 的章节也将用到。

[^PF]: Partial Function