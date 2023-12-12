
import Base.+
function +(a::RGBA,b::RGBA)
    return RGBA(b.A*(b.R-a.R)+a.R,b.A*(b.G-a.G)+a.G,b.A*(b.B-a.B)+a.B,1)
end

function overwrite!(image1::Array{RGBA,2},image2::Array{RGBA,2})
    @assert size(image1) == size(image2)
    image1 = image1 + image2 #baselayer+overlay
end

function overwrite!(image1::Array{RGBA,2},image2::Array{RGBA,2},pos)
    #WARNING: assumes pos is inbounds of image1
    #TODO: I would love to speed this up using @inbounds, but right now, im not sure the user will always give inbound indicies.
    if pos+size(image2) - (1,1) <= size(image1)
        @inbounds image1[pos[1]:pos[1]+size(image2)[1],pos[2]:pos[2]+size(image2)[2]] = image1[pos[1]:pos[1]+size(image2)[1],pos[2]:pos[2]+size(image2)[2]] + image2
    elseif pos[1]+size(image2)[1] - 1 <= size(image1)[1]
        ny = size(image1)[2] -  pos[2] +1
        @inbounds image1[pos[1]:pos[1]+size(image2)[1],pos[2]:pos[2]+ ny - 1] = image1[pos[1]:pos[1]+size(image2)[1],pos[2]:pos[2]+ ny - 1] + image2[:,1:ny]
    elseif pos[2]+size(image2)[2] - 1 <= size(image1)[2]
        nx = size(image1)[2] -  pos[2] +1
        @inbounds image1[pos[1]:pos[1]+ nx - 1,pos[2]:pos[2]+size(image2)[2]] = image1[pos[1]:pos[1]+ nx - 1,pos[2]:pos[2]+size(image2)[2]] + image2[1:nx,:]
    else
        nx = size(image1)[2] -  pos[2] +1
        ny = size(image1)[2] -  pos[2] +1
        @inbounds image1[pos[1]:pos[1]+ nx - 1,pos[2]:pos[2]+ ny - 1] = image1[pos[1]:pos[1]+ nx - 1,pos[2]:pos[2]+ ny - 1] + image2[1:nx,1:ny]
    end
end

function RGBtoRGBA(a::T) where T <: Matrix
    return @. pixelRGBtoRGBA(a)
end

#TODO: allow way to specify transparent color, rather than it just being white.
function pixelRGBtoRGBA(a)
    return RGBA(1.0*a.r,1.0*a.g,1.0*a.b,(3.0-(a.r+a.g+a.b))/3.0)
end

function scaleimage(image::Array{RGBA,2},scale)
    
    #TODO: scale it here
end