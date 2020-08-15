using Test, SimplePolynomials, Polynomials, Mods

a = SimplePolynomial(1, 1, 1)
b = SimplePolynomial(1, 2, 3)
c = SimplePolynomial(0, 1, -3, 4, 1)
x = getx()
p = (1 + x + x^3 - x^2)
q = (1 + 3x) * (1 - x) + 5

@testset "Polynomial Constructors" begin
    @test p == SimplePolynomial(1, 1, -1, 1)
    @test p == SimplePolynomial([1, 1, -1, 1])
    @test c == SimplePolynomial(c)
    @test c == SimplePolynomial(c.data)
    @test x + Mod{13}(2) == SimplePolynomial([Mod{13}(2), Mod{13}(1)])
end

@testset "Rational Function Constructors" begin
    f = p / q
    @test SimpleRationalFunction(p, q) == f
    @test f(1) == p(1) // q(1)
    f = inv(p)
    @test f(1) * p(1) == 1
end




@testset "Polynomial Arithmetic" begin
    @test a + a == 2a
    @test (a + a + a) / 3 == a
    @test a - a == 0
    @test a * a == SimplePolynomial(1, 2, 3, 2, 1)
    @test a * a * a == a^3
    @test eltype(b) == BigInt
end

@testset "Rational Function Arithmetic" begin
    f = p / q
    g = a / b
    @test f * g == (p * a) / (b * q)
    @test f + g == (p * b + a * q) // (b * q)
    @test f - g == (-g) + f
    @test f / g == (p * b) / (a * q)
    @test inv(f) == q / p
end

@testset "Complex numbers" begin
    z = a + im
    @test z(-5) == a(-5) + im
    f = (im + x) / (2 * im * x)
    @test 2f(1) == 1 - im
    z = (x-im)*(x+im)
    @test z == x^2 + 1
end

@testset "Mod numbers" begin
    z = SimplePolynomial(Mod{13}.([1,2,3]))
    @test z(1) == Mod{13}(6)
    f = inv(z)
    @test f(1) == inv(Mod{13}(6))
end

@testset "Polynomial GCD" begin
    p = (x-1)^2 * (x-2)
    q = (x-1) * (x-3)
    @test gcd(p,q) == x-1

    p = (x-1)^3 * (x-3)
    @test gcd(p,p') == (x-1)^2

    c = Mod{13}.(coeffs(p))
    p = SimplePolynomial(c)
    @test gcd(p,p') == (x-1)^2
end

# @testset "Size change" begin
#     # B = big(b)
#     @test B == b
#     @test eltype(B) == BigInt
#     @test eltype(small(B)) == Int

#     r = a/b
#     @test eltype(numerator(r)) == Rational{BigInt}
#     # r = big(r)
#     # @test eltype(denominator(r)) == Rational{BigInt}
# end

@testset "PolyCalculus" begin
    p = 3x // 2 - 5x^2 + (2 - im) * x^3
    @test derivative(integral(p)) == p
end

@testset "Mod Polys" begin
    p = SimplePolynomial(Mod{13}.(0:4))
    @test p(0) == Mod{13}(0)
    @test 2p == p + p
    @test 3 * (p / 3) + 1 == Mod{13}(1) + p
end

@testset "Rational Basics" begin
    f = a / b
    g = b / a
    @test f * g == 1
    @test 2f == (a + a) / b
    @test (f - g)^2 == f^2 - 2f * g + g^2
    @test (f / g)^2 == (f^2) // (g^2)
end

@testset "Rational derivative" begin
    f = inv(1 + x)
    g = derivative(f)
    @test g == -1 // (1 + x)^2
end

@testset "Rational Mod" begin
    x = getx(Mod{13})
    p = Mod{13}(1) + x
    q = Mod{13}(2) + 3x
    f = p / q
    @test f(0) == Mod{13}(1 // 2)
end

@testset "Functionize" begin
    x = getx()
    p = 3 + 5x + 8x^2
    P = make_function(p)
    @test p(10) == P(10)

    f = p / (1-x)
    F = make_function(f)
    @test F(10) == f(10)
    A = [ 2 3 ; 0 -1]
    p = -2 - x + x^2
    @test all(p(A).==0)
end



nothing
