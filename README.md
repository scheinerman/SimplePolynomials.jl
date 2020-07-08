# SimplePolynomials

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

Note that extra zeros do not affect the result:
```
julia> SimplePolynomial(3,-2,0,1) == SimplePolynomial(3,-2,0,1,0,0)
true
```

## Basics

For a `SimplePolynomial` we have the following basic operations:
* `degree(p)` returns the degree of the polynomial (the zero polynomial
  returns `-1`).
* `p[k]` returns the coefficient of `x^k`. If `k` is larger than the degree,
then `0` is returned. The constant term is `p[0]`. An error is thrown if
`k` is negative. Note that `SimplePolynomial`s are immutable, so one cannot
assign to a coefficient; that is, `p[k]=c` does not work.
* `p(x)` evaluates the polynomial at `x` (`x` may be any `Number` type
  including floating point values).
* `coeffs(p)` returns (a copy of) the list of coefficients.
* `monic(p)` returns a new `SimplePolynomial` formed by dividing
all the coefficients by the leading term.


## Arithmetic

The standard operations of addition `+`, subtraction `-`, and
multiplication `*` can be performed on any two `SimplePolynomial`s,
or on a `SimplePolynomial` and an exact number.
Division of a `SimplePolynomial` by an exact number is also permitted.

The quotient of polynomials need not be a polynomial. However, we
implement the `divrem` function that returns a quotient and a remainder
for a pair of inputs. That is, if `q,r = divrem(a,b)` then we have that
`q*b+r==a` and `degree(r)<degree(b)`. Of course, `b` must not be zero.

## LCM and GCD

Given  `SimplePolynomial`s `a` and `b`, `gcd(a,b)` returns a greatest
common divisor of `a` and `b`. This is a polynomial of highest degree
that divides both `a` and `b` without remainder. Note that this is
not unique as a nonzero multiple of a GCD is also a GCD of the two
polynomials.

Similarly, `lcm(a,b)` returns a least common multiple of `a` and `b`.
As with `gcd`, this is not uniquely defined.

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





## To do

* The `show` function gives an unaesthetic output.
* Consider wrapping `gcd` and `lcm` in the `monic` function to give a
more predictable output.
* Consider creating an `integerize` function to clear denominators. This
may be tricky for `Complex` coefficient polynomials.
