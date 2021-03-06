\name{damultinom}
\alias{damultinom}
\title{Discriminant Adaptive Multinomial Log-linear Models}
\usage{
  damultinom(formula, data, weights, subset, na.action,
    contrasts = NULL, Hess = FALSE, censored = FALSE,
    model = FALSE, ...)
}
\arguments{
  \item{formula}{A formula expression as for regression
  models, of the form \code{response ~ predictors}. The
  response should be a factor or a matrix with K columns.
  If \code{censored = FALSE} this is required to be a
  zero-one indicator matrix. A log-linear model is fitted,
  with coefficients zero for the first class. An offset can
  be included: it should be a numeric matrix with K columns
  if the response is either a matrix with K columns or a
  factor with K > 2 classes, or a numeric vector for a
  response factor with 2 levels. See the documentation of
  \code{\link{formula}()} for other details.}

  \item{data}{An optional data frame in which to interpret
  the variables occurring in \code{formula}.}

  \item{weights}{Initial case weights in fitting (defaults
  to a vector of 1s).}

  \item{subset}{Expression saying which subset of the rows
  of the data should be used in the fit. All observations
  are included by default.}

  \item{na.action}{A function to filter missing data.}

  \item{contrasts}{A list of contrasts to be used for some
  or all of the factors appearing as variables in the model
  formula.}

  \item{Hess}{Logical for whether the Hessian (the
  observed/expected information matrix) should be
  returned.}

  \item{censored}{Logical. If the response is a matrix with
  \eqn{K > 2} classes, interpret the entries as one for
  possible classes, zero for impossible classes. Defaults
  to \code{FALSE}.}

  \item{model}{Logical. If \code{TRUE}, the model frame is
  saved as component \code{model} of the returned object.}

  \item{\dots}{Additional arguments for
  \code{\link{dannet}}, including the window function and
  bandwidth parameters used to generate observation
  weights: \describe{ \item{\code{wf}}{A window function
  which is used to calculate weights that are introduced
  into the fitting process. Either a character string or a
  function, e.g. \code{wf = function(x) exp(-x)}.  For
  details see the documentation for
  \code{\link[=biweight]{wfs}}.} \item{\code{bw}}{(Required
  only if \code{wf} is a string.) The bandwidth parameter
  of the window function. (See
  \code{\link[=biweight]{wfs}}.)} \item{\code{k}}{(Required
  only if \code{wf} is a string.) The number of nearest
  neighbors of the decision boundary to be used in the
  fitting process.  (See \code{\link[=biweight]{wfs}}.)}
  \item{\code{nn.only}}{(Required only if \code{wf} is a
  string indicating a window function with infinite support
  and if \code{k} is specified.) Should only the \code{k}
  nearest neighbors or all observations receive positive
  weights? (See \code{\link[=biweight]{wfs}}.)}
  \item{\code{itr}}{Number of iterations for model fitting,
  defaults to 3. See also the Details section.} }}
}
\value{
  A \code{"damultinom"} object (that inherits from
  \code{"\link{dannet}"} and \code{"\link[nnet]{nnet}"})
  with additional components: \item{deviance}{The residual
  deviance, compared to the full saturated model (that
  explains individual observations exactly).  Also, minus
  twice log-likelihood.} \item{edf}{The (effective) number
  of degrees of freedom used by the model.} \item{AIC}{The
  AIC for this fit.} \item{Hessian}{(if \code{Hess} is
  true).} \item{model}{(if \code{model} is true).}
}
\description{
  A local version of multinomial regression from package
  \pkg{nnet} that puts increased emphasis on a good model
  fit near the decision boundary.
}
\details{
  The idea of Hand and Vinciotti (2003) to put increased
  weight on observations near the decision boundary is
  generalized to the multiclass case and applied to
  multinomial regression. Since the decision boundary is
  not known in advance an iterative procedure is required.
  First, an unweighted multinomial regression model is
  fitted to the data. Based on the differences between the
  two largest estimated posterior probabilities observation
  weights are calculated. Then a weighted multinomial
  regression model (see \code{\link[nnet]{multinom}}) is
  fitted using these weights. Calculation of weights and
  model fitting is done several times in turn. The number
  of iterations is determined by the \code{itr}-argument
  that defaults to 3.

  The name of the window function (\code{wf}) can be
  specified as a character string. In this case the window
  function is generated internally in \code{damultinom}.
  Currently supported are \code{"biweight"},
  \code{"cauchy"}, \code{"cosine"}, \code{"epanechnikov"},
  \code{"exponential"}, \code{"gaussian"},
  \code{"optcosine"}, \code{"rectangular"} and
  \code{"triangular"}.

  Moreover, it is possible to generate the window functions
  mentioned above in advance (see
  \code{\link[=biweight]{wfs}}) and pass them to
  \code{damultinom}.

  Any other function implementing a window function can
  also be used as \code{wf} argument. This allows the user
  to try own window functions. See help on
  \code{\link[=biweight]{wfs}} for details.

  \code{damultinom} calls \code{\link{dannet}}. The
  variables on the rhs of the formula should be roughly
  scaled to [0,1] or the fit will be slow or may not
  converge at all.

  Observations weights that reflect the importance of
  training observations for the fit at a particular test
  observation are calculated internally in
  \code{damultinom}. For this reason not all types of
  response in \code{formula} are allowed and
  \code{damultinom} does not take all arguments that can be
  passed to \code{\link[nnet]{multinom}}. As response in
  \code{formula} factors and matrices are allowed. If
  \code{censored = FALSE} only zero-one class indicator
  matrices are allowed. Argument \code{summ} that specifies
  a method to summarize rows of the model matrix is missing
  since this requires adjustment of the case weights.
}
\examples{
fit <- damultinom(Species ~ Sepal.Length + Sepal.Width, data = iris, wf = "gaussian", bw = 0.5, Hess=TRUE)
pred <- predict(fit)
mean(pred$class != iris$Species)

fit <- damultinom(Species ~ Sepal.Length + Sepal.Width, data = iris, wf = "gaussian", bw = 0.5, weights=1:nrow(iris), trace=FALSE)
pred <- predict(fit)
mean(pred$class != iris$Species)
}
\references{
  Hand, D. J., Vinciotti, V. (2003), Local versus global
  models for classification problems: Fitting models where
  it matters, \emph{The American Statistician},
  \bold{57(2)} 124--130.

  Venables, W. N. and Ripley, B. D. (2002) \emph{Modern
  Applied Statistics with S.} Fourth edition.  Springer.
}
\seealso{
  \code{\link[nnet]{multinom}}, \code{\link{dannet}},
  \code{\link[nnet]{nnet}},
  \code{\link{predict.damultinom}}.
}
\concept{
  multiple logistic
}
\keyword{classif}
\keyword{models}
\keyword{neural}

