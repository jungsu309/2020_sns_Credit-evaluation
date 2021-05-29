#install.packages('readxl')
library(readxl)
library(dplyr)
library(corrplot)
library(openxlsx)

#dataset 합치기
#4/10 + 4/17
data0410_j <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수50/0410_50_merge_company_profile.xlsx")
data0410_s <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/서안50/profile0410-0417.xlsx")
#날짜 값 이상한것 처리
data0410_s$codingdate <- as.character(data0410_s$codingdate)
data0410_m <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/민경50/profile0410-0417.xlsx")
data0410_n <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/나현50/0410_merge_profile.xlsx")

data0410_1<- rbind(data0410_j,data0410_s)
data0410_2<- rbind(data0410_m,data0410_n)
data0410<-rbind(data0410_1,data0410_2)

#write.xlsx(data0410, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/0410_all_profile.xlsx")

#4/17 + 4/24
data0417_j <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수50/0417_50_merge_company_profile.xlsx")
data0417_s <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/서안50/profile0417-0424.xlsx")
#날짜 값 이상한것 처리
data0417_s$codingdate <- as.character(data0417_s$codingdate)
data0417_m <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/민경50/profile0417-0424.xlsx")
data0417_n <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/나현50/0417_merge_profile.xlsx")

data0417_1<- rbind(data0417_j,data0417_s)
data0417_2<- rbind(data0417_m,data0417_n)
data0417<-rbind(data0417_1,data0417_2)

#write.xlsx(data0417, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/0417_all_profile.xlsx")


#4/24 + 5/01  
data0424_j <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수50/0424_50_merge_company_profile.xlsx")
data0424_s <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/서안50/profile0424-0501.xlsx")
#날짜 값 이상한것 처리
data0424_s$codingdate<-as.character(data0424_s$codingdate)
data0424_m <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/민경50/profile0424-0501.xlsx")
data0424_n <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/나현50/0424_merge_profile.xlsx")

data0424_1<- rbind(data0424_j,data0424_s)
data0424_2<- rbind(data0424_m,data0424_n)
data0424<-rbind(data0424_1,data0424_2)

#write.xlsx(data0424, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/0424_all_profile.xlsx")

#5/1
data0501_j <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수50/0501_50_merge_company_profile.xlsx")
data0501_s <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/서안50/profile0501.xlsx")
#날짜 값 이상한것 처리
data0501_s$codingdate<-as.character(data0501_s$codingdate)
data0501_m <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/민경50/profile0501.xlsx")
data0501_n <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/나현50/0501_merge_profile.xlsx")

data0501_1<- rbind(data0501_j,data0501_s)
data0501_2<- rbind(data0501_m,data0501_n)
data0501<-rbind(data0501_1,data0501_2)

#write.xlsx(data0501, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/0501_all_profile.xlsx")


#4/10 + 4/17 + 4/24
data0410 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/0410_all_profile.xlsx")
data0417 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/0417_all_profile.xlsx")
data0424 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/0424_all_profile.xlsx")

data_1<- rbind(data0410,data0417)
data_2<-rbind(data_1,data0424)

#write.xlsx(data_2, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/3week_all_profile.xlsx")

#수집만 한 데이터 csv에서 처리할것 처리해주기
profile<- read.csv("C:/Users/정수/8%_project_python__int/원본데이터/800/profile_0308-0426_all.csv")
profile$postnum <- gsub(",","",profile$postnum)
profile$followernum <- gsub(",","",profile$followernum)
profile$followingnum <- gsub(",","",profile$followingnum)

profile$postnum <- as.numeric(profile$postnum)
profile$followernum <- as.numeric(profile$followernum)
profile$followingnum <- as.numeric(profile$followingnum)

write.csv(profile, file ="C:/Users/정수/8%_project_python__int/원본데이터/800/profile_0308-0426_all_final.csv")
#########################################

data<- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/3week_all_profile.xlsx")


#유의한 변수에 대한 분포
like_hist <- hist(data$like_mean_7)
postnum_hist <- hist(data$postnum)
hashtag_hist <- hist(data$hashtag_average)


#분석가능한 컬럼 추출
data<- data[,c("followernum.x","followernum.y","postnum","followingnum","like_mean_all","like_mean_7","sellnum","dailynum","location_num","hashtag_average","post_upload","max_tags_num")]
#비율보는 행 추가
follower_diff<-(data$followernum.y-data$followernum.x)/data$followernum.x
data<-cbind(data,follower_diff)

