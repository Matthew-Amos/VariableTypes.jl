using VariableTypes
using Base.Test

@testset "Single value dispatch" begin
    @test vartype(1) === Discrete
    @test vartype(1.) === Continuous
    @test vartype(true) === Categorical
    @test vartype("a") === Categorical
end

@testset "Vector dispatch" begin
    @test vartype(repeat([1], inner=10)) === Discrete
    @test vartype(repeat([2.0], inner=15)) === Continuous
    a = Array{Any, 1}(); append!(a, 1); append!(a, 2); append!(a, 3.5)
    @test vartype(a, 2) === Discrete
    @test vartype([1, 2, 3, "a"]) === Categorical
    @test vartype([1, 2, 3.]) === Continuous
end

@testset "Matrix dispatch" begin
    a = Matrix{Any}(10, 3)
    a[:, 1] = rand(10)
    a[:, 2] = repeat([1, 2], inner=5)
    a[:, 3] = repeat(["A", "B"], inner=5)

    @test all(vartype(a, 1, 10) .=== [Continuous, Discrete, Categorical])
    @test all(vartype(a, 2) .=== repeat([Categorical], inner=10))
end
