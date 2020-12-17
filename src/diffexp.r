# I am looking for one who can recompile existing functions in R or C++ to
# implement our idea on that.
# This example how we can inject our codes in differential testing
# obtained from https://github.com/satijalab/seurat/blob/master/R/differential_expression.R



ExpMean <- function(x, ...) {
  if (inherits(x = x, what = 'AnyMatrix')) {
    return(apply(X = x, FUN = function(i) {log(x = mean(x = exp(x = i) - 1) + 1)}, MARGIN = 1))
  } else {
    return(log(x = mean(x = exp(x = x) - 1) + 1))
  }
}

DifferentialAUC <- function(x, y) {
  require(ROCR)
  prediction.use <- prediction(
    predictions = c(x, y),
    labels = c(rep(x = 1, length(x = x)), rep(x = 0, length(x = y))),
    label.ordering = 0:1
  )
  perf.use <- performance(prediction.obj = prediction.use, measure = "auc")
  auc.use <- round(x = perf.use@y.values[[1]], digits = 3)
  return(auc.use)
}

AUCMarkerTest <- function(data1, data2, mygenes, print.bar = TRUE) {
  myAUC <- unlist(x = lapply(
    X = mygenes,
    FUN = function(x) {
      return(DifferentialAUC(
        x = as.numeric(x = data1[x, ]),
        y = as.numeric(x = data2[x, ])
      ))
    }
  ))
  myAUC[is.na(x = myAUC)] <- 0
  iterate.fxn <- ifelse(test = print.bar, yes = pblapply, no = lapply)
  avg_diff <- unlist(x = iterate.fxn(
    X = mygenes,
    FUN = function(x) {
      return(
        ExpMean(
          x = as.numeric(x = data1[x, ])
        ) - ExpMean(
          x = as.numeric(x = data2[x, ])
        )
      )
    }
  ))
  toRet <- data.frame(cbind(myAUC, avg_diff), row.names = mygenes)
  toRet <- toRet[rev(x = order(toRet$myAUC)), ]
  return(toRet)
}

MarkerTest <- function(
  data.use,
  cells.1,
  cells.2,
  verbose = TRUE
) {
  to.return <- AUCMarkerTest(
    data1 = data.use[, cells.1, drop = FALSE],
    data2 = data.use[, cells.2, drop = FALSE],
    mygenes = rownames(x = data.use),
    print.bar = verbose
  )
  to.return$power <- abs(x = to.return$myAUC - 0.5) * 2
  return(to.return)
}

