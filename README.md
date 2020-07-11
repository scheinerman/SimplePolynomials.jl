# SimplePolynomials


[![Build Status](https://travis-ci.org/scheinerman/SimplePolynomials.jl.svg?branch=master)](https://travis-ci.org/scheinerman/SimplePolynomials.jl)

[![Coverage Status](https://coveralls.io/repos/scheinerman/SimplePolynomials.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/scheinerman/SimplePolynomials.jl?branch=master)

[![codecov.io](http://codecov.io/github/scheinerman/SimplePolynomials.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/SimplePolynomials.jl?branch=master)



This module defines the `SimplePolynomial` type. These are polynomials
with exact coefficients (integers, Gaussian integers, or Gaussian rationals).


## Construction

A `SimplePolynomial` is constructed by giving a list of its
coefficients starting with constant term (coefficient of `x^0`). The
coefficients must be one of these types: `Integer`, `Rational{Integer}`,
`Complex{Integer}`, or `Complex{Rational{Integer}}`.

For example, to create the polynomial `3 - 2x + x^3` we can do
either of the following:
* `SimplePolynomial([3, -2, 0, 1])`
* `SimplePolynomial(3,-2,0,1)`

In both cases, the result is `3 - 2*x + x^3`.

Note that extra zeros do not affect the result:
```
julia> SimplePolynomial(3,-2,0,1) == SimplePolynomial(3,-2,0,1,0,0)
true
```

#### Using `getx`

The function `getx()` is a short cut that returns
`SimplePolynomial(0,1)`. By assigning this to a variable named `x`
the creation of polynomials is very natural:
```
julia> x = getx()
x

julia> p = x^3 - 2x + 3
3 - 2*x + x^3
```



## Basics

For a `SimplePolynomial` we have the following basic operations:
* `degree(p)` returns the degree of the polynomial (the zero polynomial
  returns `-1`).
* `p[k]` returns the coefficient of `x^k`. If `k` is larger than the degree,
then `0` is returned. The constant term is `p[0]`. An error is thrown if
`k` is negative. Note that `SimplePolynomial`s are immutable, so one cannot
assign to a coefficient; that is, `p[k]=c` does not work.
* `p(x)` evaluates the polynomial at `x` (`x` may be any type
  including floating point values or another `SimplePolynomial`).
* `coeffs(p)` returns (a copy of) the list of coefficients.
* `monic(p)` returns a new `SimplePolynomial` formed by dividing
all the coefficients by the leading term.
* `eltype(p)` returns the data type of the coefficients.


## Arithmetic

The standard operations of addition `+`, subtraction `-`, and
multiplication `*` can be performed on any two `SimplePolynomial`s,
or on a `SimplePolynomial` and an exact number.
Division of a `SimplePolynomial` by an exact number is also permitted.

Exponentiation is also supported; one may raise a `SimplePolynomial`
to a nonnegative integer exponent:
```
julia> x = getx()
x

julia> for k=0:6
       println((1+x)^k)
       end
1
1 + x
1 + 2*x + x^2
1 + 3*x + 3*x^2 + x^3
1 + 4*x + 6*x^2 + 4*x^3 + x^4
1 + 5*x + 10*x^2 + 10*x^3 + 5*x^4 + x^5
1 + 6*x + 15*x^2 + 20*x^3 + 15*x^4 + 6*x^5 + x^6
```


The quotient of polynomials need not be a polynomial. However, we
implement the `divrem` function that returns a quotient and a remainder
for a pair of inputs. That is, if `q,r = divrem(a,b)` then we have that
`q*b+r==a` and `degree(r)<degree(b)`. Of course, `b` must not be zero.
```
julia> a = 3 + 5x - x^2 + x^3
3 + 5*x - x^2 + x^3

julia> b = x^2+1
1 + x^2

julia> q,r = divrem(a,b)
(-1 + x, 4 + 4*x)

julia> q*b + r == a
true
```

## GCD and LCM

Given  `SimplePolynomial`s `a` and `b`, `gcd(a,b)` returns a greatest
common divisor of `a` and `b`. This is a polynomial of highest degree
that divides both `a` and `b` without remainder. Note that this is
not unique as a nonzero multiple of a GCD is also a GCD of the two
polynomials.

Similarly, `lcm(a,b)` returns a least common multiple of `a` and `b`.
As with `gcd`, this is not uniquely defined.

To be sure that the result of these operations are consistent, the
results are wrapped in `monic` to ensure that the results
have leading coefficient equal to one.

## Roots

Use `roots(p)` to get a list of values `x` for which `p(x)==0`.
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

## Calculus

* `derivative(p)` returns the derivative of `p`. So does `p'`.
* `integrate(p)` returns the integral of `p` with constant term zero.

```
julia> p = 1 + 3x - 5x^2
1 + 3*x - 5*x^2

julia> derivative(p)
3 - 10*x

julia> integrate(ans)
3*x - 5*x^2
```


## Conversion to/from `Polynomial`

The `Polynomials` module also defines polynomials with many additional
properties. However, those polynomials allow floating point coefficients.
The purpose here is to enforce exactness.

Conversion between a `SimplePolynomial` type and a `Polynomial` type is
simple:
* If `p` is a `SimplePolynomial`, then `Polynomial(p)` is the corresponding
`Polynomial` type.
* If `p` is a `Polynomial`, the `SimplePolynomial(p)` returns its
`SimplePolynomial` version. However, this will not work if the coefficients
in `p` are floating point.
