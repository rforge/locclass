\name{dalr}
\alias{dalr}
\alias{dalr.data.frame}
\alias{dalr.default}
\alias{dalr.formula}
\alias{dalr.matrix}
\title{Discriminant Adaptive Logistic Regression}
\usage{
  dalr(X, ...)

  \method{dalr}{formula} (formula, data, weights, ...,
    subset, na.action)

  \method{dalr}{data.frame} (X, ...)

  \method{dalr}{matrix} (X, Y, weights = rep(1, nrow(X)),
    intercept = TRUE, ..., subset, na.action)

  \method{dalr}{default} (X, Y, thr = 0.5,
    wf = c("biweight", "cauchy", "cosine", "epanechnikov", "exponential", "gaussian", "optcosine", "rectangular", "triangular"),
    bw, k, nn.only = TRUE, itr = 3, intercept = TRUE,
    weights = rep(1, nrow(X)), ...)
}
\arguments{
  \item{formula}{A formula of the form \code{groups ~ x1 +
  x2 + \dots}, that is, the response is the grouping
  \code{factor} and the right hand side specifies the
  (non-\code{factor}) discriminators. Details concerning
  model specification are given in the documentation of
  \code{\link{glm}}.}

  \item{data}{A \code{data.frame} from which variables
  specified in \code{formula} are to be taken.}

  \item{X}{(Required if no \code{formula} is given as
  principal argument.) A \code{matrix} or \code{data.frame}
  or \code{Matrix} containing the explanatory variables.}

  \item{Y}{(Required if no \code{formula} is given as
  principal argument.) A \code{factor} specifying the class
  membership for each observation.}

  \item{thr}{The threshold value used to predict class
  membership, defaults to 0.5. See Details.}

  \item{wf}{A window function which is used to calculate
  weights that are introduced into the fitting process.
  Either a character string or a function, e.g. \code{wf =
  function(x) exp(-x)}. For details see the documentation
  for \code{\link[=biweight]{wfs}}.}

  \item{bw}{(Required only if \code{wf} is a string.) The
  bandwidth parameter of the window function. (See
  \code{\link[=biweight]{wfs}}.)}

  \item{k}{(Required only if \code{wf} is a string.) The
  number of nearest neighbors of the decision boundary to
  be used in the fitting process. (See
  \code{\link[=biweight]{wfs}}.)}

  \item{nn.only}{(Required only if \code{wf} is a string
  indicating a window function with infinite support and if
  \code{k} is specified.) Should only the \code{k} nearest
  neighbors or all observations receive positive weights?
  (See \code{\link[=biweight]{wfs}}.)}

  \item{itr}{Number of iterations for model fitting,
  defaults to 3. See also the Details section.}

  \item{intercept}{Should the model contain an intercept.
  passed to \code{\link{glm.fit}}, null.model.}

  \item{weights}{Initial observation weights (defaults to a
  vector of 1s).}

  \item{\dots}{Further arguments to \code{\link{glm}}.
  Currently "offset", "control", model, x, y, contrasts,
  start, etastart, mustart are supported.  family is
  "binomial", method?. Note that some of theses arguments
  only make sense when using the formula method, namely:
  ...?}

  \item{subset}{An index vector specifying the cases to be
  used in the training sample. (NOTE: If given, this
  argument must be named.)}

  \item{na.action}{The default is first, any
  \code{na.action} attribute of data, second a
  \code{na.action} setting of options, and third
  \code{na.fail} if that is unset The default is first, a
  \code{na.action} setting of options, and second
  \code{na.fail} if that is unset.}
}
\value{
  An object of class \code{"dalr"} inheriting from class
  \code{"glm"}, a list containing at least the following
  components:

  Values of \code{glm}: \item{coefficients}{A named vector
  of coefficients.} \item{residuals}{The working residuals,
  that is the residuals in the final iteration of the IWLS
  fit.  Since cases with zero weights are omitted, their
  working residuals are \code{NA}.}
  \item{fitted.values}{The fitted mean values, obtained by
  transforming the linear predictors by the inverse of the
  link function.} \item{rank}{The numeric rank of the
  fitted linear model.} \item{family}{The
  \code{\link{family}} object used.}
  \item{linear.predictor}{The linear fit on link scale.}
  \item{deviance}{Up to a constant, minus twice the
  maximized log-likelihood. Where sensible, the constant is
  chosen so that a saturated model has deviance zero.}
  \item{aic}{A version of Akaike's An Information
  Criterion, minus twice the maximized log-likelihood plus
  twice the number of parameters, computed by the aic
  component of the family. For binomial and Poison families
  the dispersion is fixed at one and the number of
  parameters is the number of coefficients. For gaussian,
  Gamma and inverse gaussian families the dispersion is
  estimated from the residual deviance, and the number of
  parameters is the number of coefficients plus one. For a
  gaussian family the MLE of the dispersion is used so this
  is a valid value of AIC, but for Gamma and inverse
  gaussian families it is not. For families fitted by
  quasi-likelihood the value is NA.}
  \item{null.deviance}{The deviance for the null model,
  comparable with deviance. The null model will include the
  offset, and an intercept if there is one in the model.
  Note that this will be incorrect if the link function
  depends on the data other than through the fitted mean:
  specify a zero offset to force a correct calculation.}
  \item{iter}{The number of iterations of IWLS used.}
  \item{weights}{A list of length \code{itr + 1}. The
  working weights, that is the observation weights in the
  final iteration of the IWLS fit.} \item{prior.weights}{A
  list of length \code{itr + 1}. The observation weights
  initially supplied, the first list element is a vector of
  1s if none were.} \item{df.residual}{The residual degrees
  of freedom.} \item{df.null}{The residual degrees of
  freedom for the null model.} \item{y}{If requested (the
  default) the y vector used. (It is a vector even for a
  binomial model.)} \item{x}{If requested, the model
  matrix.} \item{model}{If requested (the default), the
  model frame.} \item{converged}{Logical. Was the IWLS
  algorithm judged to have converged?}
  \item{boundary}{Logical. Is the fitted value on the
  boundary of the attainable values?} \item{call}{The
  (matched) function call.} \item{formula}{The formula
  supplied.} \item{terms}{The \code{\link{terms}} object
  used.} \item{data}{The data argument.} \item{offset}{The
  offset vector used.} \item{control}{The value of the
  control argument used.} \item{method}{The name of the
  fitter function used, currently always ~code{"glm.fit"}.}
  \item{contrasts}{(Where relevant) the contrasts used.}
  \item{xlevels}{(Where relevant) a record of the levels of
  the factors used in fitting.} \item{na.action}{(Where
  relevant) information returned by
  \code{\link{model.frame}} on the special handling of
  NAs.} Additionally, \code{dalr} returns \item{lev}{The
  class labels (the levels of \code{grouping}).}
  \item{thr}{The threshold used.} \item{itr}{The number of
  iterations used.} \item{wf}{The window function used.
  Always a function, even if the input was a string.}
  \item{bw}{(Only if \code{wf} is a string or was generated
  by means of one of the functions documented in
  \code{\link[=biweight]{wfs}}.)  The bandwidth used,
  \code{NULL} if \code{bw} was not specified.}
  \item{k}{(Only if \code{wf} is a string or was generated
  by means of one of the functions documented in
  \code{\link[=biweight]{wfs}}.)  The number of nearest
  neighbors used, \code{NULL} if \code{k} was not
  specified.} \item{nn.only}{(Logical. Only if \code{wf} is
  a string or was generated by means of one of the
  functions documented in \code{\link[=biweight]{wfs}} and
  if \code{k} was specified.) \code{TRUE} if only the
  \code{k} nearest neighbors recieve a positive weight,
  \code{FALSE} otherwise.} \item{adaptive}{(Logical.)
  \code{TRUE} if the bandwidth of \code{wf} is adaptive to
  the local density of data points, \code{FALSE} if the
  bandwidth is fixed.}
}
\description{
  A local version of logistic regression for classification
  that puts increased emphasis on a good model fit near the
  decision boundary.
}
\details{
  Local logistic regression (Hand and Vinciotti, 2003) is a
  modification of the standard logistic regression approach
  to discrimination. For discrimination a good fit of the
  model is required especially near the true decision
  boundary. Therefore weights are introduced into the
  fitting process that reflect the proximity of training
  points to the decision boundary. Let the class levels be
  0 and 1. The distance of a training observation \eqn{x}
  to the decision boundary is measured by means of the
  difference \eqn{P(1 | x) - thr} where \code{thr} is a
  threshold in \eqn{[0,1]}. Since \eqn{P(1 | x)} is not
  known in advance an iterative procedure is required. We
  start by fitting an unweighted logistic regression model
  to the data in order to obtain initial estimates of
  \eqn{P(1 | x)}. These are used to calculate the
  observation weights. Model fitting and calculation of
  weights is done several times in turn. By default, the
  number of iterations is limited to 3.

  The name of the window function (\code{wf}) can be
  specified as a character string. In this case the window
  function is generated internally in \code{dalr}.
  Currently supported are \code{"biweight"},
  \code{"cauchy"}, \code{"cosine"}, \code{"epanechnikov"},
  \code{"exponential"}, \code{"gaussian"},
  \code{"optcosine"}, \code{"rectangular"} and
  \code{"triangular"}.

  Moreover, it is possible to generate the window functions
  mentioned above in advance (see
  \code{\link[=biweight]{wfs}}) and pass them to
  \code{dalr}.

  Any other function implementing a window function can
  also be used as \code{wf} argument. This allows the user
  to try own window functions. See help on
  \code{\link[=biweight]{wfs}} for details.

  Internally, \code{\link{glm.fit}} with \code{family =
  binomial()} is used and the weights produced using
  \code{wf} are passed to \code{\link{glm.fit}} via its
  \code{weights} argument.

  If the predictor variables include factors, the formula
  interface must be used in order to get a correct model
  matrix.

  Warnings about non-integer #successes in a binomial glm
  are expected.
}
\examples{
# generate toy data set of Hand und Vinciotti (2003):
x1 <- x2 <- seq(0.1,1,0.05)
train <- expand.grid(x1 = x1, x2 = x2)
posterior <- train$x2/(train$x1 + train$x2)
y <- as.factor(sapply(posterior, function(x) sample(0:1, size = 1,
    prob = c(1-x,x))))
train <- data.frame(train, y = y)

par(mfrow = c(1,3))

# contours of true class posterior probabilities:
plot(train$x1, train$x2, col = y, pch = 19, main = "true posteriors")
contour(x1, x2, matrix(posterior, length(x1)), add = TRUE)

# 0.3-contour line fit of logistic regression:
glob.fit <- glm(y ~ ., data = train, family = "binomial")
plot(train$x1, train$x2, col = y, pch = 19, main = "global fit")
contour(x1, x2, matrix(glob.fit$fitted.values, length(x1)),
    levels = 0.3, add = TRUE)

# 0.3-contour line fit of local logistic regression:
loc.fit <- dalr(y ~ ., data = train, thr = 0.3, wf = "gaussian", bw = 0.2)
plot(train$x1, train$x2, col = y, pch = 19, main = "local fit")
contour(x1, x2, matrix(loc.fit$fitted.values, length(x1)),
    levels = 0.3, add = TRUE)


# specify wf as a character string:
dalr(y ~ ., data = train , thr = 0.3, wf = "rectangular", k = 50)

# use window function generating function:
rect <- rectangular(100)
dalr(y ~ ., data = train, thr = 0.3, wf = rect)

# specify own window function:
dalr(y ~ ., data = train, thr = 0.3, wf = function(x) exp(-10*x^2))


# generate test data set:
x1 <- runif(200, min = 0, max = 1)
x2 <- runif(200, min = 0, max = 1)
test <- data.frame(x1 = x1, x2 = x2)

pred <- predict(loc.fit, test)

prob <- test$x2/(test$x1 + test$x2)
y <- as.factor(sapply(prob, function(x) sample(0:1, size = 1,
    prob = c(1-x,x))))

mean(y != pred$class)
}
\references{
  Hand, D. J., Vinciotti, V. (2003), Local versus global
  models for classification problems: Fitting models where
  it matters, \emph{The American Statistician},
  \bold{57(2)} 124--130.
}
\seealso{
  \code{\link{predict.dalr}}, \code{\link{glm}},
  \code{\link{predict.glm}}.
}
\keyword{classif}
\keyword{model}
\keyword{multivariate}

