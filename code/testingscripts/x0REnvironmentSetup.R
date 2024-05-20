## environment set up of necessary packages and gee authentication
## only run this code once

# install packages
install.packages("reticulate")
install.packages("rgee")

# load packages
library(reticulate)
library(rgee)


# install ee


ee_install() # select y when asked
ee_check() # check if installed correctly
# reticulate::py_install('earthengine-api==0.1.323', envname='rgee')

# autheticate
ee_Initialize(user = "jwilkens@wesleyan.edu", drive = TRUE)


