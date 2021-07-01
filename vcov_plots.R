# this assumes that you're at the end of the main analysis script

library(GGally)
ps <- posterior_samples(exp2l1, pars="^b_", fixed=FALSE, add_chain=TRUE)

# I don't like the stargazing for the correlations
# (both in general and esp for model coefs), but this gives you an idea
# about the covariance of the estimates. This is similar to the
# "Correlation of Fixed Effects" in lme4
ggpairs(ps)

ps_long <- pivot_longer(ps,
                        cols = starts_with("b_"),
                        names_to = "coef",
                        names_prefix = "b_",
                        values_to = "value",
                        values_drop_na = TRUE)
ps_wide <- spread(ps_long, coef, value)
# this is a bit prettier and you get an impression of how much the coefficient
# estimates both for the same and for different dependent variables covary
ggpairs(ps_wide,
        columns=3:ncol(ps_wide), # skip chain and iter cols
        lower=list(continuous = "density"))
# because of the way the names sort, the cross-response correlations are in the
# corners -- there is some correlation, but it's not huge.


ps_long_by_dv <- separate(ps_long, coef, c("depvar", "coef"))
ps_wide_by_dv <- spread(ps_long_by_dv, coef, value)
ps_wide_by_dv$depvar <- factor(ps_wide_by_dv$depvar)
# this is treating the two models separately and just plotting them in the same grid
# for ease of space and to get an overall magnitude comparison on the diagonal
ggpairs(ps_wide_by_dv, aes(color=depvar),
        columns=4:ncol(ps_wide_by_dv), # skip chain and iter cols
        lower=list(continuous = "density"))
# for the first response (which consonant), the transition duration looks much more important
# for the second response (how many syllables), the vowel duration looks more important
# which I guess makes sense :)


