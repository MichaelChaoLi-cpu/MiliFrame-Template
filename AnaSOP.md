

# AnaSOP
Analysis Standard Operating Procedure

This document records the **human-designed analysis procedure** for the project.  
It explains the **research objective, conceptual framework, estimands, and analytical workflow**.

AnaSOP serves two purposes:

1. Guide researchers on how to reproduce and extend the analysis.
2. Provide contextual reasoning for automated research systems such as Jiazi.

This document may evolve as the research progresses.

---

# 1. Research Objective

The purpose of this project is to study **rural loneliness and social connection** using data from the **Global Flourishing Study**.

The project investigates whether residents living in rural environments experience different levels of **loneliness and social connectedness** compared with urban residents.

The central research questions are:

1. Do rural residents report different levels of **loneliness** compared with urban residents?
2. Do rural residents report different levels of **social support and interpersonal connection**?
3. Can differences in **social relationships** help explain rural–urban differences in loneliness and well-being?

The empirical goal is therefore to examine:

- the **association between place of residence and loneliness**, and  
- whether **social connection variables** help explain observed rural–urban differences.

The project is designed as an **observational associational study**, not a causal identification study.

---

# 2. Conceptual Framework and Literature Positioning

The analysis is motivated by emerging literature on **loneliness, social connection, and spatial inequality**.

While rural communities have historically been associated with stronger social ties, demographic and structural changes have altered rural social environments.

Three conceptual channels motivate the analysis.

---

## 2.1 Demographic and structural change

Many rural regions have experienced:

- population decline
- youth migration to cities
- aging populations
- declining public services

These changes may reduce social interaction opportunities and increase loneliness among rural residents.

---

## 2.2 Social support networks

Rural areas may still maintain stronger **interpersonal support networks**, such as:

- family ties
- neighbor relationships
- community networks

These social resources may protect individuals from loneliness.

The empirical analysis therefore focuses on **social support indicators** as potential mechanisms.

---

## 2.3 Social connection and well-being

Loneliness is widely linked to lower levels of:

- life satisfaction
- mental health
- overall well-being

Therefore, rural–urban differences in loneliness may contribute to broader differences in subjective well-being.

The conceptual framework is:

Place of residence  
↓  
Social support and interpersonal connection  
↓  
Loneliness  
↓  
Subjective well-being

---

# 3. Identification Strategy

## 3.1 Core design

The empirical strategy follows a **structured observational analysis** consisting of:

1. Measurement of loneliness outcomes.
2. Definition of rural–urban residence categories.
3. Measurement of social connection variables.
4. Adjustment for demographic and socioeconomic factors.
5. Inclusion of country fixed effects.

The baseline empirical model estimates the conditional association:

Y_i = β0 + β1 Rural_i + γX_i + δ_c + ε_i

where

- Y_i represents loneliness or related outcomes
- Rural_i represents rural residence
- X_i represents demographic controls
- δ_c represents country fixed effects

Additional models introduce **social support variables** to examine potential mechanisms.

---

## 3.2 Interpretation limits

This project does **not attempt to estimate causal effects**.

Reasons include:

1. The dataset is cross-sectional.
2. Current residence may not reflect long-term residence history.
3. Individuals may self-select into rural or urban environments.
4. Social support and loneliness are measured contemporaneously.

Therefore results should be interpreted as **associations**, not causal effects.

Language such as:

- association
- relationship
- adjusted difference

should be preferred over causal terminology.

---

## 3.3 Target estimands

The main estimands are:

1. The adjusted association between **rural residence and loneliness**.
2. The rural–urban difference in **social support indicators**.
3. The extent to which **social support variables account for rural–urban differences in loneliness**.

---

# 4. Key Variables and Estimands

## 4.1 Main outcome variable

Primary outcome:

**LONELY**

This variable measures the frequency of loneliness.

Coding principle:

higher values represent **lower loneliness**.

For interpretability, the variable may be reverse-coded:

Loneliness_i = max(LONELY) − LONELY_i

so that higher values indicate **greater loneliness**.

---

## 4.2 Secondary outcomes

Secondary outcomes include related well-being indicators such as:

- LIFE_SAT (life satisfaction)
- HAPPY (happiness)
- mental health indicators

These variables help examine the broader implications of loneliness.

---

## 4.3 Main explanatory variable

Primary explanatory variable:

**URBAN_RURAL**

Preferred main coding:

- Rural = categories 1 and 2 (rural area / farm, small town)
- Urban = categories 3 and 4 (suburb, large city)

This coding groups **rural areas and small towns** into a broader rural category and **suburbs and large cities** into the urban category. The goal is to capture the contrast between **non-urban communities** and **urbanized residential environments**.

Alternative specifications may include **four-category residence coding**:

1. Rural / farm  
2. Small town  
3. Suburb  
4. Large city

This allows more detailed spatial comparisons.

---

## 4.4 Mechanism variables

Two types of social relationship variables are considered.

### Social support indicators

Examples include:

- **CLOSE_TO** — presence of a close relationship
- **PEOPLE_HELP** — availability of people who can help in times of trouble

Coding principle:

higher values indicate **stronger perceived social support**.

---

### Social participation indicators

Examples include:

- participation in organizations
- volunteering activities
- helping strangers

These variables capture **social engagement and community participation**.

---

# 5. Social Connection Index Construction

To summarize multiple social support variables, a **Social Connection Index** may be constructed.

Procedure:

1. Select core social support variables.
2. Ensure consistent coding so higher values indicate stronger connection.
3. Standardize each variable.
4. Compute the average standardized score.

Formally:

SocialConnection_i = mean(z(Support1_i), z(Support2_i), z(Support3_i))

This index provides a summary measure of **perceived social connection**.

The index is treated as a **supplementary explanatory variable**.

---

# 6. Covariate Strategy

## 6.1 Principle

Control variables are selected using a **background adjustment approach**.

Variables are included if they plausibly relate to both:

- place of residence
- loneliness or well-being.

---

## 6.2 Core control variables

Baseline models include:

- Age
- Gender
- Education
- Employment status
- Marital status
- Income perceptions
- Country fixed effects

---

## 6.3 Variables treated cautiously

Variables closely related to emotional well-being should not automatically be included in baseline models.

Examples include:

- mental health variables
- happiness indices

These may appear in extended specifications.

---

# 7. Main Estimation Framework

## 7.1 Baseline regression

Loneliness_i = β0 + β1 Rural_i + γX_i + δ_c + ε_i

Interpretation:

β₁ represents the adjusted rural–urban difference in loneliness.

---

## 7.2 Social support models

Support_i = α0 + α1 Rural_i + γX_i + δ_c + ε_i

These models test whether rural residents report different levels of social support.

---

## 7.3 Mechanism models

Sequential models are estimated:

1. Baseline model  
2. + demographic controls  
3. + socioeconomic controls  
4. + social support variables  

If the rural coefficient decreases after including social support variables, this suggests a **potential mechanism**.

---

## 7.4 Heterogeneity analysis

Additional models may explore heterogeneity across:

- age groups (e.g., older adults)
- gender
- country groups

These analyses help understand whether rural loneliness patterns differ across populations.

---

# 8. Analytical Workflow

## Step 1 — Data Preparation

- Load Global Flourishing Study dataset
- Recode missing values
- Construct loneliness variable
- Construct rural–urban residence variable
- Construct social connection index

---

## Step 2 — Missing Data Review

- Recode DK / Refused responses as missing
- Inspect missingness patterns
- document sample sizes

---

## Step 3 — Descriptive Statistics

Produce:

- summary statistics
- rural–urban comparison tables
- distribution of loneliness

---

## Step 4 — Baseline Models

Estimate regression models comparing rural and urban respondents.

---

## Step 5 — Social Support Analysis

Examine rural–urban differences in social support variables.

---

## Step 6 — Mechanism Models

Add social support variables to evaluate explanatory channels.

---

## Step 7 — Robustness Checks

Robustness analysis may include:

- alternative outcome variables
- four-category residence coding
- weighted vs unweighted models

---

## Step 8 — Interpretation

Interpret findings in relation to:

- spatial inequality in social connection
- rural demographic change
- loneliness and well-being literature.

---

# 9. Standard Regression Table Structure

Recommended regression table structure:

Model 1 — Rural only  
Model 2 — + demographic controls  
Model 3 — + socioeconomic controls  
Model 4 — + country fixed effects  
Model 5 — + social support variables  
Model 6 — + social connection index

This structure allows readers to observe how the rural coefficient evolves across specifications.

---

# 10. Expected Outputs

Figures:

- loneliness distribution plots
- rural–urban comparison figures
- coefficient plots
- predicted margins plots

Tables:

- summary statistics
- rural–urban comparison table
- baseline regression table
- mechanism regression table
- robustness checks

Outputs will be exported to the **exports/** directory for Jiazi.

---

# 11. Relationship with Jiazi

The analysis repository provides artifacts to Jiazi through the **exports/** interface.

Exported artifacts include:

- figures
- tables
- reproducible scripts
- actionbrief.yaml

Jiazi uses these artifacts to:

- generate manuscript sections
- integrate empirical evidence
- assemble the research paper.

---

# 12. Human Debug Notes

This section records evolving research decisions, including:

- rural–urban coding choices
- loneliness variable construction
- social connection index revisions
- robustness results

These notes help maintain transparency and reproducibility.