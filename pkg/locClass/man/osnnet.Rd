\name{osnnet}
\alias{osnnet}
\alias{osnnet.default}
\alias{osnnet.formula}
\title{Observation Specific Neural Networks}
\usage{
  osnnet(x, ...)

  \method{osnnet}{formula} (formula, data, ..., subset,
    na.action, contrasts = NULL)

  \method{osnnet}{default} (x, y,
    wf = c("biweight", "cauchy", "cosine", "epanechnikov", "exponential", "gaussian", "optcosine", "rectangular", "triangular"),
    bw, k, nn.only = TRUE, size, Wts,
    mask = rep(TRUE, length(wts)), linout = FALSE,
    entropy = FALSE, softmax = FALSE, censored = FALSE,
    skip = FALSE, rang = 0.7, decay = 0, maxit = 100,
    trace = TRUE, MaxNWts = 1000, abstol = 1e-04,
    reltol = 1e-08, ...)
}
\arguments{
  \item{formula}{A \code{formula} of the form
  \code{response ~ x1 + x2 + \dots}.}

  \item{data}{A \code{data.frame} from which variables
  specified in \code{formula} are to be taken.}

  \item{x}{(Required if no \code{formula} is given as
  principal argument.) A \code{matrix} or \code{data.frame}
  or \code{Matrix}? containing the explanatory variables.}

  \item{y}{(Required if no \code{formula} is given as
  principal argument.) A \code{matrix} or \code{data.frame}
  of target values for examples.}

  \item{size}{Number of units in the hidden layer. Can be
  zero if there are skip-layer units.}

  \item{contrasts}{A list of contrasts to be used for some
  or all of the factors appearing as variables in the model
  formula.}

  \item{Wts}{Initial parameter vector. If missing chosen at
  random.}

  \item{mask}{Logical vector indicating which parameters
  should be optimized (default all).}

  \item{linout}{Switch for linear output units. Default
  logistic output units.}

  \item{entropy}{Switch for entropy (= maximum conditional
  likelihood) fitting. Default by least-squares.}

  \item{softmax}{Switch for softmax (log-linear model) and
  maximum conditional likelihood fitting. \code{linout},
  \code{entropy}, \code{softmax} and \code{censored} are
  mutually exclusive.}

  \item{censored}{A variant on \code{softmax}, in which
  non-zero targets mean possible classes. Thus for
  \code{softmax} a row of \code{(0, 1, 1)} means one
  example each of classes 2 and 3, but for \code{censored}
  it means one example whose class is only known to be 2 or
  3.}

  \item{skip}{Switch to add skip-layer connections from
  input to output.}

  \item{rang}{Initial random weights on [-\code{rang},
  \code{rang}].  Value about 0.5 unless the inputs are
  large, in which case it should be chosen so that
  \code{rang} * max(\code{|x|}) is about 1.}

  \item{decay}{Parameter for weight decay. Default 0.}

  \item{maxit}{Maximum number of iterations. Default 100.}

  \item{trace}{Switch for tracing optimization. Default
  \code{TRUE}.}

  \item{MaxNWts}{The maximum allowable number of weights.
  There is no intrinsic limit in the code, but increasing
  \code{MaxNWts} will probably allow fits that are very
  slow and time-consuming.}

  \item{abstol}{Stop if the fit criterion falls below
  \code{abstol}, indicating an essentially perfect fit.}

  \item{reltol}{Stop if the optimizer is unable to reduce
  the fit criterion by a factor of at least \code{1 -
  reltol}.}

  \item{wf}{A window function which is used to calculate
  weights that are introduced into the fitting process.
  Either a character string or a function, e.g. \code{wf =
  function(x) exp(-x)}.  For details see the documentation
  for \code{\link[=biweight]{wfs}}.}

  \item{bw}{(Required only if \code{wf} is a string.) The
  bandwidth parameter of the window function. (See
  \code{\link[=biweight]{wfs}}.)}

  \item{k}{(Required only if \code{wf} is a string.) The
  number of nearest neighbors of the decision boundary to
  be used in the fitting process.  (See
  \code{\link[=biweight]{wfs}}.)}

  \item{nn.only}{(Required only if \code{wf} is a string
  indicating a window function with infinite support and if
  \code{k} is specified.) Should only the \code{k} nearest
  neighbors or all observations receive positive weights?
  (See \code{\link[=biweight]{wfs}}.)}

  \item{\dots}{Arguments passed to or from other methods.}

  \item{subset}{An index vector specifying the cases to be
  used in the training sample. (NOTE: If given, this
  argument must be named.)}

  \item{na.action}{A function to specify the action to be
  taken if NAs are found. The default action is first the
  \code{na.action} setting of \code{\link{options}} and
  second \code{\link{na.fail}} if that is unset.  An
  alternative is \code{\link{na.omit}}, which leads to
  rejection of cases with missing values on any required
  variable. (NOTE: If given, this argument must be
  named.)???}
}
\value{
  An object of class \code{"osnnet.formula"} or
  \code{"osnnet"}, a \code{list} containing the following
  components: \item{x}{A \code{matrix} containing the
  explanatory variables.} \item{y}{If argument \code{y} was
  a factor a class inicator matrix, otherwise a
  \code{matrix} that contains \code{y} unchanged.}
  \item{...}{} \item{mask}{The \code{mask} vector used.}
  \item{maxit}{The \code{maxit} argument used.}
  \item{trace}{The \code{trace} argument used.}
  \item{abstol}{The \code{abstol} argument used.}
  \item{reltol}{The \code{reltol} argument used.}
  \item{lev}{If \code{y} is a factor the class labels
  (levels of \code{y}).} \item{wf}{The window function
  used. Always a function, even if the input was a string.}
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
  bandwidth is fixed.} \item{variant}{(Only if \code{wf} is
  a string or one of the window functions documented in
  \code{\link[=biweight]{wfs}} is used, for internal use
  only).  An integer indicating which weighting scheme is
  implied by \code{bw}, \code{k} and \code{nn.only}.}
  \item{call}{The (matched) function call.}
}
\description{
  A localized version of single-hidden-layer neural
  networks, possibly with skip-layer connections.
}
\details{
  This is a localized version of neural networks where a
  neural network is fitted for each test observation based
  on the training data near the trial point. It is based on
  the function \code{\link[nnet]{nnet}} from package
  \pkg{nnet}.

  The name of the window function (\code{wf}) can be
  specified as a character string. In this case the window
  function is generated internally in
  \code{\link{predict.osnnet}}. Currently supported are
  \code{"biweight"}, \code{"cauchy"}, \code{"cosine"},
  \code{"epanechnikov"}, \code{"exponential"},
  \code{"gaussian"}, \code{"optcosine"},
  \code{"rectangular"} and \code{"triangular"}.

  Moreover, it is possible to generate the window functions
  mentioned above in advance (see
  \code{\link[=biweight]{wfs}}) and pass them to
  \code{osnnet}.

  Any other function implementing a window function can
  also be used as \code{wf} argument. This allows the user
  to try own window functions. See help on
  \code{\link[=biweight]{wfs}} for details.

  If the predictor variables include factors, the formula
  interface must be used in order to get a correct model
  matrix.
}
\references{
  Czogiel, I., Luebke, K., Zentgraf, M. and Weihs, C.
  (2007), Localized linear discriminant analysis. In
  Decker, R. and Lenz, H.-J., editors, Advances in Data
  Analysis, volume 33 of Studies in Classification, Data
  Analysis, and Knowledge Organization, pages 133--140,
  Springer, Berlin Heidelberg.

  Ripley, B. D. (1996) \emph{Pattern Recognition and Neural
  Networks}. Cambridge.

  Venables, W. N. and Ripley, B. D. (2002) \emph{Modern
  Applied Statistics with S}. Fourth edition. Springer.
}
\seealso{
  \code{\link{predict.osnnet}}, \code{\link[nnet]{nnet}}.
}
\keyword{neural}

