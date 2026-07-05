library(ggplot2)
library(hexSticker)

bg_blue <- "#74ACDF"       # Argentine flag color (background)
point_blue <- "#4A90D9"    # dot blue, darker for contrast
white <- "#FFFFFF"

set.seed(20250622)

df <- data.frame(
  group = rep("Senate", 300),
  y = c(
    runif(100, 0.7, 0.9),
    runif(100, 0.9, 1.1),
    runif(100, 1.1, 1.3)
  ),
  color = c(
    rep(point_blue, 100),
    rep(white, 100),
    rep(point_blue, 100)
  )
)

p <- ggplot(df, aes(x = group, y = y)) +
  geom_boxplot(width = 0.6, fill = "gray90", outlier.shape = NA, color = "gray40") +
  geom_jitter(aes(color = color), width = 0.2, size = 1.4, alpha = 0.9) +
  scale_color_identity() +
  theme_void() +
  coord_fixed(ratio = 1)

sticker(
  subplot = p,
  package = "senateaR",
  p_size = 20,
  p_color = "black",
  s_x = 1,
  s_y = 0.8,
  s_width = 1.7,
  s_height = 1.3,
  h_fill = bg_blue,
  h_color = "#003366",
  url = "https://github.com/vsntos/senateaR",
  u_color = "white",
  u_size = 3.5,
  u_x = 1,
  u_y = 0.08,
  filename = "man/figures/senateaR_hex_contrast.png"
)
