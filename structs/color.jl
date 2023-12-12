abstract type Color end

mutable struct RGBA{T} <: Color
    R::T
    G::T
    B::T
    A::T
end

