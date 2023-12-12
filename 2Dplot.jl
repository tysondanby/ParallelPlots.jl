function plot(scene::twoDscene)
    image = fill(scene.background.color,(scene.wpx,scene.hpx))
    overwrite!(image,axestoimage(scene.axes,(scene.wpx,scene.hpx)))
    for i = 1:1:length(scene.primitives)
        overwrite!(image,primitivetoimage(scene.primitives[i],scene.axes,(scene.wpx,scene.hpx)))
    end
    for i = 1:1:length(scene.series)
        overwrite!(image,seriestoimage(scene.series[i],scene.axes,(scene.wpx,scene.hpx)))
    end
    for i = 1:1:length(scene.annotations)
        overwrite!(image,annotationtoimage(scene.annotations[i],scene.axes,(scene.wpx,scene.hpx)))
    end
    return image
end

