context("FLXMCLconstant: mlr interface code")

test_that("FLXMCLconstant: mlr interface works", {
	library(locClassData)

	data <- xor3Data(500)
	task <- makeClassifTask(data = as.data.frame(data), target = "y")

	set.seed(120)
	cluster <- kmeans(data$x, centers = 9)$cluster

	# class prediction
	set.seed(120)
	lrn <- makeLearner("classif.FLXMCLconstant", centers = 9)
	tr1 <- train(lrn, task)
	pred1 <- predict(tr1, task = task)

	# posterior prediction
	set.seed(120)
	lrn <- makeLearner("classif.FLXMCLconstant", par.vals = list(centers = 9, iter.max = 200), predict.type = "prob")
	tr2 <- train(lrn, task)
	pred2 <- predict(tr2, task = task)

	expect_equal(pred1$data$response, pred2$data$response)
	mean(pred1$data$response != pred1$data$truth)
	mean(pred2$data$response != pred1$data$truth)
	mean(pred2$data$response != pred2$data$truth)
	
	tr3 <- flexmix(y ~ ., data = as.data.frame(data), concomitant = FLXPwlda(~ x.1 + x.2), model = FLXMCLconstant(), cluster = cluster, control = list(iter.max = 200))
	pred3 <- mypredict(tr3, aggregate = TRUE)

	expect_true(all(pred3[[1]] == pred2$data[,3:5]))

	# class prediction
	set.seed(120)
	lrn <- makeLearner("classif.FLXMCLconstant", centers = 9, classify = "hard")
	tr1 <- train(lrn, task)
	pred1 <- predict(tr1, task = task)

	# posterior prediction
	set.seed(120)
	lrn <- makeLearner("classif.FLXMCLconstant", par.vals = list(centers = 9, iter.max = 200), predict.type = "prob", classify = "hard")
	tr2 <- train(lrn, task)
	pred2 <- predict(tr2, task = task)

	expect_equal(pred1$data$response, pred2$data$response)
	mean(pred1$data$response != pred1$data$truth)
	mean(pred2$data$response != pred1$data$truth)
	mean(pred2$data$response != pred2$data$truth)

	tr3 <- flexmix(y ~ ., data = as.data.frame(data), concomitant = FLXPwlda(~ x.1 + x.2), model = FLXMCLconstant(), cluster = cluster, control = list(iter.max = 200, classify = "hard"))
	pred3 <- mypredict(tr3, aggregate = TRUE)

	expect_true(all(pred3[[1]] == pred2$data[,3:4]))

})
