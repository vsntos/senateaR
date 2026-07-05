library(ggplot2)
library(hexSticker)

# Argentine flag colors
bg_blue <- "#74ACDF"       # background
point_blue <- "#3B83BD"    # dot blue
white <- "#FFFFFF"

# Data
set.seed(20250622)
df <- data.frame(
  group = rep("Senate", 300),
  y = c(
    runif(100, 0.7, 0.9),   # upper blue band
    runif(100, 0.9, 1.1),   # central white band
    runif(100, 1.1, 1.3)    # lower blue band
  ),
  color = c(
    rep(point_blue, 100),
    rep(white, 100),
    rep(point_blue, 100)
  )
)

# Base plot without boxplot
p <- ggplot(df, aes(x = group, y = y)) +
  geom_jitter(aes(color = color), width = 0.35, size = 2.3, stroke = 0.4, shape = 21, fill = NA) +
  scale_color_identity() +
  theme_void() +
  coord_fixed(ratio = 1.2)

# Hex sticker
sticker(
  subplot = p,
  package = "senateaR",
  p_size = 20,
  p_color = "white",
  p_family = "sans",
  s_x = 1,
  s_y = 0.85,
  s_width = 1.7,
  s_height = 1.2,
  h_fill = bg_blue,
  h_color = "#003366",
  url = "https://github.com/vsntos/senateaR",
  u_color = "white",
  u_size = 3.5,
  u_x = 1,
  u_y = 0.08,
  filename = "man/figures/senateaR_logo_final.png"
)
