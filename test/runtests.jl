using Test, SimplePolynomials, Polynomials, Mods

a = SimplePolynomial(1, 1, 1)
b = SimplePolynomial(1, 2, 3)
c = SimplePolynomial(0, 1, -3, 4, 1)
x = getx()
p = (1 + x + x^3 - x^2)
q = (1 + 3x) * (1 - x) + 5

@testset "Poly Construction" begin
    @test a(10) == 111
    @test a[0] == 1
    @test a[9] == 0
    @test lead(a) == 1
    @test a == 1 + x + x^2
    @test a * b == b * a
    @test a + b == b + a
    @test a - a == 0
    @test 2a - b == a + a + (-b)
end

@testset "Poly Arithmetic" begin
    @test a + a == 2a
    @test (a + a + a) / 3 == a
    @test a - a == 0
    @test a * a == SimplePolynomial(1, 2, 3, 2, 1)
    @test a * a * a == a^3
end

@testset "Complex Poly" begin
    z = a + im
    @test z(-5) == a(-5) + im
end

@testset "Poly Types" begin
    @test eltype(b) == Int
    @test eltype(b + im) == Complex{Int}
    @test eltype(b / (2im)) == Complex{Rational{Int}}
    @test eltype(big(b)) == BigInt
end

@testset "Poly GCD" begin
    @test gcd(a, b) == 1

    @test gcd(a * b, a * c) == a
    @test gcd(a^5, a^3) == a^3

    @test lcm(a * b, b * c) == monic(a * b * c)
    @test gcd(p, q) == 1
    @test gcd(p * p, q * q) == 1
end

@testset "Conversion" begin
    Pc = Polynomial(c)
    @test SimplePolynomial(Pc) == c
    @test roots(1 - x^2) == [-1; 1]
end

@testset "DivRem" begin
    q, r = divrem(c, a)
    @test q * a + r == c
end


@testset "Big/Small" begin
    @test small(big(3)) == 3
    @test typeof(small(big(3))) == typeof(3)
end


@testset "PolyCalculus" begin
    p = 3x // 2 - 5x^2 + (2 - im) * x^3
    @test derivative(integrate(p)) == p
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
    p = Mod{13}(1) + x
    q = Mod{13}(2) + 3x
    f = p / q
    @test f(0) == Mod{13}(1 // 2)
end


@test true
