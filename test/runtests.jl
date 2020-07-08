using Test, SimplePolynomials

a = SimplePolynomial(1,1,1)
@test a(10) == 111
@test a[0] == 1
@test a[9] == 0


@test a+a == 2a
@test (a+a+a)/3 == a
@test a-a == 0
@test a*a == SimplePolynomial(1,2,3,2,1)

b = SimplePolynomial(1,-2,1,7,4)
@test a*b==b*a

@test monic(gcd(a,b)) == 1

c = SimplePolynomial(0,1,-3,4,1)

@test monic(gcd(a*b,a*c)) == a
@test monic(gcd(a^5, a^3)) == a^3

@test monic(lcm(a*b,b*c)) == monic(a*b*c)


q,r = divrem(c,a)
@test q*a+r == c
