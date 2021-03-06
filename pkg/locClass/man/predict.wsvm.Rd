\name{predict.wsvm}
\alias{predict.wsvm}
\title{Predict New Examples by a Trained (Weighted) Support Vector Machine}
\usage{
  \method{predict}{wsvm} (object, newdata,
    decision.values = FALSE, probability = FALSE, ...,
    na.action = na.omit)
}
\arguments{
  \item{object}{Object of class \code{"wsvm"}, created by
  \code{wsvm}.}

  \item{newdata}{An object containing the new input data:
  either a matrix or a sparse matrix (object of class
  \code{\link[Matrix]{Matrix}} provided by the \pkg{Matrix}
  package, or of class \code{\link[SparseM]{matrix.csr}}
  provided by the \pkg{SparseM} package, or of class
  \code{\link[slam]{simple_triplet_matrix}} provided by the
  \pkg{slam} package). A vector will be transformed to a n
  x 1 matrix.}

  \item{decision.values}{Logical controlling whether the
  decision values of all binary classifiers computed in
  multiclass classification shall be computed and
  returned.}

  \item{probability}{Logical indicating whether class
  probabilities should be computed and returned. Only
  possible if the model was fitted with the
  \code{probability} option enabled.}

  \item{na.action}{A function to specify the action to be
  taken if \sQuote{NA}s are found. The default action is
  \code{na.omit}, which leads to rejection of cases with
  missing values on any required variable. An alternative
  is \code{na.fail}, which causes an error if \code{NA}
  cases are found. (NOTE: If given, this argument must be
  named.)}

  \item{\dots}{Currently not used.}
}
\value{
  A vector of predicted values (for classification: a
  vector of labels, for density estimation: a logical
  vector). If \code{decision.value} is \code{TRUE}, the
  vector gets a \code{"decision.values"} attribute
  containing a \eqn{n * c} matrix (\eqn{n} number of
  predicted values, \eqn{c} number of classifiers) of all
  \eqn{c} binary classifiers' decision values. There are
  \eqn{k * (k - 1) / 2} classifiers (\eqn{k} number of
  classes). The colnames of the matrix indicate the labels
  of the two classes. If \code{probability} is \code{TRUE},
  the vector gets a \code{"probabilities"} attribute
  containing a \eqn{n * k} matrix (\eqn{n} number of
  predicted values, \eqn{k} number of classes) of the class
  probabilities.
}
\description{
  This function predicts values based upon a model trained
  by \code{\link{wsvm}}.
}
\note{
  If the training set was scaled by \code{wsvm} (done by
  default), the new data is scaled accordingly using scale
  and center of the training data.
}
\seealso{
  \code{\link{wsvm}}, \code{\link[e1071]{predict.svm}},
  \code{\link[e1071]{svm}}.
}
\keyword{classif}
\keyword{neural}
\keyword{nonlinear}

