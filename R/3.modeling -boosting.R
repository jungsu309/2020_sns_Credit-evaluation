#########
#모델 생성


library(readxl)
library(openxlsx)
library('tidyverse')
library('tidymodels')
library('caret')
library('gbm')

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
# 부스팅 실행
gbm(followernum.y~postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+location_num+hashtag_average
    +post_upload+max_tags_num,data=file_training,distribution="gaussian",n.trees=5000,interaction.depth=4)-> file_boosting
file_boosting %>%
  predict(file_testing) %>%
  bind_cols(file_testing) %>%
  metrics(truth = followernum.y, estimate=...1)#예측값 행 이름이 ...1로 바뀜.

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
# 부스팅 실행
gbm(followernum.y~postnum+followernum.x+followingnum+sellnum+dailynum+like_mean_7+location_num+hashtag_average
    +post_upload+max_tags_num,data=file_all_pre,distribution="gaussian",n.trees=5000,interaction.depth=4)-> file_all_boosting
file_all_boosting%>%
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
file_all_boosting %>%
  predict(data0501_receipe) %>%
  bind_cols(data0501) %>%
  arrange(id) %>%
  select(followernum.x, id, ...1)->pred_follower_data
#원래 데이터와 예측값 합치기.
#View(pred_follower_data)
#컬럼이름바꿔주기
names(pred_follower_data)[names(pred_follower_data) == "...1"] <- c(".pred")

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
data_combind<-rbind(data_all, data_final)

#순위-> 백분율로 표현
data_combind$rank_percent <- (data_combind$Rate_rank/(nrow(data_combind)/4))*100

#View(data_combind)
#write.xlsx(data_combind, file ="C:/Users/정수/8%_project_python__int/원본데이터/50/all_profile_Rate.xlsx")


