# The `SimplePolynomials` Module


[![Build Status](https://travis-ci.org/scheinerman/SimplePolynomials.jl.svg?branch=master)](https://travis-ci.org/scheinerman/SimplePolynomials.jl)

[![Coverage Status](https://coveralls.io/repos/scheinerman/SimplePolynomials.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/scheinerman/SimplePolynomials.jl?branch=master)

[![codecov.io](http://codecov.io/github/scheinerman/SimplePolynomials.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/SimplePolynomials.jl?branch=master)



This module defines two types:


* `SimplePolynomial`: These are polynomials
with exact coefficients (integers, rationals, Gaussian integers, Gaussian
rationals, or `Mod`s). The objective is exactness perhaps at the
expense of computational efficiency.
* `SimpleRationalFunction`: These are fractions whose numerator and
denominator are `SimplePolynomial`s.

## Caveat

The polynomials (and rational functions) in this module all have exact and
arbitrary size precision. That means there will not be rounding or overflow issues, but
the cost is performance. The `Polynomials` package is more efficient. 
Other computer algebra packages may perform better. 


# Basics

## Polynomials

A `SimplePolynomial` is a polynomial in one variable with exact
coefficients. There are a few options to create a `SimplePolynomial`:
```
julia> using SimplePolynomials

julia> p = SimplePolynomial([2,-4,1])
2 - 4*x + x^2

julia> p = SimplePolynomial(2,-4,1,0)
2 - 4*x + x^2
```
The `getx()` function returns `SimplePolynomial(0,1)`. Assigning that
result to a variable named `x` makes creating polynomials rather
natural.
```
julia> x = getx()
x

julia> p = 2 - 4x + x^2
2 - 4*x + x^2
```

Polynomial coefficients may also be rational numbers, Gaussian integers,
Gaussian rationals, or modular numbers.
```
julia> p = 3x^2 - im*x + 4
4 - im*x + 3*x^2

julia> p = (3//2)x^2 - 4
-4//1 + 3//2*x^2

julia> using Mods

julia> p = Mod{17}(3) - 2x^2
Mod{17}(3) + Mod{17}(15)*x^2
```
The coefficients of a `SimplePolynomial` may not be floating
point numbers.


### Coefficients

The coefficients of a `SimplePolynomial` can be accessed with the
`coeffs` function:
```
julia> p = 1 -5x + 11x^2 + 4x^3
1 - 5*x + 11*x^2 + 4*x^3

julia> coeffs(p)
4-element Array{Int64,1}:
  1
 -5
 11
  4
```
Use square brackets to retrieve a coefficient
associated with a given power:
```
julia> p[2]     # coefficient of x^2
11

julia> p[0]     # constant term, the zero index is allowed
1

julia> p[11]    # zero is returned if the index exceeds the degree
0

julia> p[-1]    # negative indices are not allowed
ERROR: index [-1] must be nonnegative
```
Note that a `SimplePolynomial` is an immutable object and one
may not change its coefficients.
```
julia> p = 3x^2 - 5x +1
1 - 5*x + 3*x^2

julia> p[1] = 6
ERROR: MethodError: no method matching setindex!(::SimplePolynomial, ::Int64, ::Int64)
```



The `degree` function returns the degree of the polynomial and
`lead` returns the coefficient of that term.
```
julia> degree(p)
3

julia> lead(p)
4
```

Nonzero constant polynomials have degree zero. The zero polynomial
should have degree `-∞` but this is not an `Int`, so we return `-1`.
This is also the only case in which `lead` returns `0`:
```
julia> p = SimplePolynomial(0)
0

julia> degree(p)
-1

julia> lead(p)
0
```

The function `monic(p)` returns a `SimplePolynomial` formed
by dividing all coefficients by the leading term:
```
julia> p = 4-8x + 2x^2
4 - 8*x + 2*x^2

julia> monic(p)
2 - 4*x + x^2

julia> p = 3x^2-5
-5 + 3*x^2

julia> monic(p)
-5//3 + x^2
```


The function `eltype` returns the Julia type of the coefficients.


## Rational Functions

A `SimpleRationalFunction` is the ratio of two polynomials:
```
julia> p = 3x + x^3
3*x + x^3

julia> q = 1-x+x^2
1 - x + x^2

julia> p/q
(3*x + x^3) / (1 - x + x^2)
```
A `SimpleRationalFunction` is always represented as
the ratio of relatively prime polynomials; that is, any
common factors between numerator and denominator are cancelled.
```
julia> p = (x-1)*(x-2)*(x-3)
-6 + 11*x - 6*x^2 + x^3

julia> q = (x-1)*(x+5)
-5 + 4*x + x^2

julia> p/q
(6 - 5*x + x^2) / (5 + x)
```
Furthermore, the denominator of a `SimpleRationalFunction` is always a
*monic* polynomial; that is, the leading coefficient is one.
```
julia> (x-3)/(2x^2-5)
(-3//2 + 1//2*x) / (-5//2 + x^2)
```
Of course, division by zero is forbidden:
```
julia> p = x^2-5;

julia> q = SimplePolynomial(0);

julia> p/q
ERROR: Denominator cannot be zero
```

### Numerator and denominator

Use `numerator` and `denominator` to extract the relevant
parts of a `SimpleRationalFunction`:
```
julia> f = (x^2 - 3x + 2) / (x-4)
(2 - 3*x + x^2) / (-4 + x)

julia> numerator(f)
2 - 3*x + x^2

julia> denominator(f)
-4 + x
```

### Three-line  printing

The `string3` function can be used to give a nice visualization
of a `SimpleRationalFunction`:
```
julia> f = (x^2 - 3x + 2) / (x-4)
(2 - 3*x + x^2) / (-4 + x)

julia> println(string3(f))
2 - 3*x + x^2
-------------
   -4 + x
```




# Operations



## Arithmetic

The usual operations of addition `+`, subtraction `-`, multiplication `*`,
and division `/` may be used with any combination of exact numbers,
polynomials, or rational functions.

Exponentiation by an integer power may be performed for any
`SimplePolynomial` or `SimpleRationalFunction`.

```
julia> p = 1+x
1 + x

julia> for k=-3:3
       println(p^k)
       end
1 / (1 + 3*x + 3*x^2 + x^3)
1 / (1 + 2*x + x^2)
1 / (1 + x)
1
1 + x
1 + 2*x + x^2
1 + 3*x + 3*x^2 + x^3
```

For polynomials, division results in a `SimpleRationalFunction`.
Alternatively, use `diverm` to find the quotient and remainder:
```
julia> a = 3x^3 + 5x -1
-1 + 5*x + 3*x^3

julia> b = x^2+3
3 + x^2

julia> (q,r) = divrem(a,b)
(3*x, -1 - 4*x)

julia> q*b + r == a
true
```


## Evaluation

Polynomials and rational functions behave as functions; they can be
evaluated as follows:
```
julia> p = 3x^2 + 5x +1
1 + 5*x + 3*x^2

julia> p(10)
351

julia> p(0.5)  # evaluation with a float is permitted
4.25

julia> f = p/(x+5)
(1 + 5*x + 3*x^2) / (5 + x)

julia> f(10)
117//5

julia> f(3.2 - 4.1im)   
4.575609756097562 - 9.812195121951218im
```

The argument of a polynomial or simple rational function may be a square matrix.
```
julia> A = [ 2 3 ; 0 -1];

julia> p = -2 - x + x^2;

julia> p(A)
2×2 Array{BigInt,2}:
 0  0
 0  0
```

The argument of a polynomial or rational function may itself
be a polynomial or a rational function.
```
julia> p = 3x^2 + 5x +1
1 + 5*x + 3*x^2

julia> q = 2x-3
-3 + 2*x

julia> p(q)
13 - 26*x + 12*x^2

julia> 3q^2 + 5q + 1
13 - 26*x + 12*x^2
```

Beware that multiplication requires the `*` symbol. Observe:
```
julia> (x^2-2)*(x-3)
6 - 2*x - 3*x^2 + x^3

julia> (x^2-2)(x-3)
7 - 6*x + x^2
```
In the second case, we are evaluating the function `(x^2-2)`
with the argument `(x-3)`:
```
julia> (x-3)^2 - 2
7 - 6*x + x^2
```

### Conversion to a function

Given `p`, the syntax `p(x)` evaluates `p` at `x`. Of course, `p`
is of type `SimplePolynomial` (or `SimpleRationalFunction`). If you
want a `Function` that evaluates `p`, use `make_function(p)`.
```
julia> x = getx();

julia> p = 5 + 2x + 4x^2
5 + 2*x + 4*x^2

julia> p(10)
425

julia> P = make_function(p)
#1 (generic function with 1 method)

julia> P(10)
425
```



## GCD and LCM

Given  `SimplePolynomial`s `a` and `b`, `gcd(a,b)` returns a greatest
common divisor of `a` and `b`. This is a polynomial of highest degree
that divides both `a` and `b` without remainder. Note that this is
not unique as a nonzero multiple of a GCD is also a GCD of the two
polynomials. The polynomial returned is always monic.

```
julia> p = (2x-1) * (x+5)
-5 + 9*x + 2*x^2

julia> q = (2x-1) * (x^2-4)
4 - 8*x - x^2 + 2*x^3

julia> gcd(p,q)
-1//2 + x
```



Similarly, `lcm(a,b)` returns a least common multiple of `a` and `b`.
As with `gcd`, this is not uniquely defined; we return a monic
least common multiple.
```
julia> lcm(p,q)
10//1 - 18//1*x - 13//2*x^2 + 9//2*x^3 + x^4
```




## Roots

For polynomials, `roots(p)` returns a list of values `x` for which `p(x)==0`.
These are floating point and so are likely not to be exact.
```
julia> p = x^2-x-1
-1 - x + x^2

julia> roots(p)
2-element Array{Float64,1}:
 -0.6180339887498948
  1.618033988749895

julia> p.(ans)
2-element Array{Float64,1}:
 -1.1102230246251565e-16
  2.220446049250313e-16
```

### Rational roots

The function `rational_roots` returns the set of all rational 
roots of a polynomial.
```
julia> p
15 - 13*x + 17*x^2 - 13*x^3 + 2*x^4

julia> roots(p)
4-element Array{Complex{Float64},1}:
 -3.885780586188048e-16 - 1.0000000000000009im
 -3.885780586188048e-16 + 1.0000000000000009im
     1.4999999999999993 + 0.0im
      5.000000000000005 + 0.0im

julia> rational_roots(p)
{3//2,5//1}
```

## Calculus

`derivative()` returns the derivative of a `SimplePolynomial`
or `SimpleRationalFunction`. We may also use `p'` for
`derivative(p)`.
```
julia> p = x^5 - 3x + 2
2 - 3*x + x^5

julia> derivative(p)
-3 + 5*x^4

julia> p'
-3 + 5*x^4

julia> f = (x^2-5)/(x+3)
(-5 + x^2) / (3 + x)

julia> f'
(5 + 6*x + x^2) / (9 + 6*x + x^2)
```





`integral(p)` returns the integral of `p` with constant term zero.

```julia>
p = 1 + 3x - 5x^2
1 + 3*x - 5*x^2

julia> integral(p)
x + 3//2*x^2 - 5//3*x^3

julia> derivative(ans)
1 + 3*x - 5*x^2
```

The integral of a rational funtion is not necessarily a rational
function; it is not implemented in this module.
```
julia> f = 1/(1+x^2)
1 / (1 + x^2)

julia> integral(f)
ERROR: MethodError: no method matching integral(::SimpleRationalFunction)
```


## Conversion between `SimplePolynomial` and  `Polynomial`

The `Polynomials` module also defines polynomials with many additional
properties. However, those polynomials allow floating point coefficients.

Conversion between a `SimplePolynomial`  and a `Polynomial`  is
simple:
* If `p` is a `SimplePolynomial`, then `Polynomial(p)` is the corresponding
`Polynomial` type.
* If `p` is a `Polynomial`, the `SimplePolynomial(p)` returns its
`SimplePolynomial` version. However, this will not work if the coefficients
in `p` are floating point.
