# Main Effects: Palette and Baseline"

# load required library
library(lme4)
library(multcomp)
library(car)
source("http://www.math.mcmaster.ca/~bolker/classes/s756/labs/coefplot_new.R")

# filename = "../data/multi/results.csv"
# filename = "../data/ramp/results.csv"
filename = "../data/ucs/results.csv"

res <- read.csv(filename, sep=';')

# time follows a log-normal distribution
res$logTime <- log(res$time)
res$baseline <- as.factor(res$baseline)
res$ref <- as.factor(res$ref)

# rescale L*, LAB and UCS distance to be within [0, 1], otherwise the model will
# have very large eigenvalue and complains about being nearly unidentifiable.
res$lab_diff = res$lab_diff / 223
res$ucs_diff = res$ucs_diff / 173

# reorder palette factors
# res$palette = factor(res$palette, levels = c("blues", "blueorange", "jet", "viridis"))
# res$palette = factor(res$palette, levels = c("greys", "blues", "greens", "oranges"))
res$palette = factor(res$palette, levels = c("viridis", "magma", "plasma"))


# 1 Time

tm.pb = lmer(logTime ~ palette * baseline + (1 + palette * baseline | subject)
             + (1 | palette : ref), res)

summary(tm.pb)
coefplot(tm.pb, main="Time per palette and baseline")
Anova(tm.pb)

# likelihood ratio test
tm.pbml = lmer(logTime ~ palette * baseline + (1 + palette * baseline | subject)
               + (1 | palette : ref), res, REML=FALSE)

tm.null = lmer(logTime ~ 1 + (1 | subject) + (1 | palette : ref),
               res, REML = FALSE)

tm.p = lmer(logTime ~ palette + (1 + palette | subject)
            + (1 | palette : ref), res, REML=FALSE)

tm.b = lmer(logTime ~ baseline + (1 + baseline | subject)
            + (1 | palette : ref), res, REML=FALSE)

tm.i = lmer(logTime ~ palette + baseline + (1 + palette + baseline | subject)
            + (1 | palette : ref), res, REML=FALSE)

anova(tm.null, tm.p)
anova(tm.null, tm.b)
anova(tm.pbml, tm.i)

# post-hoc independent-samples t-tests
summary(glht(tm.pb, mcp(palette="Tukey")), test=adjusted(type="holm"))
summary(glht(tm.pb, mcp(baseline="Tukey")), test=adjusted(type="holm"))

# interaction
res$pxb = interaction(res$palette, res$baseline)
tm.posthoc = lmer(logTime ~ 1 + pxb + (1 | subject) + (pxb | subject)
                  + (1 | palette : ref), res)
summary(glht(tm.posthoc, mcp(pxb="Tukey")), test=adjusted(type="holm"))

# 2 Error

em.pb <- glmer(incorrect ~ palette * baseline + (1 + palette * baseline | subject)
               + (1 | palette : ref ),
               res, family = 'binomial')
summary(em.pb)
coefplot(em.pb, main="Accuracy per palette and baseline")

# post-hoc independent-samples t-tests
summary(glht(em.pb, mcp(palette="Tukey")), test=adjusted(type="holm"))
summary(glht(em.pb, mcp(baseline="Tukey")), test=adjusted(type="holm"))

# interaction
res$pxb = interaction(res$palette, res$baseline)
em.posthoc = glmer(incorrect ~ 1 + pxb + (1 | subject) + (pxb | subject)
                  + (1 | palette : ref),
                  res, family = 'binomial')
summary(glht(em.posthoc, mcp(pxb="Tukey")), test=adjusted(type="holm"))


# 3 Appendix

summary(glht(tm.posthoc, mcp(pxb="Tukey")))
summary(glht(em.posthoc, mcp(pxb="Tukey")))

summary(ranef(tm.pb)$subject)
summary(ranef(em.pb)$subject)
