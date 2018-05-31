install.packages("tesseract")
img <- image_read("http://jeroen.github.io/images/testocr.png")
print(img)
cat(image_ocr(img))

library(magick)
tiger <- image_read_svg('http://jeroen.github.io/images/tiger.svg', width = 400)
print(tiger)
image_write(tiger, path = "tiger.png", format = "png")
tiger_png <- image_convert(tiger, "png")
image_info(tiger_png)
image_display(tiger)#display
image_browse(tiger)

frink <- image_read("https://jeroen.github.io/images/frink.png")
print(frink)
image_border(image_background(frink, "hotpink"), "#000080", "20x10")
image_trim(frink)#trim borders
image_crop(frink, "100x150+50")#passportsize
image_scale(frink, "300") # width: 300px
image_scale(frink, "x300") # height: 300px
# Rotate or mirror
image_rotate(frink, 45)
image_flip(frink)#flipping img
image_flop(frink)#rotate
image_modulate(frink, brightness = 80, saturation = 120, hue = 90)
image_blur(frink, 10, 5)#blurrring
image_noise(frink)#noise
image_charcoal(frink)#bw
image_oilpaint(frink)
image_negate(frink)

kern <- matrix(0, ncol = 3, nrow = 3)
kern[1, 2] <- 0.25
kern[2, c(1, 3)] <- 0.25
kern[3, 2] <- 0.25
kern

img <- image_resize(logo, "300x300")
img
img_blurred <- image_convolve(img, kern)#convolving the image
img_blurred
imapp <- image_append(c(img, img_blurred))
image_browse(imapp)
#standard kernels
img %>% image_convolve('Sobel') %>% image_negate()
img %>% image_convolve('DoG:0,0,2') %>% image_negate()
#for text appending
image_annotate(frink, "I like R!", size = 70, gravity = "southwest", color = "green")
image_annotate(frink, "CONFIDENTIAL", size = 30, color = "red", boxcolor = "pink",
               degrees = 60, location = "+50+100")
image_annotate(frink, "The quick brown fox", font = 'Times', size = 30)

frink2 <- image_scale(frink, "100")
test <- image_rotate(frink, 90)
test <- image_background(test, "blue", flatten = TRUE)
test <- image_border(test, "red", "10x10")
test <- image_annotate(test, "This is how we combine transformations", color = "white", size = 30)
print(test)

earth <- image_read("https://jeroen.github.io/images/earth.gif")%>%
  image_scale("200x") %>%
  image_quantize(128)
earth  
head(image_info(earth))
rev(earth) %>% 
  image_flip() %>% 
  image_annotate("meanwhile in Australia", size = 20, color = "white")

bigdata <- image_read('https://jeroen.github.io/images/bigdata.jpg')
frink <- image_read("https://jeroen.github.io/images/frink.png")
logo <- image_read("https://jeroen.github.io/images/Rlogo.png")
img <- c(bigdata, logo, frink)
img <- image_scale(img, "300x300")
image_info(img)
image_mosaic(img)
image_flatten(img)
image_flatten(img, 'Add')
image_flatten(img, 'Modulate')
image_flatten(img, 'Minus')
#combining images
image_append(image_scale(img, "x200"))
image_append(image_scale(img, "100"), stack = TRUE)
bigdatafrink <- image_scale(image_rotate(image_background(frink, "none"), 300), "x200")
image_composite(image_scale(bigdata, "x400"), bigdatafrink, offset = "+180+100")
#reading pdf
manual <- image_read_pdf('https://cloud.r-project.org/web/packages/magick/magick.pdf', density = 72)
image_info(manual)
#animation
image_animate(image_scale(img, "200x200"), fps = 1, dispose = "previous")
newlogo <- image_scale(image_read("https://jeroen.github.io/images/Rlogo.png"), "x150")
oldlogo <- image_scale(image_read("https://developer.r-project.org/Logo/Rlogo-3.png"), "x150")
frames <- image_morph(c(oldlogo, newlogo), frames = 10)
image_animate(frames)

banana <- image_read("https://jeroen.github.io/images/banana.gif")
banana <- image_scale(banana, "150")
image_info(banana)
# Background image
background <- image_background(image_scale(logo, "200"), "white", flatten = TRUE)
# Combine and flatten frames
frames <- image_composite(background, banana, offset = "+70+30")
# Turn frames into animation
animation <- image_animate(frames, fps = 10)
print(animation)
image_write(animation, "Rlogo-banana.gif")
#on graph
fig <- image_graph(width = 400, height = 400, res = 96)
ggplot2::qplot(mpg, wt, data = mtcars, colour = cyl)
dev.off()
out <- image_composite(fig, frink, offset = "+70+30")
print(out)
#painting
# Or paint over an existing image
img <- image_draw(frink)
rect(20, 20, 200, 100, border = "red", lty = "dashed", lwd = 5)
abline(h = 300, col = 'blue', lwd = '10', lty = "dotted")
text(30, 250, "Hoiven-Glaven", family = "monospace", cex = 4, srt = 90)
palette(rainbow(11, end = 0.9))
symbols(rep(200, 11), seq(0, 400, 40), circles = runif(11, 5, 35),
        bg = 1:11, inches = FALSE, add = TRUE)
dev.off()
#graphics in plots
library(gapminder)
library(ggplot2)
img <- image_graph(600, 340, res = 96)
datalist <- split(gapminder, gapminder$year)
out <- lapply(datalist, function(data){
  p <- ggplot(data, aes(gdpPercap, lifeExp, size = pop, color = continent)) +
    scale_size("population", limits = range(gapminder$pop)) + geom_point() + ylim(20, 90) + 
    scale_x_log10(limits = range(gapminder$gdpPercap)) + ggtitle(data$year) + theme_classic()
  print(p)
})
dev.off()
out
#images on images
plot(as.raster(frink))
plot(cars)
rasterImage(frink, 21, 0, 25, 80)
#grid package
library(grid)
qplot(speed, dist, data = cars, geom = c("point", "smooth"))
grid.raster(frink)
#raster package
tiff_file <- tempfile()
image_write(frink, path = tiff_file, format = 'tiff')
r <- raster::brick(tiff_file)
raster::plotRGB(r)
