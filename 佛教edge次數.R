#read node and edge
nfCH1957Edges <- read.csv("nfCH1957 [Edges].csv", sep=',', fileEncoding = 'utf8')
nfCH1957Nodes <- read.csv("nfCH1957 [Nodes].csv", sep=',', fileEncoding = 'utf8')


library(dplyr)
#選欄位 select(資料框, 欄位1, 欄位2, 欄位3)
class0  <- filter(nfCH1957Nodes, nfCH1957Nodes$modularity_class == 0 )
colnames(class0) <- c("Source",
                      "label",
                      "total",
                      "clustering",
                      "modularity_class")
edgeclass0 <-merge(nfCH1957Edges , class0   ,by="Source")
edgeclass0 <- edgeclass0[,c(-3:-4,-6:-7)]
colnames(edgeclass0) <- c("id",
                          "Source",
                          "label",
                          "modularity_class")
edgeclass0 <-merge(edgeclass0  , class0   ,by="Source")
edgeclass0 <- edgeclass0[,c(-3:-4,-6:-7)]
colnames(edgeclass0) <- c("Source",
                          "Target",
                          "label",
                          "modularity_class")

edgeclass0Freq<-as.data.frame(table(edgeclass0$label))
colnames(edgeclass0Freq) <- c("label",
                              "Freq")
#以標籤命名
class0Freq <-merge(class0 ,edgeclass0Freq ,  by ="label")
#
class0Freq <- class0Freq [, -3:-4]
#
class0Freq <- arrange(class0Freq,  desc(Freq))


###############################################################


allclass<-data.frame(  
  label=character(0),
  Source=character(0),
  modularity_class=character(0),
  Freq=character(0)
)


for (i in c(0:24)){
  class  <- filter(nfCH1957Nodes, nfCH1957Nodes$modularity_class == i )
  colnames(class) <- c("Source",
                        "label",
                        "total",
                        "clustering",
                        "modularity_class")
  edgeclass <-merge(nfCH1957Edges , class   ,by="Source")
  edgeclass <- edgeclass[,c(-3:-4,-6:-7)]
  colnames(edgeclass) <- c("id",
                            "Source",
                            "label",
                            "modularity_class")
  edgeclass <-merge(edgeclass  , class   ,by="Source")
  edgeclass <- edgeclass[,c(-3:-4,-6:-7)]
  colnames(edgeclass) <- c("Source",
                            "Target",
                            "label",
                            "modularity_class")
  
  edgeclassFreq<-as.data.frame(table(edgeclass$label))
  colnames(edgeclassFreq) <- c("label",
                                "Freq")
  #以標籤命名
  classFreq <-merge(class ,edgeclassFreq ,  by ="label")
  #
  classFreq <- classFreq [, -3:-4]
  #
  classFreq <- arrange(classFreq,  desc(Freq))
  allclass <- rbind(allclass,classFreq)
}



write.table(allclass, file = "nfCH1957.csv", row.names=FALSE, col.names=TRUE, sep = ",")


