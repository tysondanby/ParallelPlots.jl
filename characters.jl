function getcharRGBA(ch::Char,px::Int)
    if ch == ' '
        return fill(RGBA(1.0,1.0,1.0,0.0),Int(round((px+1)/2)),px)
    end
    c = CairoRGBSurface(2*px,px);
    cr = CairoContext(c);
    Cairo.save(cr);
    set_source_rgb(cr,1,1,1);
    rectangle(cr,0.0,0.0,2*px,px);
    fill(cr);
    restore(cr);
    Cairo.save(cr);
    select_font_face(cr, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL);
    set_font_size(cr, px);
    move_to(cr, 1, .75*px);
    show_text(cr, "$ch");
    t = Threads.threadid()
    write_to_png(c,"Temp\\"*"$t"*".png");
    charimg = load("Temp\\"*"$t"*".png")
    #column = 1
    #while charimg[:,column] == charimg[:,1]
    #    column =+ 1
    #end
    #buffer = column - 1
    column = size(charimg)[2]
    while charimg[:,column] == charimg[:,end]#TODO: This check keeps failing because Cairo sometimes fails to draw anything. like '4' at 84px
        column = column - 1
    end
    return RGBtoRGBA(charimg[:,1:column])
end



charlist = "0.123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-*/=<>:;,/?[]{}_!@#%^&*() "
defaultsizes = [100] #TODO: 10 and 12 seem to make Cairo fail. See if this can be fixed.
charRGBA = fill(getcharRGBA(charlist[1],defaultsizes[1]),(length(charlist),length(defaultsizes)))
Threads.@threads for i = 1:1:length(charlist) 
    for j = 1:1:length(defaultsizes)
        @inbounds charRGBA[i,j] = getcharRGBA(charlist[i],defaultsizes[j])
    end
end

foreach(rm, filter(endswith(".png"), readdir("Temp\\",join=true)))


function character(c::Char,h::Int) #TODO: make scale not necessarily an integer so that any font size can be chosen rather than jumping between ones.
    if typeof(findfirst(==(h),defaultsizes)) == Nothing
        return scaleimage(charRGBA[findfirst(==(c),charlist),end],h/defaultsizes[end])
    else
        return charRGBA[findfirst(==(c),charlist),findfirst(>=(h/scale),defaultsizes)]
    end
end
