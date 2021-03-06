#  Copyright (C) 2011 J. Schiffner
#  Copyright (C) 1994-2004 W. N. Venables and B. D. Ripley
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 or 3 of the License
#  (at your option).
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/
#

#' A version of Linear Discriminant Analysis that can deal with observation weights.
#'
#' The formulas for the weighted estimates of the class means, the covariance matrix and the class priors are as follows:
#'
#' Normalized weights: if \eqn{x_n} is in class g, i. e. \eqn{y_n = g}
#' \deqn{w_n^* = \frac{w_n}{\sum_{n:y_n=g} w_n}}{w_n* = w_n/sum_{n:y_n=g} w_n}
#' Weighted class means:
#' \deqn{\bar x_g = \sum_{n:y_n=g} w_n^* x_n}{bar x_g = sum_{n:y_n=g} w_n* x_i}
#' Pooled weighted class covariance matrix:
#' \deqn{S_g = \sum_{n:y_n=g} w_n^* (x_n - \bar x_g)(x_n - \bar x_g)'}{S_g = sum_{n:y_n=g} w_n* (x_n - bar x_g)(x_n - bar x_g)'}
#' \code{method = "ML"}:
#' \deqn{S = \sum_g p_g S_g}{S = sum_g p_g S_g}
#' \code{method = "unbiased"}:
#' \deqn{S = \frac{\sum_g p_g S_g}{1 - \sum_g p_g \sum_{n:y_n=g} w_n^{*2}}}{S = sum_g p_g S_g/(1 - sum_g p_g sum_{n:y_n=g} w_n*^2)}
#' Weighted prior probabilities:
#' \deqn{p_g = \frac{\sum_{n:y_n=g} w_n}{\sum_n w_n}}{p_g = \sum_{n:y_n=g} w_n/\sum_n w_n}
#'
#' If the predictor variables include factors, the formula interface must be used in order 
#' to get a correct model matrix.
#'
#' @title Weighted Linear Discriminant Analysis
#'
#' @param formula A \code{formula} of the form \code{groups ~ x1 + x2 + \dots}, that is, the response
#' is the grouping \code{factor} and the right hand side specifies the (non-\code{factor})
#' discriminators.  
#' @param data A \code{data.frame} from which variables specified in \code{formula} are to be taken.
#' @param x (Required if no \code{formula} is given as principal argument.) A \code{matrix} or \code{data.frame} or \code{Matrix} containing the explanatory variables.
#' @param grouping (Required if no \code{formula} is given as principal argument.) A \code{factor} specifying
#' the class membership for each observation.
#' @param weights Observation weights to be used in the fitting process, must be larger or equal to zero.
#' @param method Method for scaling the pooled weighted covariance matrix, either \code{"unbiased"} or maximum-likelihood (\code{"ML"}). Defaults to \code{"unbiased"}.
#' @param ... Further arguments.
#' @param subset An index vector specifying the cases to be used in the training sample. (NOTE: If given, this argument must be named.) 
#' @param na.action A function to specify the action to be taken if NAs are found. The default action is first
#' the \code{na.action} setting of \code{\link{options}} and second \code{\link{na.fail}} if that is unset. 
#' An alternative is \code{\link{na.omit}}, which leads to rejection of cases with missing values on any required 
#' variable. (NOTE: If given, this argument must be named.)
#'
#' @return An object of class \code{"wlda"}, a \code{list} containing the following components:
#'   \item{prior}{Weighted class prior probabilities.}
#'   \item{counts}{The number of observations per class.}
#'   \item{means}{Weighted estimates of class means.}
#'   \item{cov}{Weighted estimate of the pooled class covariance matrix.}
#'   \item{lev}{The class labels (levels of \code{grouping}).}  
#'   \item{N}{The number of observations.}
#'   \item{weights}{The observation weights used in the fitting process.}
#' 	 \item{method}{The method used for scaling the pooled weighted covariance matrix.}
#'   \item{call}{The (matched) function call.}
#'
#' @seealso \code{\link{predict.wlda}} and \code{\link{dalda}} which is based on \code{\link{wlda}}.
#'
#' @examples
#' library(mlbench)
#' data(PimaIndiansDiabetes)
#' 
#' train <- sample(nrow(PimaIndiansDiabetes), 500)
#' 
#' # weighting observations from classes pos and neg according to their 
#' # frequency in the data set:
#' ws <- as.numeric(1/table(PimaIndiansDiabetes$diabetes)
#'     [PimaIndiansDiabetes$diabetes])
#' 
#' fit <- wlda(diabetes ~ ., data = PimaIndiansDiabetes, weights = ws, 
#'     subset = train)
#' pred <- predict(fit, newdata = PimaIndiansDiabetes[-train,])
#' mean(pred$class != PimaIndiansDiabetes$diabetes[-train])
#'
#' @keywords classif multivariate
#'
#' @aliases wlda wlda.data.frame wlda.default wlda.formula wlda.matrix
#'
#' @export