#정규화(열 전부)
data$followernum.x<- scale(data$followernum.x,center=min(data$followernum.x), scale = max(data$followernum.x) - min(data$followernum.x))
data$followernum.y<- scale(data$followernum.y,center=min(data$followernum.y), scale = max(data$followernum.y) - min(data$followernum.y))
data$postnum<- scale(data$postnum,center=min(data$postnum), scale = max(data$postnum) - min(data$postnum))
data$followingnum<- scale(data$followingnum,center=min(data$followingnum), scale = max(data$followingnum) - min(data$followingnum))
data$like_mean_all<- scale(data$like_mean_all,center=min(data$like_mean_all), scale = max(data$like_mean_all) - min(data$like_mean_all))
data$like_mean_7<- scale(data$like_mean_7,center=min(data$like_mean_7), scale = max(data$like_mean_7) - min(data$like_mean_7))
data$sellnum<- scale(data$sellnum,center=min(data$sellnum), scale = max(data$sellnum) - min(data$sellnum))
data$dailynum<- scale(data$dailynum,center=min(data$dailynum), scale = max(data$dailynum) - min(data$dailynum))
data$location_num<- scale(data$location_num,center=min(data$location_num), scale = max(data$location_num) - min(data$location_num))
data$hashtag_average<- scale(data$hashtag_average,center=min(data$hashtag_average), scale = max(data$hashtag_average) - min(data$hashtag_average))
data$post_upload<- scale(data$post_upload,center=min(data$post_upload), scale = max(data$post_upload) - min(data$post_upload))
data$follower_diff<- scale(data$follower_diff,center=min(data$follower_diff), scale = max(data$follower_diff) - min(data$follower_diff))
data$max_tags_num<- scale(data$max_tags_num,center=min(data$max_tags_num), scale = max(data$max_tags_num) - min(data$max_tags_num))

#트레이닝:테스트 = 7:3
set.seed(2021)
train <- sample(1:nrow(data), round(nrow(data)*0.7))
data.train <- data[train, ]
data.test <- data[-train, ]

#correlation 표
datacor<- cor(data)
corrplot(datacor, method ="circle")
#과적합 나는 컬럼들 제거(dailynum, like_mean_all)


#과적합 생각 말고 전부 넣어서 봐보기
model1 <- lm(followernum.y ~ followernum.x + postnum +followingnum+ like_mean_all + like_mean_7+ sellnum + dailynum
               location_num + hashtag_average + post_upload + max_tags_num, data = data.train)

#비율(낮은 정확도)
model1 <- lm(follower_diff ~ postnum + sellnum + like_mean_7+ location_num + hashtag_average + 
               post_upload, data = data.train)
summary(model1)
#stepwise
model_stepwise<- lm(follower_diff ~ postnum + sellnum + like_mean_7+ location_num + hashtag_average + 
                      post_upload, data = data.train)%>% stats::step(direction = "both")
summary(model_stepwise)


#다음주 팔로워에 이번주까지 전부(과적합)
model2 <- lm(followernum.y ~ followernum.x + postnum +followingnum+ like_mean_7+ sellnum + 
               location_num + hashtag_average + post_upload + max_tags_num, data = data.train)
summary(model2)
#stepwise
model_stepwise<- lm(followernum.y ~ followernum.x + postnum +followingnum+ like_mean_7+ sellnum + 
                      location_num + hashtag_average + post_upload + max_tags_num, 
                    data = data.train)%>% stats::step(direction = "both")
summary(model_stepwise)

#다음주 팔로워<우리가 선택한것>
model <- lm(followernum.y ~postnum + sellnum + like_mean_7+ location_num + hashtag_average + 
              post_upload +max_tags_num, data = data.train)
summary(model)
#stepwise
model_stepwise<- lm(followernum.y ~postnum + sellnum + like_mean_7+ location_num + hashtag_average +
                      post_upload +max_tags_num, data = data.train)%>% stats::step(direction = "both")
summary(model_stepwise)


#차이
model <- lm(followernum.y-followernum.x ~postnum +followingnum+followernum.x+ sellnum +
              location_num + hashtag_average + post_upload +max_tags_num, data = data.train)
summary(model)
#stepwise
model_stepwise <-lm(followernum.y-followernum.x ~postnum +followingnum+followernum.x+ sellnum + 
                      location_num + hashtag_average + post_upload +max_tags_num, 
                    data = data.train)%>% stats::step(direction = "both")

summary(model_stepwise)


#########
#모델 생성


library(readxl)
library(openxlsx)
library('tidyverse')
library('tidymodels')
#install.packages('randomForestExplainer')
library('randomForestExplainer')

#dataset
data_all <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/3week_all_profile.xlsx")
data0501 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/50/0501_all_profile.xlsx")
#분석을 위해 컬럼 명 맞춰주기
names(data0501)[names(data0501) == "followernum"] <- c("followernum.x")

names(data_all)
length(names(data_all))
names(data0501)
length(names(data0501))


file <- data_all
#follower_diff<-(file$followernum.y-file$followernum.x)
#file<-cbind(file,follower_diff)
file %>%
  initial_split(prop = 0.7) -> file_split
file_split
# file_split %>% training()
# file_split %>% testing()
# 변수 처리
file_split %>% training() %>%
  recipe(followernum.y ~ postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+like_mean_all+location_num+hashtag_average+post_upload+max_tags_num) %>%
  step_corr(all_predictors()) %>%
  step_center(all_predictors(), -all_outcomes()) %>%
  step_scale(all_predictors(), -all_outcomes()) %>%
  prep() -> file_recipe
file_recipe
# 시험용 데이터 처리
file_recipe %>%
  bake(file_split %>% testing()) -> file_testing
# 학습용 데이터 처리
file_recipe %>%
  juice() -> file_training
