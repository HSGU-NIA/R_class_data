# ------------------------
# --- INTRO TO R DAY 1 ---
# ------ TJ Butler -------
# ------------------------

# This is an R script
# Code can be mixed in with comments
# If you are guessing that these are comments,
# you would be right
# Comments start with the '#' character

# -------------------------
# --- WORKING DIRECTORY ---
# -------------------------
# The working directory is where input will be looked for and
# output will be saved (including the workspace, .RData)
getwd()
# setwd() is for changing the workspace

# ----------------
# --- PACKAGES ---
# ----------------
# Here is how we load the "tidyverse" packages we talked about
# This line downloads the packages
install.packages("tidyverse")

# This line tells the current R session to make them available
# during this R session:
library(tidyverse)

# What important functions did we just load?
# Let's ask the internet
#https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# --------------------
# --- LOADING DATA ---
# --------------------
# Note that we have to assign what we load in to an object,
# otherwise data is not stored
#
# Both '=' and '<-' can be used to store objects
practice.data = read_csv("RClass_Practice_Data.csv")

# ----------------------
# --- EXPLORING DATA ---
# ----------------------

# What kind of object is this?
class(practice.data)

# How many rows and columns does this have?
dim(practice.data)

# What are the first few values?
head(practice.data)

# The last few?
tail(practice.data)

# What does our data look like?
glimpse(practice.data)
View(practice.data)

# Get a flavor for the data: sample random rows










practice.data %>% sample_n(10, replace = FALSE)


# How many observations are Male?











practice.data %>% count(Sex == "M")

# How many "M" subjects do we have?










practice.data %>% filter(Sex == "M") %>% distinct(ID) %>% count

# How many people are under the age of 40? Cells vs. individuals?










# Cells
practice.data %>% filter(Age <= 39)


# Individuals
practice.data %>% filter(Age <= 39) %>% distinct
practice.data %>% filter(Age <= 39) %>% distinct(ID)



# What are some summary statistics for age?










practice.data %>% select(ID,Age) %>% distinct %>%
  summarize(avg.age = mean(Age),
            median.age = median(Age),
            age.range.low = min(range(Age)),
            age.range.high = max(range(Age)))

# How do we get average expression values of the 4 cell replicates to
# reduce our data set down in size?











practice.data.avg = practice.data %>% group_by(ID) %>%
  summarise(avg.exp.control.gene = mean(Control_Gene),
            avg.exp.gene1 = mean(Gene_1),
            avg.exp.gene2 = mean(Gene_2),
            avg.exp.gene3 = mean(Gene_3))

# Wait but we still want Sex and Age to be associated with the data??












practice.data %>%
  select(ID,Sex,Age) %>%
  distinct %>%
  left_join(practice.data.avg,
            practice.data,
            by = "ID") -> practice.data.avg.with.demo.data


# Let's arrange by your favorite variable (if your favorite variable is ID)












practice.data.avg.with.demo.data %>% arrange(ID) -> practice.data.avg.with.demo.data



# How do we write the output into a new csv file?
write_csv(x = practice.data.avg.with.demo.data,
          path = "practice_data_w_avg_expr.csv")
