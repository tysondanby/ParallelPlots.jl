include("color.jl")
abstract type Scene end

abstract type Axes end
abstract type Series end
abstract type Background end
abstract type Primitive end
abstract type Annotation end
abstract type Camera end

struct threeDscene{T} <: Scene
    axes::Axes
    series::Vector{Series}
    background::Background
    primitives::Vector{Primitive}
    lights::Vector{Light}
    annotations::Vector{Annotation}
    camera::Camera
end

struct twoDscene{T} <: Scene
    axes::Axes
    series::Vector{Series}
    background::Background
    primitives::Vector{Primitive}
    annotations::Vector{Annotation}
    hpx::Int
    wpx::Int
end

struct cylindricalaxes{T} <: Axes
    rlims::Tuple{T,T}
    zlims::Tuple{T,T}
    ticks::Tuple{Int16,Int16,Int16}#(r,theta,z)
    gridlines::Tuple{Int16,Int16,Int16}
    gridcolor::Tuple{RGBA,RGBA,RGBA}
    axiscolor::Tuple{RGBA,RGBA}#(r,z)
    renderaxis::Tuple{Bool,Bool}
end

struct euclidianaxes{T} <: Axes
    xlims::Tuple{T,T}
    ylims::Tuple{T,T}
    zlims::Tuple{T,T}
    ticks::Tuple{Int16,Int16,Int16}
    gridlines::Tuple{Int16,Int16,Int16}
    gridcolor::Tuple{RGBA,RGBA,RGBA}
    axiscolor::Tuple{RGBA,RGBA,RGBA}
    renderaxis::Tuple{Bool,Bool,Bool}
end

struct sphericalaxes{T} <: Axes
    rlims::Tuple{T,T}
    ticks::Tuple{Int16,Int16,Int16}#(r,theta,phi)
    gridlines::Tuple{Int16,Int16,Int16}
    gridcolor::Tuple{RGBA,RGBA,RGBA}
    axiscolor::RGBA#(r)
    renderaxis::Bool
end

struct pairs{T} <: Series
    xpts::Vector{T}
    ypts::Vector{T}
end

struct triplets{T} <: Series
    xpts::Vector{T}
    ypts::Vector{T}
    zpts::Vector{T}
end

struct twoDfunction{T} <: Series
    xpts::Vector{T}
    f::Function
end

struct threeDfunction{T} <: Series
    xpts::Vector{T}
    ypts::Vector{T}
    f::Function
end

struct monotonebackground <: Background
    color::RGBA
end

struct triangle{T1,T2} <: Primitive
    pts::Tuple{Vector{T1},Vector{T1},Vector{T1}}
    color::RGBA
    reflectivity::T2
    emissivity::T2
    texture::String
end

struct Sphere{T1,T2} <: Primitive
    pos::Vector{T1}
    r::T1
    color::RGBA
    reflectivity::T2
    emissivity::T2
    texture::String
end
#TODO: add more primitives

struct pointsource{T} <: Light
    pos::Vector{T}
    color::RGBA #A contains strength
end

struct uniformdirectionallight <: Light
    dir::Vector{T}
    color::RGBA
end

struct basicannotation{T} <: Annotation
    text::String
    pos::Vector{T}
    align::String
end

struct isometriccamera{T} <: Camera
    dir::Vector{T}
    h::T
    hpx::Int
    w::T
    wpx::Int
end

struct perspectivecamera{T} <: Camera
    pos::Vector{T}
    dir::Vector{T}
    hfov::T
    hpx::Int
    wfov::T
    wpx::Int
end