wlda <- function(x, ...)
	UseMethod("wlda")
	
	
	
#' @rdname wlda
#' @method wlda formula
#'
#' @S3method wlda formula

wlda.formula <- function(formula, data, weights = rep(1, nrow(data)), ..., subset, na.action) {
    m <- match.call(expand.dots = FALSE)
    m$... <- NULL
    m[[1L]] <- as.name("model.frame")
    m$weights <- weights
    m <- eval.parent(m)
    Terms <- attr(m, "terms")
    weights <- model.weights(m)
    grouping <- model.response(m)
    x <- model.matrix(Terms, m)
    xint <- match("(Intercept)", colnames(x), nomatch = 0L)
    if (xint > 0) 
        x <- x[, -xint, drop = FALSE]
    res <- wlda.default(x, grouping, weights = weights, ...)
    res$terms <- Terms
    cl <- match.call()
    cl[[1L]] <- as.name("wlda")
    res$call <- cl
    res$contrasts <- attr(x, "contrasts")
    res$xlevels <- .getXlevels(Terms, m)
    res$na.action <- attr(m, "na.action")
    res
}



#' @rdname wlda
#' @method wlda data.frame
#'
#' @S3method wlda data.frame

wlda.data.frame <- function (x, ...) {
    res <- wlda(structure(data.matrix(x, rownames.force = TRUE), class = "matrix"), ...)
    cl <- match.call()
    cl[[1L]] <- as.name("wlda")
    res$call <- cl
    res
}



#' @rdname wlda
#' @method wlda matrix
#'
#' @S3method wlda matrix

wlda.matrix <- function (x, grouping, weights = rep(1, nrow(x)), ..., subset, na.action = na.fail) {
    if (!missing(subset)) {
        weights <- weights[subset]
        x <- x[subset, , drop = FALSE]
        grouping <- grouping[subset]
    }
    if (missing(na.action)) {
        if (!is.null(naa <- getOption("na.action"))) {    # if options(na.action = NULL) the default na.fail comes into play
            if(!is.function(naa))
            	na.action <- get(naa, mode = "function")
            else
                na.action <- naa
		}
    } 
    dfr <- na.action(structure(list(g = grouping, w = weights, x = x), 
            class = "data.frame", row.names = rownames(x)))
    grouping <- dfr$g
    x <- dfr$x
    weights <- dfr$w
    res <- wlda.default(x, grouping, weights, ...)
    cl <- match.call()
    cl[[1L]] <- as.name("wlda")
    res$call <- cl
	res$na.action <- na.action
	res
}



#' @rdname wlda
#' @method wlda default
#'
#' @S3method wlda default

