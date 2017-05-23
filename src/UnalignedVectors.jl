module UnalignedVectors

export UnalignedVector, MaybeUnalignedVector, unaligned_reinterpret

struct UnalignedVector{T}
    a::Vector{UInt8}
end
# unsafe
@inline Base.getindex{T}(a::UnalignedVector{T}, i) = unsafe_load(Ptr{T}(pointer(a.a)), i)
@inline Base.length{T}(a::UnalignedVector{T}) = length(a.a) ÷ sizeof(T)
@inline unaligned_reinterpret{T}(::Type{T}, a::Vector{UInt8}) = UnalignedVector{T}(a)
@inline unaligned_reinterpret(::Type{UInt8}, a::Vector{UInt8}) = a
MaybeUnalignedVector{T} = Union{UnalignedVector{T},Vector{T}}

end
