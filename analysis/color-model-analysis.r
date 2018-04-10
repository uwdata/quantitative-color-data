library(lme4)

## DATA PREPARATION

# load data, log transform time
da <- read.csv('../data/multi/results.csv', sep=';')
da$logTime <- log10(da$time)
dm <- read.csv('../data/ucs/results.csv', sep=';')
dm <- dm[dm$subject != '59ab62d02ebd06097c6ad1f9',]
dm$logTime <- log10(dm$time)
ds <- read.csv('../data/ramp/results.csv', sep=';')
ds$logTime <- log10(ds$time)

# merge experimental results files into a single data frame
all <- data.frame(
  subject   = unlist(list(da$subject, dm$subject, ds$subject)),
  palette   = unlist(list(da$palette, dm$palette, ds$palette)),
  baseline  = as.factor(c(da$baseline, dm$baseline, ds$baseline)),
  ref       = as.factor(c(da$ref, dm$ref, ds$ref)),
  left      = as.factor(c(da$left, dm$left, ds$left)),
  right     = as.factor(c(da$right, dm$right, ds$right)),
  lab_diff  = c(da$lab_diff, dm$lab_diff, ds$lab_diff),
  ucs_diff  = c(da$ucs_diff, dm$ucs_diff, ds$ucs_diff),
  name_diff = c(da$name_diff, dm$name_diff, ds$name_diff),
  incorrect = c(da$incorrect, dm$incorrect, ds$incorrect),
  logTime   = c(da$logTime, dm$logTime, ds$logTime)
)

# compute quartiles for each color model difference
lb <- as.numeric(c(
  quantile(all$lab_diff, 0.25),
  quantile(all$lab_diff, 0.50),
  quantile(all$lab_diff, 0.75)
))
ub <- as.numeric(c(
  quantile(all$ucs_diff, 0.25),
  quantile(all$ucs_diff, 0.50),
  quantile(all$ucs_diff, 0.75)
))
nb <- as.numeric(c(
  quantile(all$name_diff, 0.25),
  quantile(all$name_diff, 0.50),
  quantile(all$name_diff, 0.75)
))

# add quartile bins as factor variables
all$lab_bin = as.factor(ifelse(all$lab_diff < lb[1], 'l1',
  ifelse(all$lab_diff < lb[2], 'l2',
  ifelse(all$lab_diff < lb[3], 'l3', 'l4'))))
all$ucs_bin = as.factor(ifelse(all$ucs_diff < ub[1], 'u1',
  ifelse(all$ucs_diff < ub[2], 'u2',
  ifelse(all$ucs_diff < ub[3], 'u3', 'u4'))))
all$name_bin = as.factor(ifelse(all$name_diff < nb[1], 'n1',
  ifelse(all$name_diff < nb[2], 'n2',
  ifelse(all$name_diff < nb[3], 'n3', 'n4'))))

## ERROR MODELS

# single factor continuous models

em.lab <- glmer(incorrect ~ lab_diff
    + (1 + lab_diff | subject)
    + (1 + lab_diff | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

em.ucs <- glmer(incorrect ~ ucs_diff
    + (1 + ucs_diff | subject)
    + (1 + ucs_diff | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

em.name <- glmer(incorrect ~ name_diff
    + (1 + name_diff | subject)
    + (1 + name_diff | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# single factor discrete models

em.bin.lab <- glmer(incorrect ~ lab_bin
    + (1 + lab_bin | subject)
    + (1 + lab_bin | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

em.bin.ucs <- glmer(incorrect ~ ucs_bin
    + (1 + ucs_bin | subject)
    + (1 + ucs_bin | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

em.bin.name <- glmer(incorrect ~ name_bin
    + (1 + name_bin | subject)
    + (1 + name_bin | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# multi-factor discrete models

em.bin.ucs_name.add <- glmer(incorrect ~ ucs_bin + name_bin
    + (1 + ucs_bin + name_bin | subject)
    + (1 + ucs_bin + name_bin | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

em.bin.ucs_name.full <- glmer(incorrect ~ ucs_bin * name_bin
    + (1 + ucs_bin * name_bin | subject)
    + (1 + ucs_bin * name_bin | palette),
  data = all,
  family = binomial(link = "logit"),
  control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# model comparisons

# compare continuous and discrete variants
anova(em.lab,  em.bin.lab)
anova(em.ucs,  em.bin.ucs)
anova(em.name, em.bin.name)

# compare discrete single-factor models
anova(em.bin.lab, em.bin.ucs, em.bin.name)

# compare discrete multi-factor models
anova(em.bin.ucs_name.add, em.bin.ucs_name.full)

# summary of additive model
summary(em.bin.ucs_name.add)

## TIME MODELS

# single factor continuous models

tm.lab <- lmer(logTime ~ lab_diff
    + (1 + lab_diff | subject)
    + (1 + lab_diff | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

tm.ucs <- lmer(logTime ~ ucs_diff
    + (1 + ucs_diff | subject)
    + (1 + ucs_diff | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

tm.name <- lmer(logTime ~ name_diff
    + (1 + name_diff | subject)
    + (1 + name_diff | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# single factor discrete models

tm.bin.lab <- lmer(logTime ~ lab_bin
    + (1 + lab_bin | subject)
    + (1 + lab_bin | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

tm.bin.ucs <- lmer(logTime ~ ucs_bin
    + (1 + ucs_bin | subject)
    + (1 + ucs_bin | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

tm.bin.name <- lmer(logTime ~ name_bin
    + (1 + name_bin | subject)
    + (1 + name_bin | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# multi-factor discrete models

tm.bin.ucs_name.add <- lmer(logTime ~ ucs_bin + name_bin
    + (1 + ucs_bin + name_bin | subject)
    + (1 + ucs_bin + name_bin | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

tm.bin.ucs_name.full <- lmer(logTime ~ ucs_bin * name_bin
    + (1 + ucs_bin * name_bin | subject)
    + (1 + ucs_bin * name_bin | palette),
  data = all, REML = FALSE,
  control = lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))

# model comparisons

# compare continuous and discrete variants
anova(tm.lab,  tm.bin.lab)
anova(tm.ucs,  tm.bin.ucs)
anova(tm.name, tm.bin.name)

# compare discrete single-factor models
anova(tm.bin.lab, tm.bin.ucs, tm.bin.name)

# compare discrete multi-factor models
anova(tm.bin.ucs_name.add, tm.bin.ucs_name.full)

# summary of additive model
summary(tm.bin.ucs_name.add)
