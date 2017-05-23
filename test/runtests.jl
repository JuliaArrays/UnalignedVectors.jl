using UnalignedVectors
using Base.Test

ENDIAN_BOM == 0x04030201 || error("tests implemented only for little endian machines")

@testset "UnalignedVectors" begin
    @test_throws DimensionMismatch UnalignedVector{UInt16}([0x01, 0x02, 0x03])
    @test_throws ErrorException UnalignedVector{String}([0x01, 0x02])
    @test_throws MethodError UnalignedVector{UInt16}([1, 2])
    @test UnalignedVector{UInt16}([0x01, 0x02]) == [0x0201]

    a = collect(0x01:0x14)
    v = UnalignedVector{UInt16}(a)
    @test IndexStyle(v) == IndexLinear()
    @test length(v) == 10
    @test size(v) == (10,)
    for i = 1:10
        @test v[i] == (2i)<<8 + 2i - 1
    end
    @test_throws BoundsError v[0]
    @test_throws BoundsError v[11]
    for i = 1:10
        v[i] = i
    end
    @test v == collect(0x0001:0x000a)
    @test a == vec(vcat((0x01:0x0a)', zeros(UInt8,1,10)))
    @test_throws InexactError v[1] = 0xffffffff

    @test unaligned_reinterpret(UInt8, a) === a
    v = unaligned_reinterpret(Int16, a)
    @test v == collect(1:10)
    r = reinterpret(Int32, v, (1, 5))
    @test size(r) == (1, 5)
    for i = 1:5
        @test r[1,i] == 2i*2^16 + 2i - 1
    end
    r2 = reinterpret(UInt16, r, (10,))
    @test isa(r2, UnalignedVector{UInt16})
    @test isa(reinterpret(UInt8, r, (20,)), Vector{UInt8})
end

nothing
