# Libraries
library(tidyverse)
library(ggplot2)

# Long-format dataset
students_long <- read_csv("necta/acsee_students_long_with_groups.csv")

# Filter for Songea Girls students
songea_girls <- students_long %>%
  filter(str_detect(toupper(exam_center), "SONGEA GIRLS")) %>%
  filter(!is.na(Score) & !is.na(Subject))


# Visual 1: Subject Group Performance Over Time
songea_group_perf <- songea_girls %>%
  group_by(YEAR, Subject_Group) %>%
  summarise(Avg_Score = mean(Score, na.rm = TRUE), .groups = "drop")

p_songea_group <- ggplot(songea_group_perf, aes(x = as.integer(YEAR), y = Avg_Score, color = Subject_Group)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Songea Girl's Performance by Subject Group (2014–2019)",
    x = "Year", y = "Average Score",
    color = "Subject Group"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("necta/songea_girls_group_perfo.png", plot = p_songea_group, width = 10, height = 5, dpi = 300)


# Visual 2:Top 5 Performing Subjects (All years)
top_subjects <- songea_girls %>%
  group_by(Subject) %>%
  summarise(Avg_Score = mean(Score, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(Avg_Score)) %>%
  slice_head(n = 5)

songea_top <- songea_girls %>%
  filter(Subject %in% top_subjects$Subject)

p_top_subjects <- songea_top %>%
  group_by(YEAR, Subject) %>%
  summarise(Avg_Score = mean(Score, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = as.integer(YEAR), y = Avg_Score, color = Subject)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Top 5 Performing Subjects – Songea Girls (2014–2019)",
    x = "Year", y = "Average Score"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("necta/songea_top_5_allyears.png", plot = p_top_subjects, width = 10, height = 5, dpi = 300)



# Visual 3: Performance by combinations 
# Normalize NECTA subject names
songea_girls <- songea_girls %>%
  mutate(Subject = case_when(
    Subject == "ADV/MATHS" ~ "Mathematics",
    Subject == "ENGLISH" ~ "English Language",
    Subject == "KISWAHILI" ~ "Kiswahili",
    Subject == "F & HN NUTRITION" ~ "Food and Human Nutrition",
    Subject == "ACCOUNTANCY" ~ "Accountancy",
    Subject == "COMMERCE" ~ "Commerce",
    Subject == "GEOGR" ~ "Geography",
    Subject == "PHYSICS" ~ "Physics",
    Subject == "BIOLOGY" ~ "Biology",
    Subject == "CHEMISTRY" ~ "Chemistry",
    Subject == "ECONOMICS" ~ "Economics",
    Subject == "HISTORY" ~ "History",
    Subject == "COMP/SCIENCE" ~ "Computer Science",
    Subject == "AGRICULTURE" ~ "Agriculture",
    Subject == "IS/KNOWLEDGE" ~ "Islamic Knowledge",
    Subject == "FRENCH" ~ "French",
    TRUE ~ Subject
  ))

# Define known combinations
combo_definitions <- list(
  PCM = c("Physics", "Chemistry", "Mathematics"),
  PCB = c("Physics", "Chemistry", "Biology"),
  PGM = c("Physics", "Geography", "Mathematics"),
  EGM = c("Economics", "Geography", "Mathematics"),
  CBG = c("Chemistry", "Biology", "Geography"),
  CBA = c("Chemistry", "Biology", "Agriculture"),
  CBN = c("Chemistry", "Biology", "Food and Human Nutrition"),
  HGL = c("History", "Geography", "English Language"),
  HGK = c("History", "Geography", "Kiswahili"),
  HKL = c("History", "Kiswahili", "English Language"),
  HGE = c("History", "Geography", "Economics"),
  ECA = c("Economics", "Commerce", "Accountancy"),
  PMC = c("Physics", "Mathematics", "Computer Science"),
  KLF = c("Kiswahili", "English Language", "French"),
  KFC = c("Kiswahili", "French", "Chinese"),
  KEC = c("Kiswahili", "English Language", "Chinese"),
  PBF = c("Physical Education", "Biology", "Fine Art"),
  PGE = c("Physical Education", "Geography", "Economics")
)

# Detect subject combinations from student subject lists
combo_df <- songea_girls %>%
  filter(Subject != "G/STUDIES") %>%
  group_by(CNO, YEAR) %>%
  summarise(subjects = list(sort(unique(Subject))), .groups = "drop") %>%
  rowwise() %>%
  mutate(
    Subject_Combo = {
      match_combo <- NA
      for (combo in names(combo_definitions)) {
        if (all(combo_definitions[[combo]] %in% subjects)) {
          match_combo <- combo
          break
        }
      }
      match_combo
    }
  ) %>%
  select(CNO, YEAR, Subject_Combo)

# Prepare for joining
combo_df <- combo_df %>%
  mutate(CNO = as.character(CNO), YEAR = as.character(YEAR))

songea_girls <- songea_girls %>%
  mutate(CNO = as.character(CNO), YEAR = as.character(YEAR))

# Merge inferred combinations into main dataset
songea_girls <- songea_girls %>%
  left_join(combo_df, by = c("CNO", "YEAR"))

# Count students per combination per year
combo_counts <- songea_girls %>%
  filter(!is.na(Subject_Combo)) %>%
  distinct(CNO, YEAR, Subject_Combo) %>%
  group_by(YEAR, Subject_Combo) %>%
  summarise(Students = n(), .groups = "drop")

# Plot the combination counts
comb <- ggplot(combo_counts, aes(x = as.integer(YEAR), y = Students, fill = Subject_Combo)) +
  geom_col(position = "dodge") +
  labs(
    title = "Subject Combination Exam Registration Trends",
    x = "Year",
    y = "Number of Students",
    fill = "Combination"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14)
  )

# Save the plot
ggsave("necta/songea_students_.png", plot = comb, width = 10, height = 5, dpi = 300)


# Visual 4: Subject Combination Performance Over Time
combo_perf <- songea_girls %>%
  filter(!is.na(Subject_Combo)) %>%
  group_by(YEAR, Subject_Combo) %>%
  summarise(Average_Score = mean(Score, na.rm = TRUE), .groups = "drop")

# Line plot of performance over time
combo_plot <- ggplot(combo_perf, aes(x = as.integer(YEAR), y = Average_Score, color = Subject_Combo)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Subject Combination Performance Over Time",
    x = "Year",
    y = "Average Score",
    color = "Combination"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14),
    legend.position = "right"
  )

# Save the plot
ggsave("necta/songea_combination_performance.png", plot = combo_plot, width = 10, height = 5, dpi = 300)


# Visual 5: Number of Students Per Year
students_per_year <- songea_girls %>%
  distinct(CNO, YEAR) %>%
  group_by(YEAR) %>%
  summarise(Students = n(), .groups = "drop")

p_students <- ggplot(students_per_year, aes(x = as.integer(YEAR), y = Students)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Number of Students Sitting Exams per Year(2014–2019)",
    x = "Year", y = "Number of Students"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("necta/songea_students_per_ye.png", plot = p_students, width = 10, height = 5, dpi = 300)










