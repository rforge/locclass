setClass(
		"classif.daqda",
		contains = c("rlearner.classif")
)



setMethod(
		f = "initialize",
		signature = signature("classif.daqda"),
		def = function(.Object) {
			par.set = makeParamSet(
					makeDiscreteLearnerParam(id = "wf", default = "biweight", values = c("biweight", 
						"cauchy", "cosine", "epanechnikov", "exponential", "gaussian", "optcosine", 
						"rectangular", "triangular")),
					makeNumericLearnerParam(id = "bw", lower = 0),
					makeIntegerLearnerParam(id = "k", lower = 1),
          			makeLogicalLearnerParam(id = "nn.only", requires = expression(!missing(k))),
					makeIntegerLearnerParam(id = "itr", default = 3, lower = 1),
					makeDiscreteLearnerParam(id = "method", default = "unbiased", values = c("unbiased", "ML"))
     		 )
      		.Object = callNextMethod(.Object, pack="locClass", par.set = par.set)
			setProperties(.Object,
					oneclass = FALSE,
					twoclass = TRUE,
					multiclass = TRUE,
					missings = FALSE,
					numerics = TRUE,
					factors = TRUE,
					prob = TRUE,
					weights = TRUE
			)
		}
)



setMethod(
		f = "trainLearner",
		signature = signature(
				.learner = "classif.daqda",
				.task = "ClassifTask", 
				.subset = "integer"
		),
		def = function(.learner, .task, .subset,  ...) {
			f = getFormula(.task)
      		if (.task@desc@has.weights)
        		daqda(f, data = getData(.task, .subset), weights = .task@weights[.subset], ...)
      		else  
       			daqda(f, data = getData(.task, .subset), ...)
        }
)



setMethod(
		f = "predictLearner",
		signature = signature(
				.learner = "classif.daqda",
				.model = "WrappedModel",
				.newdata = "data.frame"
		),
		def = function(.learner, .model, .newdata, ...) {
			p = predict(.model@learner.model, newdata = .newdata, ...)
			if (.learner@predict.type == "response")
				return(p$class)
			else
				return(p$posterior)
		}
)
