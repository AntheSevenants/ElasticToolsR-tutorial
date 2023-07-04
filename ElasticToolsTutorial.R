# Load required files
source("Dataset.R")
source("ElasticNet.R")

# Download the dataset
download.file("https://anthe.sevenants.net/get/elastic-tools-r-tutorial/dataset.csv",
              "dataset.csv")

# Read the CSV as a data frame
df <- read.csv("dataset.csv")
str(df)

# Set data types
df$order <- as.factor(df$order)
df$participle <- as.factor(df$participle)
df$country <- as.factor(df$country)
df$edited <- as.logical(df$edited)

# Create ElasticTools dataset
ds <- dataset(df=df,
              response_variable_column="order",
              to_binary_columns=c("participle"),
              other_columns=list("country", "edited"))

# Define an Elastic Net object
net <- elastic_net(ds=ds,
                   nfolds=10,
                   type.measure="deviance")

# All penalised regression types
fit <- net$do_ridge_regression()
fit <- net$do_lasso_regression()
fit <- net$do_elastic_net_regression(alpha=0.5)

# Automatic alpha finding
collection <- net$do_elastic_net_regression_auto_alpha(k=10)

# Check the data frame
collection$results

# Select lowest loss row
lowest_loss_row <- collection$results[which.min(collection$results$loss),]
fit <- collection$fits[[lowest_loss_row[["X_id"]]]]

# Regression fit properties
fit$lambda.1se
fit$cvm
fit$nzero
fit$glmnet.fit$a0
fit$glmnet.fit$dev.ratio
fit$index

# Get coefficients and associated features
coefficients_with_labels <- net$attach_coefficients(fit)
head(coefficients_with_labels)

# Write coefficients to file
write.csv(coefficients_with_labels, "coefficients.csv", row.names=FALSE)

# Inspect coefficients using Rekker:
# https://anthesevenants.github.io/Rekker/