wlda.default <- function(x, grouping, weights = rep(1, nrow(x)), method = c("unbiased", "ML"), ...) {
    if (is.null(dim(x))) 
        stop("'x' is not a matrix")
    x <- as.matrix(x)
    if (any(!is.finite(x))) 
        stop("infinite, NA or NaN values in 'x'")
    n <- nrow(x)
    if (n != length(weights))
        stop("nrow(x) and length(weights) are different")
    if (any(weights < 0))
        stop("weights have to be larger or equal to zero")
    if (all(weights == 0))
        stop("all weights are zero")
    names(weights) <- rownames(x)
    if (n != length(grouping)) 
        stop("'nrow(x)' and 'length(grouping)' are different")
    if (!is.factor(grouping))
        warning("'grouping' was coerced to a factor")
    g <- as.factor(grouping)
    lev <- lev1 <- levels(g)
    counts <- as.vector(table(g))
    if (any(counts == 0)) {
        empty <- lev[counts == 0]
        warning(sprintf(ngettext(length(empty), "group %s is empty", 
            "groups %s are empty"), paste(empty, collapse = ", ")), 
            domain = NA)
        lev1 <- lev[counts > 0]
        g <- factor(g, levels = lev1)
        counts <- as.vector(table(g))
    }
    if (length(lev1) < 2L)
    	stop("training data from only one group given")
    names(counts) <- lev1
	# for fitting remove all observations with weight 0
	index <- weights > 0
    x <- x[index, , drop = FALSE]
    g <- g[index]
    co <- as.vector(table(g))
	lev1 <- lev1[co > 0]
    g <- factor(g, levels = lev1)
    w <- weights[index]
	method <- match.arg(method)
	class.weights <- tapply(w, g, sum)
    prior <- c(class.weights/sum(w))
    ng <- length(prior)
    xwt <- w * x
    center <- t(matrix(sapply(lev1, function(z) colSums(xwt[g == z, , drop = FALSE])), ncol = ng, dimnames = list(colnames(x), lev1)))/as.numeric(class.weights)    
	z <- x - center[g, , drop = FALSE]
	cov <- crossprod(w*z, z)/sum(w)	# ML estimate
    if (method == "unbiased") {
    	norm.weights <- w/class.weights[g]
    	cov <- cov/(1 - sum(prior * tapply(norm.weights^2, g, sum)))
    }
    cl <- match.call()
    cl[[1L]] <- as.name("wlda")
    return(structure(list(prior = prior, counts = counts, means = center, 
        cov = cov, lev = lev, N = n, weights = weights, method = method, call = cl), class = "wlda"))
}



# @param x A \code{wlda} object.
# @param ... Further arguments to \code{\link{print}}.
#
#' @method print wlda
#' @noRd
#'
#' @S3method print wlda

print.wlda <- function(x, ...) {
    if (!is.null(cl <- x$call)) {
        names(cl)[2L] <- ""
        cat("Call:\n")
        dput(cl, control = NULL)
    }
    cat("\nWeighted prior probabilities of groups:\n")
    print(x$prior, ...)
    cat("\nWeighted group means:\n")
    print(x$means, ...)
    cat("\nWeighted pooled class covariance matrix:\n")
    print(x$cov, ...)
    invisible(x)
}



#' Classify multivariate observations in conjunction with \code{\link{wlda}}.
#'
#'	This function is a method for the generic function \code{predict()} for class 
#'	\code{"wlda"}. 
#'	It can be invoked by calling \code{predict(x)} for an object \code{x} of the 
#'	appropriate class, or directly by calling \code{predict.wlda(x)} regardless of 
#'	the class of the object.
#'
#' @title Classify Multivariate Observations Based on Weighted Linear Discriminant Analysis
#'
#' @param object Object of class \code{"wlda"}.
#' @param newdata A \code{data.frame} of cases to be classified or, if \code{object} has a
#'          \code{formula}, a \code{data.frame} with columns of the same names as the
#'          variables used.  A vector will be interpreted as a row
#'          vector.  If \code{newdata} is missing, an attempt will be made to
#'          retrieve the data used to fit the \code{wlda} object.
#' @param prior The class prior probabilities. By default the proportions in the training data set.
#' @param \dots Further arguments.
#'
#' @return A list with components:
#' \item{class}{The predicted class labels (a \code{factor}).}
#' \item{posterior}{Matrix of class posterior probabilities.}
#'
#' @seealso \code{\link{wlda}}.
#' @examples
#' library(mlbench)
#' data(PimaIndiansDiabetes)
#' 
#' train <- sample(nrow(PimaIndiansDiabetes), 500)
#' 
#' # weighting observations from classes pos and neg according to their 
#' # frequency in the data set:
#' ws <- as.numeric(1/table(PimaIndiansDiabetes$diabetes)
#'     [PimaIndiansDiabetes$diabetes])
#' 
#' fit <- wlda(diabetes ~ ., data = PimaIndiansDiabetes, weights = ws, 
#'     subset = train)
#' pred <- predict(fit, newdata = PimaIndiansDiabetes[-train,])
#' mean(pred$class != PimaIndiansDiabetes$diabetes[-train])
#'
#' @keywords classif multivariate
#'
#' @method predict wlda
#' @rdname predict.wlda
#'
#' @S3method predict wlda

predict.wlda <- function(object, newdata, prior = object$prior, ...) {
	if (!inherits(object, "wlda"))
        stop("object not of class \"wlda\"")
    if (!is.null(Terms <- object$terms)) {
        Terms <- delete.response(Terms)
        if (missing(newdata))
            newdata <- model.frame(object)
        else {
            newdata <- model.frame(Terms, newdata, na.action = na.pass,
                xlev = object$xlevels)
            if (!is.null(cl <- attr(Terms, "dataClasses")))
                .checkMFClasses(cl, newdata)
        }
        x <- model.matrix(Terms, newdata, contrasts = object$contrasts)
        xint <- match("(Intercept)", colnames(x), nomatch = 0L)
        if (xint > 0)
            x <- x[, -xint, drop = FALSE]
    }
    else {
        if (missing(newdata)) {
            if (!is.null(sub <- object$call$subset))
                newdata <- eval.parent(parse(text = paste(deparse(object$call$x,
                  backtick = TRUE), "[", deparse(sub, backtick = TRUE),
                  ",]")))
            else newdata <- eval.parent(object$call$x)
            if (!is.null(nas <- object$call$na.action))
                newdata <- eval(call(nas, newdata))
        }
        if (is.null(dim(newdata)))
            dim(newdata) <- c(1, length(newdata))
        x <- as.matrix(newdata)
    }
    if (ncol(x) != ncol(object$means))
        stop("wrong number of variables")
    if (length(colnames(x)) > 0L && any(colnames(x) != dimnames(object$means)[[2L]]))
        warning("variable names in 'newdata' do not match those in 'object'")
    ng <- length(object$prior)
    if (!missing(prior)) {
        if (any(prior < 0) || round(sum(prior), 5) != 1)
            stop("invalid prior")
        if (length(prior) != ng)
            stop("'prior' is of incorrect length")
    }
    lev1 <- names(object$prior)
    # posterior <- matrix(0, ncol = length(object$lev), nrow = nrow(x), dimnames = list(rownames(x), object$lev))
    # posterior[,lev1] <- sapply(lev1, function(z) log(prior[z]) - 0.5 * mahalanobis(x, center = object$means[z,], cov = object$cov))
    # post <- posterior[,lev1, drop = FALSE]
    # gr <- factor(lev1[max.col(post)], levels = object$lev)    
    # names(gr) <- rownames(x)
    # post <- exp(post - apply(post, 1L, max, na.rm = TRUE))
    # post <- post/rowSums(post)
	# posterior[,lev1] <- post
    posterior <- matrix(0, ncol = ng, nrow = nrow(x), dimnames = list(rownames(x), lev1))
    posterior[,lev1] <- sapply(lev1, function(z) log(prior[z]) - 0.5 * mahalanobis(x, center = object$means[z,], cov = object$cov))
    gr <- factor(lev1[max.col(posterior)], levels = object$lev)
    names(gr) <- rownames(x)
    posterior <- exp(posterior - apply(posterior, 1L, max, na.rm = TRUE))
    posterior <- posterior/rowSums(posterior)
    if(any(is.infinite(posterior))) 
    	warning("infinite, NA or NaN values in 'posterior'")
    return(list(class = gr, posterior = posterior))
}



#' @method weights wlda
#' @noRd
#'
#' @S3method weights wlda
#' @importFrom stats weights

weights.wlda <- function (object, ...) {
    if (is.null(object$weights)) 
        rep(1, object$N)
    else object$weights
}



#' @method model.frame wlda
#' @noRd
#'
#' @S3method model.frame wlda
#' @importFrom stats model.frame

model.frame.wlda <- function (formula, ...) {
    oc <- formula$call
    #m <- match(oc, c("formula", "data"))
    oc$weights <- oc$method <- oc$wf <- oc$bw <- oc$k <- oc$nn.only <- oc$itr <- NULL
    oc[[1L]] <- as.name("model.frame")
    if (length(dots <- list(...))) {
        nargs <- dots[match(c("data", "na.action", "subset"), 
            names(dots), 0)]
        oc[names(nargs)] <- nargs
    }
    if (is.null(env <- environment(formula$terms))) 
        env <- parent.frame()
    eval(oc, env)
}
