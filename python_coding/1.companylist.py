#!/usr/bin/env python
# coding: utf-8

# In[2]:


from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import pymysql
import time
import datetime
import demoji
# 이모지 제거
demoji.download_codes()
###
def loginUrl(user_id, user_pw):
    try:
        url = "https://www.instagram.com/"
        driver = webdriver.Chrome("./chromedriver.exe")
        driver.get(url)
        time.sleep(2)
        driver.find_element_by_name("username").send_keys(user_id)
        driver.find_element_by_name("password").send_keys(user_pw)
        driver.find_element_by_xpath("//*[@id=\"loginForm\"]/div/div[3]/button").submit()
        time.sleep(3)
        driver.find_element_by_xpath("//*[@id=\"react-root\"]/section/main/div/div/div/div/button").click()
        time.sleep(3)
        driver.find_element_by_xpath("/html/body/div[4]/div/div/div/div[3]/button[2]").click()
        insta_search(driver, search)
    except:
        print("잘못된 아이디 또는 비밀번호입니다.")
###
def insta_search(driver, search):
    url_tmp = driver.current_url
    url = "https://www.instagram.com/explore/tags/{search}/?hl=ko".format(search=search) # 검색어로 찾기
    driver.get(url)
    time.sleep(2)
    insta_postList(driver)
###
def insta_postList(driver):
    url = driver.current_url
    insta_post_Urls_List = []
    driver.get(url)
    time.sleep(2)
    # 일정 시간동안 스크롤
    start = datetime.datetime.now()
    end = start + datetime.timedelta(seconds = 100)
    time.sleep(2)
    while True :
        insta_post_Urls = driver.find_elements_by_css_selector(".Nnq7C.weEfm .v1Nh3.kIKUG._bz0w a")
        for urlList in insta_post_Urls:
            insta_post_Urls_List.append(urlList.get_attribute("href"))
        driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
        time.sleep(2)
        if datetime.datetime.now() > end:
            break
    insta_post_Urls_List = list(set(insta_post_Urls_List))
    print(len(insta_post_Urls_List))
    insta_accounts(driver,insta_post_Urls_List)
###

def insta_accounts(driver,insta_post_Urls_List):
    company=[]
    for urlList in insta_post_Urls_List:
        driver.get(urlList)
        time.sleep(1)
        try:
            driver.find_element_by_xpath('//*[@id="react-root"]/section/main/div/div[1]/article/header/div[2]/div[1]/div[1]/span/a').click()
            time.sleep(3)
            # 팔로워 수 출력
            userIDList = driver.find_elements_by_css_selector("._7UhW9.fKFbl.yUEEX.KV-D4.fDxYl")
            userID = userIDList[0].text # 아이디
            userInfoList = driver.find_elements_by_css_selector(".g47SY")
            userFollower = userInfoList[1] # 팔로워 수
            userFollowerReal = userFollower.get_attribute('title')
            if userFollower.text.find('백') == -1 and userFollower.text.find('천') == -1 and userFollower.text.find('만') == -1:
                userFollower = userFollower.text
            else:
                userFollower = userFollowerReal
            time.sleep(1)    
            print("\n")
            print("- 인스타그램 아이디 : " + userID)
            print("- 팔로워 수 : " + userFollower)
            print("\n")
            # 소개글
            intro = ""
            try:
                userInfoList = driver.find_elements_by_css_selector(".-vDIg span")
                intro = userInfoList[0].text
                intro = demoji.replace(intro," ")
                print(intro)
            except:
                continue
            # 인증 여부
            checks = ""
            checkList = driver.find_elements_by_css_selector(".Igw0E.IwRSH.eGOV_._4EzTm.soMvl")
            for check in checkList:
                checks = checks + check.text
            #팔로워수 제한
            userFollower = userFollower.replace(',', '')
            if checks.find('인증됨') == -1 and int(userFollower) <= 100000:
                for word in ['문의', '이벤트', '주문', '공구', '협찬', '판매', '마켓', '블로그', '링크', '세일', '할인', '카톡',
                            '카카오톡', '구매', '구입', '다이렉트', '택배', '배송', '제품', '상품', '스토어', '상점', '입금',
                            '플랫폼', 'DM', '디엠', '가격','오픈', 'kakaotalk', 'shop', '쇼핑몰', '샵','open']:
                    if intro.find(word) != -1:
                        company.append(userID)
                        break
        except:
            continue
    add_company(company)
###
def add_company(company):
    # 중복 제거
    f = open("C:/Users/정수/8%_project_python__int/8percent_company.txt", 'r')
    lines = f.readlines()
    companyList = company + lines
    companySet = set(companyList)
    f.close()
    # 메모장에 저장
    f = open("C:/Users/정수/8%_project_python__int/8percent_company.txt", 'w')
    for account in companySet:
        data = account + "\n"
        f.write(data)
    f.close()
###
#서안: '마켓', '쇼핑몰', '패션', '이벤트', '블로그마켓', '화장품'
#동두:  '주문제작', '스토어팜', '구제', '데일리룩', '자체제작', '여성의류'
#두유:  '아이폰케이스', '옷가게', '목걸이', '팔찌', '코디', '데일리코디'
#시엔: '베이킹', '맛집', '카페', '핸드메이드', '광고'

hashtagList = ['주문제작', '스토어팜', '구제', '데일리룩', '자체제작', '여성의류']
for hashtag in hashtagList:
    user_id = "jjungsu_drawing"
    user_pw = "jsjs532525!!"
    search = hashtag
    loginUrl(user_id, user_pw)


# In[ ]:





# In[ ]:




