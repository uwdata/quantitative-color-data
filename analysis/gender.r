# load required library
library(lme4)
library(multcomp)
library(car)
source("http://www.math.mcmaster.ca/~bolker/classes/s756/labs/coefplot_new.R")

# 1 Merge files

dirs <- c("multi", "ramp", "ucs")
ress <- list()

for (k in 1:length(dirs)) {
  dir = dirs[k]
  fn.res = sprintf("../data/%s/results.csv", dir)
  fn.sub = sprintf("../data/%s/subjects.csv", dir)
  
  results <- read.csv(fn.res, sep=';')
  subjects <- read.csv(fn.sub, sep=';')
  res <- merge(x = results, y = subjects, by = "subject", all.x = TRUE)
  res<-res[, c("subject", "time", "gender", "palette", "baseline", "ref",
               "true_answer", "incorrect")]
  res$study = dir
  
  ress[[k]] = res
}

res<-rbind(ress[[1]], ress[[2]], ress[[3]])

# time follows a log-normal distribution
res$logTime <- log(res$time)
res$baseline <- as.factor(res$baseline)
res$ref <- as.factor(res$ref)

# drop missing response
res <- res[res$gender %in% c("Female", "Male", "Other"), ]


# 2 Gender & RT

tm.g = lmer(logTime ~ gender + (1 | subject) + (1 | study) 
            + (1 | palette : baseline : ref : true_answer), res)
summary(tm.g)$coef
coefplot(tm.g, main="Time per gender")
Anova(tm.g)

# post-hoc becasue we have "other"
summary(glht(tm.g, mcp(gender="Tukey")), test=adjusted(type="holm"))

# see the unexplained variances by experiment
ranef(tm.g)$study

# Gender & Error

em.g = glmer(incorrect ~ gender + (1 | subject) + (1 | study) 
            + (1 | palette : baseline : ref : true_answer), res, family = 'binomial')
summary(em.g)$coef
coefplot(em.g, main="Time per gender")

# post-hoc becasue we have "other"
summary(glht(em.g, mcp(gender="Tukey")), test=adjusted(type="holm"))

# see the unexplained variances by experiment
ranef(em.g)$study
