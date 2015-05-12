# Sample API between R and Aylien Text Analysis REST API service endpoints
# Visit www.aylien.com for more details.
# Author: Arnab Dutta
# Date:   15-03-2015

library(RCurl)
library(XML)
library(plyr)

aylienAPI<-function(APPLICATION_ID, APPLICATION_KEY, endpoint, parameters, type)
{
  url = paste0('https://api.aylien.com/api/v1/',endpoint)
  httpHeader = c(Accept="text/xml", 'X-AYLIEN-TextAPI-Application-ID' = APPLICATION_ID, 
                 'X-AYLIEN-TextAPI-Application-Key'= APPLICATION_KEY, 
                 'Content-Type'="application/x-www-form-urlencoded; charset=UTF-8")
  
  
  paramPost<-paste0(type,"=",parameters)
  
  paramEncode<-URLencode(paramPost)
  
  resp<-getURL(url, httpheader = httpHeader,
               postfields=paramEncode, verbose = FALSE)
  
  resp
}

# Enter your API credentials. Create an account to get your application id and key on http://developer.aylien.com/signup

APPLICATION_ID = 'YOUR_APPLICATION_ID'
APPLICATION_KEY = 'YOUR_APPLICATION_KEY'

# Aylien Endpoint Reference
# http://aylien.com/text-api-doc

endpoint = "classify"
parameters = "http://www.bbc.com/sport/0/football/25912393"
type = "url"

results<-aylienAPI(APPLICATION_ID, APPLICATION_KEY, endpoint, parameters, type)

# Converting the XML o/p to a data frame

resultsdf<-ldply(xmlToList(results), data.frame)
View(resultsdf)

# You can retrieve data using XPATH from the XML result

PARSED<-xmlInternalTreeParse(results)
View(xpathSApply(PARSED, "//category",xmlValue))
