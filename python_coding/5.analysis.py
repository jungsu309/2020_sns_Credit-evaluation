#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
from datetime import datetime


# In[3]:


#임시 데이터 가져오기.
df = pd.read_csv('210127company_post_1차_데이터분석.csv',engine='python')


# In[4]:


#날짜 전처리
df['date'] = pd.to_datetime(df['date'],format='%Y년 %m월 %d일')


df['년'] = df['date'].dt.year
df['월'] = df['date'].dt.month

df['days'] = df['date'].dt.dayofyear

#좋아요를 ,제거하고 int형식으로 바꾸기
df['likes'] = df.likes.str.replace(',', '').astype('int64')


year = df['년'].max()
#최신년과 그 이전년도 12월 데이터만 다룸.
recent_year = df[(df['년'] == df['년'].max()) | ( (df['년'] == df['년'].max() -1) & (df['월'] == 12))]
# 전년도 는 1월~ 11월 지워지고 12월만 남음.
#최신년도와 전년도 12월만 남음
#recent_year


# In[5]:


#한사람의 계정이니까 예시로 congzzi_의 게시물만 이용.(임시)

recent_year = recent_year[recent_year['id'] == 'congzzi_']
# recent_year


# In[6]:


#id별로 최신글이제일 윗쪽에 위치하게끔 정렬하기. + 그룹의 상위 첫번째 값을 가져오기 = 최신값을 가져오기
#id별 최신 게시글이 해당됨.

df2 = recent_year.sort_values(by=["id", "년", "days"], ascending=[True, False, False]).head(1)

df2 = df2[['id','days']]
df2


# In[7]:


join = pd.merge(recent_year,df2, on="id")
# join


# In[8]:


#최근 30일이라서 나중에 30으로 바꾸면 됨. 335는 1월과 12월 비교할때 사용.
#근데 만약 2020 7월 게시글과 2021 7월 게시글이 동시에 존재한다면? ->이미 전년도 7월 데이터는 없다.
recent_30 = join[((join['days_y'] - join['days_x'] > 0 ) & (join['days_y'] - join['days_x'] < 5)) | (join['days_x'] - join['days_y'] > 335)]

#최근 30일간의 게시글 데이터
# recent_30


# In[9]:


#그룹별 좋아요 평균을 id순서대로 위치시킨다.

recent_30_like_mean = recent_30['likes'].mean()

# recent_30_like_mean


# In[11]:


#좋아요 평균을 팔로우 평균으로 나누기.아래는 임시로 값 지정
follower = 3000
like_per_follower = recent_30_like_mean/follower

# like_per_follower


# In[ ]:


import pandas as pd
from datetime import datetime


# In[ ]:



#날짜별 차이

df = pd.read_csv('C:/Users/Nahyun/JupyterFiles/210127company_post_1_.csv', encoding = "cp949")
#날짜 전처리
df['date'] = pd.to_datetime(df['date'],format='%Y년 %m월 %d일')
df['년'] = df['date'].dt.year
df['월'] = df['date'].dt.month
df['days'] = df['date'].dt.dayofyear
year = df['년'].max()
#최신년과 그 이전년도 12월 데이터만 다룸.
recent_year = df[(df['년'] == df['년'].max()) | ( (df['년'] == df['년'].max() -1) & (df['월'] == 12))]
df_fra = recent_year.sort_values(by=["id","년", "days"], ascending=[True, False, False])
#id 오름차순 
#days 내림차순
df_fra = df2[['no','id','location','tags','contents','date','likes']]
df_fra


# In[ ]:


import pandas as pd


# In[ ]:


#판매글/일상글 구분하는 파이썬 코드

df = pd.read_csv('C:/Users/joanl/산학연계 프로젝트/R분석/210127company_post_1_.csv', encoding = "cp949")
#"일상"이라는 단어가 들어가있는 행들 뽑기
df_bool = df['contents'].str.contains("일상")
df_concat = pd.concat([df, df_bool], axis = 1)
df_concat.columns = ['no', 'url', 'id', 'location', 'tags', 'contents', 'date', 'likes', 'daily']
#df_concat       
df_daily = df_concat[df_concat['daily'] == True]
#'일상' 단어가 없는 경우 = 판매글 이라고 판단하겠음
df_selling = df_concat[df_concat['daily'] == False]
#df_daily_sell = df_daily[df_daily['contents'].isin(target)]
#일상글 중 판매글인 경우 찾기
df_daily_sell = df_daily[(df_daily['contents'].str.contains("문의"))
                        | (df_daily['contents'].str.contains("이벤트"))
                        | (df_daily['contents'].str.contains("주문"))
                        | (df_daily['contents'].str.contains("공구"))
                        | (df_daily['contents'].str.contains("협찬"))
                        | (df_daily['contents'].str.contains("판매"))
                        | (df_daily['contents'].str.contains("마켓"))
                        | (df_daily['contents'].str.contains("블로그"))
                        | (df_daily['contents'].str.contains("링크"))
                        | (df_daily['contents'].str.contains("세일"))
                        | (df_daily['contents'].str.contains("할인"))
                        | (df_daily['contents'].str.contains("카톡"))
                        | (df_daily['contents'].str.contains("카카오톡"))
                        | (df_daily['contents'].str.contains("구매"))
                        | (df_daily['contents'].str.contains("구입"))
                        | (df_daily['contents'].str.contains("다이렉트"))
                        | (df_daily['contents'].str.contains("택배"))
                        | (df_daily['contents'].str.contains("배송"))
                        | (df_daily['contents'].str.contains("제품"))
                        | (df_daily['contents'].str.contains("상품"))
                        | (df_daily['contents'].str.contains("스토어"))
                        | (df_daily['contents'].str.contains("상점"))
                        | (df_daily['contents'].str.contains("입금"))
                        | (df_daily['contents'].str.contains("플랫폼"))
                        | (df_daily['contents'].str.contains("DM"))
                        | (df_daily['contents'].str.contains("디엠"))
                        | (df_daily['contents'].str.contains("가격"))
                        | (df_daily['contents'].str.contains("오픈"))
                        | (df_daily['contents'].str.contains("kakaotalk"))
                        | (df_daily['contents'].str.contains("shop"))
                        | (df_daily['contents'].str.contains("쇼핑몰"))
                        | (df_daily['contents'].str.contains("샵"))
                        | (df_daily['contents'].str.contains("open")) ]
#print(df_daily_sell) # 일상글이면서 판대글인 애들 = 판매글
#print(df_daily)
df_join = pd.merge(df_daily, df_daily_sell, how = 'left', on = ['no', 'url', 'id', 'location', 'tags', 
                                                                'contents', 'date', 'likes'])
#온전히 일상글인 목록
df_daily = df_join[df_join['daily_y'].isnull()]
df_daily = df_daily.drop('daily_x', axis = 1)
print(df_daily)
df_selling_total = pd.concat([df_selling, df_daily_sell]) #판매글 전체 목록
df_selling_total
#df_selling_total_sort = df_selling_total.sort_values(by = 'id') 여러명인 경우에 사용. 한사람이면 사용X
#df_selling_total_sort #daily = True인 행들은 일상글이면서 판매글인 경우

