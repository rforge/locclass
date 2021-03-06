\name{predict.wlda}
\alias{predict.wlda}
\title{Classify Multivariate Observations Based on Weighted Linear Discriminant Analysis}
\usage{
  \method{predict}{wlda} (object, newdata,
    prior = object$prior, ...)
}
\arguments{
  \item{object}{Object of class \code{"wlda"}.}

  \item{newdata}{A \code{data.frame} of cases to be
  classified or, if \code{object} has a \code{formula}, a
  \code{data.frame} with columns of the same names as the
  variables used.  A vector will be interpreted as a row
  vector.  If \code{newdata} is missing, an attempt will be
  made to retrieve the data used to fit the \code{wlda}
  object.}

  \item{prior}{The class prior probabilities. By default
  the proportions in the training data set.}

  \item{\dots}{Further arguments.}
}
\value{
  A list with components: \item{class}{The predicted class
  labels (a \code{factor}).} \item{posterior}{Matrix of
  class posterior probabilities.}
}
\description{
  Classify multivariate observations in conjunction with
  \code{\link{wlda}}.
}
\details{
  This function is a method for the generic function
  \code{predict()} for class \code{"wlda"}.  It can be
  invoked by calling \code{predict(x)} for an object
  \code{x} of the appropriate class, or directly by calling
  \code{predict.wlda(x)} regardless of the class of the
  object.
}
\examples{
library(mlbench)
data(PimaIndiansDiabetes)

train <- sample(nrow(PimaIndiansDiabetes), 500)

# weighting observations from classes pos and neg according to their
# frequency in the data set:
ws <- as.numeric(1/table(PimaIndiansDiabetes$diabetes)
    [PimaIndiansDiabetes$diabetes])

fit <- wlda(diabetes ~ ., data = PimaIndiansDiabetes, weights = ws,
    subset = train)
pred <- predict(fit, newdata = PimaIndiansDiabetes[-train,])
mean(pred$class != PimaIndiansDiabetes$diabetes[-train])
}
\seealso{
  \code{\link{wlda}}.
}
\keyword{classif}
\keyword{multivariate}

