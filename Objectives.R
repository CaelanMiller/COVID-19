library(readr)
library(tidyverse)
library(cowplot)

# Extract data of COVID cases
confirmed_US <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
deaths_US <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")

# Create tibble for plotting
data <- tibble(
  City = deaths_US$Admin2,
  State = confirmed_US$Province_State,
  Population = deaths_US$Population,
  Confirmation = confirmed_US$`5/28/21`,
  Deaths = deaths_US$`5/28/21`
)

# Define plot colors
plot_theme <- theme_bw() +
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    legend.title = element_blank()
  )

# Scatter plot: Population vs. Confirmed Counts
scatter_confirmed <- ggplot(data, aes(x = Population, y = Confirmation)) +
  geom_point(color = "darkblue") +
  labs(
    title = "Confirmations Vs. Population",
    x = "Population",
    y = "Confirmation Counts"
  ) +
  plot_theme +
  scale_y_continuous(trans = "log2", limits = c(16, 8388608), labels = scales::comma) +
  scale_x_continuous(trans = "log2", limits = c(128, 4194304), labels = scales::comma)

# Scatter plot: Confirmed Counts vs. Death Counts
scatter_deaths <- ggplot(data, aes(x = Confirmation, y = Deaths)) +
  geom_point(color = "darkred") +
  labs(
    title = "Deaths Vs. Confirmations",
    x = "Confirmed Counts",
    y = "Deaths Counts"
  ) +
  plot_theme +
  scale_y_continuous(trans = "log2", limits = c(8, 32768), labels = scales::comma) +
  scale_x_continuous(trans = "log2", limits = c(128, 4194304), labels = scales::comma)

# Arranging scatter plots using plot_grid
plot_grid(scatter_confirmed, scatter_deaths)