# install.packages('randomForest')
# 랜 포 실 행
rand_forest(trees = 100, mode = 'regression') %>%
  set_engine('randomForest') %>%
  fit(followernum.y ~ postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+location_num+
        hashtag_average+post_upload+max_tags_num, data=file_training) -> file_rf
file_rf %>%
  predict(file_testing) %>%
  bind_cols(file_testing) %>%
  metrics(truth = followernum.y, estimate=.pred)

measure_importance(file_rf$fit)

measure_importance(file_rf$fit) %>%
  as_tibble() %>%
  mutate(imp=node_purity_increase*100/max(node_purity_increase)) %>%
  arrange(-imp) %>%
  select(variable, imp)

# 전체 데이터에다 넣어보고 실제 예측 하는지 확인해보자.
file %>%
  recipe(followernum.y ~ postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+location_num+hashtag_average+post_upload+max_tags_num) %>%
  step_corr(all_predictors()) %>%
  step_center(all_predictors(), -all_outcomes()) %>%
  step_scale(all_predictors(), -all_outcomes()) %>%
  prep() -> file_recipe2
file_recipe2
file_recipe2 %>%
  bake(file) -> file_all
file_recipe2 %>%
  juice() -> file_all_pre
# 랜 포 실 행
rand_forest(trees = 100, mode = 'regression') %>%
  set_engine('randomForest') %>%
  fit(followernum.y ~ postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+location_num+hashtag_average+post_upload+max_tags_num, data=file_all_pre) -> file_all_rf
file_all_rf%>%
  predict(file_all_pre) %>%
  bind_cols(file)
#위에 이어서 쓴건데 이해가안되는.
#group_by(season, lg) %>%
#mutate(rank=rank(-.pred)) %>%
#select(season, lg, team, name, cy, rank) %>%
#filter(rank==1 | cy=='O') %>%
#arrange(season, lg, cy)
#진짜 예측을 원하는 데이터에 적용시켜보자.
file_recipe2 %>%
  bake(data0501) -> data0501_receipe
file_all_rf %>%
  predict(data0501_receipe) %>%
  bind_cols(data0501) %>%
  arrange(id) %>%
  select(followernum.x, id, .pred)->pred_follower_data
#원래 데이터와 예측값 합치기.
#View(pred_follower_data)
pred_follower_data<-pred_follower_data[,c("id",".pred")]
data_final<- inner_join(data0501, pred_follower_data, by='id')
follower_Rate_of_change <- data_final$.pred / data_final$followernum.x
data_final<-cbind(data_final, follower_Rate_of_change)
Rate_rank<-round(rank(-data_final$follower_Rate_of_change))
data_final<-cbind(data_final, Rate_rank)
data_final$.pred <- round(data_final$.pred)
#View(data_final)

follower_Rate_of_change <- data_all$followernum.y / data_all$followernum.x
data_all<-cbind(data_all, follower_Rate_of_change)
#주별로 랭크 매기기

data_all_0410<-data_all[data_all$codingdate =="2021-04-10",]
Rate_rank1<-round(rank(-data_all_0410$follower_Rate_of_change))
str(Rate_rank1)
data_all_0417<-data_all[data_all$codingdate =="2021-04-17",]
Rate_rank2<-round(rank(-data_all_0417$follower_Rate_of_change))
str(Rate_rank2)
data_all_0424<-data_all[data_all$codingdate =="2021-04-24",]
Rate_rank3<-round(rank(-data_all_0424$follower_Rate_of_change))
str(Rate_rank3)
Rate_rank <- c(Rate_rank1,Rate_rank2,Rate_rank3)
str(Rate_rank)
data_all<-cbind(data_all, Rate_rank)
#View(data_all)

#두 데이터를 합치기 위해 열 이름을 통일시켜주기.

names(data_all)[names(data_all) == "followernum.x"] <- c("followernum")
names(data_all)[names(data_all) == "followernum.y"] <- c("Next_followernum")

names(data_final)[names(data_final) == "followernum.x"] <- c("followernum")
names(data_final)[names(data_final) == ".pred"] <- c("Next_followernum")


names(data_all)
length(names(data_all))
names(data_final)
length(names(data_final))

#write.xlsx(data_all, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/3week_all_profile_rate.xlsx")
#write.xlsx(data_final, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/0501_50_predict.xlsx")


#데이터 아래에 붙이기
data_combined<-rbind(data_all, data_final)

#순위-> 백분율로 표현
data_combined$rank_percent <- (data_combined$Rate_rank/(nrow(data_combined)/4))*100

#변수 중요도가 높은 5개의 변수를 히스토그램으로 그림
names(data0501)[names(data0501) == "followernum.x"] <- c("followernum")
follower<- hist(data0501$followernum, breaks=50)
follower<- hist(data0501$followingnum, breaks=50)
follower<- hist(data0501$like_mean_7, breaks=50)
follower<- hist(data0501$postnum, breaks=50)
follower<- hist(data0501$post_upload, breaks=50)
#View(data_combind)
write.xlsx(data_combind, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/all_profile_Rate.xlsx")


