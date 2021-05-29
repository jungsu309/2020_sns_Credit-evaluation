###libaray준비###
#install.packages('readxl')
library(readxl)
#install.packages('tidyverse')
library(tidyverse)
#install.packages("dplyr")
library(dplyr)
#install.packages('lubridate')
library('lubridate')
library(data.table)
library(plyr)
#install.packages("openxlsx")
library(openxlsx)
###excel data준비###
post <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수거만/50/0424_post_50_정수.xlsx")
profile <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수거만/50/0424_profile_50_정수.xlsx")
View(profile)
#문자->숫자
profile$postnum <- gsub(",","",profile$postnum)
profile$followernum <- gsub(",","",profile$followernum)
profile$followingnum <- gsub(",","",profile$followingnum)
profile$postnum <- as.numeric(profile$postnum)
profile$followernum <- as.numeric(profile$followernum)
profile$followingnum <- as.numeric(profile$followingnum)
###1. 일상글 판매글 구분###
#일상이라고 써놓은애는 무조건 일상글, 안써놓은 애들은 우선 다 판매글이라고 봄.
data1 <- post %>% mutate(sellingPost=ifelse(str_detect(contents, '일상')==TRUE, '일상글','판매글'))
#data1
#일상글 중에 판매 관련 단어가 섞인애들 찾아내기
data2 <- filter(data1, sellingPost == '일상글')
#data2
data3_sell <- data2 %>% mutate(sellingPost=case_when(
  str_detect(contents, '판매')~'판매글',
  str_detect(contents, '문의')~'판매글',
  str_detect(contents, '주문')~'판매글',
  str_detect(contents, '공구')~'판매글',
  str_detect(contents, '협찬')~'판매글',
  str_detect(contents, '마켓')~'판매글',
  str_detect(contents, '블로그')~'판매글',
  str_detect(contents, '링크')~'판매글',
  str_detect(contents, '세일')~'판매글',
  str_detect(contents, '할인')~'판매글',
  str_detect(contents, '카톡')~'판매글',
  str_detect(contents, '카카오톡')~'판매글',
  str_detect(contents, '구매')~'판매글',
  str_detect(contents, '구입')~'판매글',
  str_detect(contents, '다이렉트')~'판매글',
  str_detect(contents, '제품')~'판매글',
  str_detect(contents, '상품')~'판매글',
  str_detect(contents, '스토어')~'판매글',
  str_detect(contents, '상점')~'판매글',
  str_detect(contents, 'DM')~'판매글',
  str_detect(contents, '디엠')~'판매글',
  str_detect(contents, '가격')~'판매글',
  str_detect(contents, 'kakaotalk')~'판매글',
  str_detect(contents, '샵')~'판매글',
  str_detect(contents, '오픈')~'판매글',
  str_detect(contents, 'open')~'판매글',
  str_detect(contents, '배송')~'판매글'
))
#data3_sell
#완전 일상글인 애들 뽑기
data3_daily <- filter(data3_sell, is.na(data3_sell$sellingPost) == TRUE) # data3_sell[is.na(data3_sell$daily),]  랑 동일
#data3_daily
data3_daily$sellingPost[is.na(data3_daily$sellingPost)] <- "일상글"
#View(data3_daily)
#data3의 판매글목록과 data1에서 판매글로 분류된 애들 합치기
data4 <- filter(data1, sellingPost == "판매글")
#data4
data3 <- filter(data3_sell, sellingPost == "판매글")
data_last <- rbind(data3, data4)
#data_last
#View(data_last)
#일상글과 판매글 목록 합치기
post <- rbind(data_last,data3_daily)
post <- post[order(post$no),]
#View(post)
#각 계정의 판매글, 일상글 갯수 추가
sell_p <-post[post$sellingPost == "판매글",]
daily_p <-post[post$sellingPost == "일상글",]
sellnum = ddply(sell_p, c("id"), summarise, sellnum = length(sellingPost))
dailynum = ddply(daily_p, c("id"), summarise, dailynum = length(sellingPost))
profile<- merge(x = profile, y = sellnum, by='id', all.x = TRUE)
profile<- merge(x = profile, y = dailynum, by='id', all.x = TRUE)
#View(profile)
###2. 좋아요 차이, 게시글 게시 날짜 차이###
post$date <- ymd(post$date)
# 날짜 정렬
post <- post %>% arrange(id, date) %>% group_by(id)
#좋아요 문자 -> 숫자
post$likes <- gsub(",","",post$likes)
post$likes = as.numeric(post$likes)
#1년->숫자로 표현
day <- yday(post$date)
post <- cbind(post, day)
colnames(post)[11] = c("day")
#View(post)
# 날짜 간 차이를 보여주는 코드
setDT(post)[, datediff := date - shift(date), by = id]
setDT(post)[, likediff := likes - shift(likes), by = id]
#View(post)
###3. 최근 7일간 좋아요 평균, 전체글(100개 이하) 좋아요 평균###
#최근 년도와 그 전년도 12월만 다루기
posting_recent <- subset(post, year(post$date) == max(year(post$date)) | (year(post$date) == max(year(post$date)-1)& month(post$date) == 12))
#View(posting_recent)
#id 별 제일 최신글 = id별 day값이 제일 큰 것들
recently <- posting_recent %>% arrange(id, desc(date)) %>% group_by(id) %>% slice(1:1)
recently <- select(recently, id, day)
#View(recently)
#제일 최근글 기준 7일 간의 게시글(숫자 조절하면됨.)
join <- inner_join(posting_recent,recently, by = 'id')
#View(join)
#358인 이유 : 21년 1/1일에 작성한 글의 경우 20년 12월 25일까지이기때문(12/25 = 1년의 359일)
posting_recent <- join[((join$day.y - join$day.x >= 0) & (join$day.y - join$day.x < 7)) | (join$day.x - join$day.y > 358), ]#7-> 원하는 숫자로 바꾸면 됨.
#View(posting_recent)
#평균구하기
like_mean_7 <- tapply(posting_recent$likes, posting_recent$id, mean)
#전체 좋평
posting_all <- post[order(post$id, post$date),]
like_mean_all <- tapply(posting_all$likes, posting_all$id, mean)
#평균낸거 다 하나로 붙이기
#id
id_unique <- unique(post$id)
id <-sort(id_unique)
#View(id)
like_mean <- cbind(id,like_mean_7,like_mean_all)
#View(like_mean)
#post에 id같으면 기존 컬럼 뒤에 이어 붙이기(key : id,merge 이용. leftjoin 이용)
#왜냐면 최신 글 좋아요를 아예 못받은 사람이 있을수도 있기 때문!!?
profile <- merge(x = profile, y = like_mean, by='id', all.x = TRUE)
#View(profile)
###4. 해시태그 갯수 구하기###
hashtag_num<-str_count(post$tags,'#')
post <- cbind(post, hashtag_num)
#View(post)
###5.위치정보 갯수 구하기###
post2 <-post[post$location != "",]
#View(post2)
location_num = ddply(post2, c("id"), summarise, location_num = length(location))
#View(location_num)
profile<- merge(x = profile, y = location_num, by='id', all.x = TRUE)
#View(profile)
###6.계정별 해쉬태그 사용 평균 갯수 구하기(중복 허용)###
temp <- aggregate(hashtag_num~id, post, mean)
names(temp)[2] <- c("hashtag_average")
profile <- merge (x = profile, y = temp, by='id', all.x = TRUE)
#View(profile)
###7.계정별 게시글 올리는 주기 평균 구하기###
temp <- post[post$datediff != 0,]
temp <- aggregate(datediff ~ id, temp, mean)
#View(temp)
names(temp)[2] <- c("post_upload")
profile <- merge (x = profile, y = temp, by='id', all.x = TRUE)
#View(profile)
#결측치 모두 0으로 처리
post[is.na(post)] <- 0
profile[is.na(profile)] <- 0
###8.id별 중복 포함 모든 태그 목록, 제일 많이 쓴 태그, 제일 많이 쓴 태그를 몇 번 썼는지
#install.packages("data.table")
library(dplyr)
library(data.table)
library(stringr)
tags_list <- list() # id별로 합친 태그 저장할 리스트
# 데이터프레임 컬럼
id_tag <- c()
all_tags <- c()
max_tags <- c()
max_tags_num <- c()
# 태그 합치는 함수
tags_sum <- function(data){
  hashtags <- ""
  for(i in 1:nrow(data)){
    if(data[i, 'tags'] != 0){
      hashtags <- paste(hashtags, data[i, 'tags'])
    }
  }
  return(gsub(" ", "", hashtags))
}
id_group <- split(post, post$id)
for(i in 1:length(id_group)){
  id_table <- data.frame(id_group[i])
  names(id_table) <- c("no", "codingdate", "url", "id", "location", "tags", "contents", "date", "likes")
  tags <- str_trim(tags_sum(id_table))
  tags_list[i] <- tags
  id_tag <- c(id_tag, names(id_group[i]))
  all_tags <- c(all_tags, tags)
}
for(i in 1:length(tags_list)){
  count_tags <- list() # 태그를 몇번 사용했는지 저장할 리스트(딕셔너리)
  words <- strsplit(as.character(tags_list[i]), split = "#")
  for(j in 2:length(words[[1]])){
    tag <- paste0("#", words[[1]][j])
    if(sum(tag %in% names(count_tags)) > 0){
      count_tags[[tag]] = count_tags[[tag]] + 1
    }else{
      count_tags[[tag]] = 1
    }
  }
  x <- which.max(count_tags)[[1]]
  num <- max(count_tags[[x]])
  tags <- ""
  for(k in 1:length(count_tags)){
    if(count_tags[[k]] == num){
      tags <- paste0(tags, names(count_tags)[k])
    }
  }
  max_tags <- c(max_tags, tags)
  max_tags_num <- c(max_tags_num, num)
  #print(count_tags)
}
df <- data.frame(id, all_tags, max_tags, max_tags_num)
profile <- merge (x = profile, y = df, by='id', all.x = TRUE)
profile <- profile[!(profile$sellnum == 0 & profile$dailynum ==0), ]
#View(profile)
#형변환
profile$like_mean_7 <- as.numeric(profile$like_mean_7)
profile$like_mean_all <- as.numeric(profile$like_mean_all)
View(profile)
View(post)
#다음주의 followernum 추출
post2 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수거만/50/0501_post_50_정수.xlsx")
profile2 <- read_excel("C:/Users/정수/8%_project_python__int/원본데이터/정수거만/50/0501_profile_50_정수.xlsx")
#문자->숫자
profile2$followernum <- gsub(",","",profile2$followernum)
profile2$followernum <- as.numeric(profile2$followernum)
profile2_follower<- profile2[,c("id","followernum")]
#View(profile2_follower)
profile <- inner_join(profile,profile2_follower, by = 'id')
str(profile)
profile$post_upload <- as.numeric(profile$post_upload)


View(profile)
#excel 파일로 export
write.xlsx(post, file ="C:/Users/정수/8%_project_python__int/r분석/원본데이터/내거만/50/0424_50_merge_company_post.xlsx")
write.xlsx(profile, file ="C:/Users/정수/8%_project_python__int/r분석/원본데이터/내거만/50/0424_50_merge_company_profile.xlsx")