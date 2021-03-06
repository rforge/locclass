\name{predict.kmc}
\alias{predict.kmc}
\title{K-means Classification}
\usage{
  \method{predict}{kmc} (object, newdata = NULL, ...)
}
\arguments{
  \item{object}{An object of class \code{"kmc"}.}

  \item{newdata}{A \code{data.frame} of cases to be
  classified or, if object has a \code{formula}, a
  \code{data.frame} with columns of the same names as the
  variables used. A vector will be interpreted as a row
  vector. If \code{newdata} is missing, an attempt will be
  made to retrieve the data used to fit the \code{kmc}
  object.}

  \item{\dots}{Further arguments. Currently unused.}
}
\value{
  A \code{list} with components: \item{class}{The predicted
  class labels (a \code{factor}).} \item{posterior}{Matrix
  of class posterior probabilities.}
}
\description{
  Classify multivariate observations using the prototype
  representation of the data obtained with the
  \code{\link{kmc}} function.
}
\details{
  Classification of a new observation is based on the
  prototypes found in the training data by function
  \code{\link{kmc}}.

  This function is a method for the generic function
  \code{predict()} for class \code{"kmc"}. It can be
  invoked by calling \code{predict(x)} for an object
  \code{x} of the appropriate class, or directly by calling
  \code{predict.kmc(x)} regardless of the class of the
  object.
}
\examples{
# generate waveform data
library(mlbench)
data.train <- as.data.frame(mlbench.waveform(300))
data.test <- as.data.frame(mlbench.waveform(200))

# prediction based on the nearest prototype
object <- kmc(classes ~ ., data = data.train, K = 3, wf = "rectangular", k = 1)
pred <- predict(object, data.test[,-22])
mean(pred$class != data.test$classes)

# prediction based on the 3 nearest prototpes with weighting
object <- kmc(classes ~ ., data = data.train, K = 3, wf = "gaussian", bw = 1, k = 3)
pred <- predict(object, data.test[,-22])
mean(pred$class != data.test$classes)
}
\references{
  T. Hastie, R. Tibshirani, and J. Friedman. The Elements
  of Statistical Learning: Data Mining, Inference, and
  Prediction. Springer Series in Statistics. Springer, New
  York, 2001.
}
\seealso{
  \code{\link{kmc}}.
}
\keyword{classif}
\keyword{multivariate}

