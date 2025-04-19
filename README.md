# Songea Girls High School: A Five-Year Data-Driven Analysis of NECTA Performance (2014–2019)

This case study analyzes academic trends at Songea Girls High School using NECTA A-Level exam data (ACSEE) from 2014 to 2019. The dataset was compiled by Yusuph and made publicly available on Kaggle: [NECTA Test Results Dataset](https://www.kaggle.com/datasets/yusuph/necta-test-results).

As a graduate of the Songea Girls class of 2018 and now a data scientist, I revisited the performance data of my former school to understand long-term academic trends and uncover areas of improvement. The project simulates what it would be like to consult for an NGO focused on enhancing educational outcomes for girls in Tanzania.

---

## Objectives

- Analyze subject group performance across five academic years
- Identify top-performing subjects
- Track student enrollment by subject combination
- Evaluate performance trends per subject combination
- Estimate changes in total student participation over time

---

## Assumptions

- Grading standards were consistent across all years (2014–2019)
- Subject scores are proxies for both student comprehension and curriculum delivery quality

---

## Guiding Questions

- How strong was performance in Science and Arts over time?
- How did the class of 2018 compare to other years?
- Which subject groups need targeted support from administrators or education partners?

---

## Analytical Approach

- Merged and cleaned yearly NECTA ACSEE data using R
- Transformed wide-format datasets into long-form for flexible analysis
- Grouped subjects into five categories: Science, Math, Languages, Arts, and Business
- Created plots to visualize academic performance and enrollment patterns
- Focused exclusively on Songea Girls' data using filtering techniques and visual breakdowns

---

## Key Insights

### Subject Group Performance
- **Languages** improved steadily, peaking in 2019.
- **Science and Math** had moderate results, with a performance dip in 2016.
- A consistent decline was observed across all groups in 2016, likely due to systemic factors such as curriculum shifts or national exam changes.
- Performance rebounded from 2017 onward.

### Top 5 Performing Subjects
- **English** showed major growth from 2014 to 2019.
- **History** performance declined after peaking in 2015.
- Patterns highlight a need for targeted support in subjects with declining trends.

### Subject Combination Enrollment
- **CBG (Chemistry, Biology, Geography)** remained the most popular combination.
- **PCM (Physics, Chemistry, Mathematics)** had the lowest enrollment across all years.
- Growth in combinations like **HGL** and **EGM** indicates increasing interest in humanities and business streams.

### Subject Combination Performance
- **HGE** and **EGM** maintained strong average scores across years.
- **PCM** consistently underperformed, suggesting curriculum or support challenges.
- All combinations saw performance drops in 2016, aligning with broader national trends.

### Number of Students Per Year
- Student registration grew from just over 200 in 2014 to over 600 in 2017.
- A slight drop in 2018 may reflect cohort or policy factors.
- The increase in 2019 indicates recovery and continued support for girls' education.

---

## 🛠️ Tools & Technologies

- **R** (data cleaning, wrangling, and visualization)
- `tidyverse`, `ggplot2`, `dplyr`, `readr`
- Visualizations saved using `ggsave()`

---

## Project Structure

