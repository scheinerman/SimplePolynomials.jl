using Test, SimplePolynomials, Polynomials, Mods

a = SimplePolynomial(1,1,1)
@test a(10) == 111
@test a[0] == 1
@test a[9] == 0
@test lead(a) == 1


@test a+a == 2a
@test (a+a+a)/3 == a
@test a-a == 0
@test a*a == SimplePolynomial(1,2,3,2,1)
@test a*a*a == a^3

b = a+im
@test b(-5) == a(-5)+im


b = SimplePolynomial(1,-2,1,7,4)
@test eltype(b) == Int
@test eltype(b+im) == Complex{Int}
@test eltype(b/(2im)) == Complex{Rational{Int}}
@test eltype(big(b)) == BigInt


@test a*b==b*a

@test gcd(a,b) == 1

c = SimplePolynomial(0,1,-3,4,1)

Pc = Polynomial(c)
@test SimplePolynomial(Pc) == c

@test gcd(a*b,a*c) == a
@test gcd(a^5, a^3) == a^3

@test lcm(a*b,b*c) == monic(a*b*c)


q,r = divrem(c,a)
@test q*a+r == c

x = getx()
p = (1+x+x^3-x^2)
q = (1+3x)*(1-x)+5
@test gcd(p,q) == 1
@test gcd(p*p, q*q) == 1

@test small(big(3)) == 3
@test typeof(small(big(3))) == typeof(3)

@test roots(1-x^2) == [-1 ; 1]

p = 3x//2 - 5x^2 + (2-im)*x^3
@test derivative(integrate(p)) == p

p =  SimplePolynomial(Mod{13}.(0:4))
@test p(0) == Mod{13}(0)
