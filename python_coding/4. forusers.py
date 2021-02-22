#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import pymysql
import time
import datetime
# 이모지 제거
import demoji
#demoji.download_codes()
# Data Table
import pandas as pd
from pandas import Series, DataFrame
import numpy as np
def loginUrl(user_id, user_pw):
    try:
        url = "https://www.instagram.com/"
        driver = webdriver.Chrome("./chromedriver.exe")
        driver.get(url)
        time.sleep(2)
        driver.find_element_by_name("username").send_keys(user_id)
        driver.find_element_by_name("password").send_keys(user_pw)
        time.sleep(2)
        driver.find_element_by_xpath("//*[@id=\"loginForm\"]/div/div[3]/button").submit()
        time.sleep(3)
            # 로그인 정보 저장 나중에 하기
        driver.find_element_by_xpath("//*[@id=\"react-root\"]/section/main/div/div/div/div/button").click()
        time.sleep(2)
            # 알림 설정 나중에 하기
        driver.find_element_by_xpath("/html/body/div[4]/div/div/div/div[3]/button[2]").click()
        accountSearch(driver)
    except:
        print("잘못된 아이디 또는 비밀번호입니다.")
def accountSearch(driver):
    url = driver.current_url
    driver.get(url)
    driver.find_element_by_xpath('/html/body/div[1]/section/nav/div[2]/div/div/div[3]/div/div[5]/span/img').click()
    driver.find_element_by_xpath('//*[@id="react-root"]/section/nav/div[2]/div/div/div[3]/div/div[5]/div[2]/div[2]/div[2]/a[1]/div').click()
    time.sleep(2)
    accountInfo(driver)
def accountInfo(driver):
    url = driver.current_url
    driver.get(url)
    userIDList = driver.find_elements_by_css_selector("._7UhW9.fKFbl.yUEEX.KV-D4.fDxYl")
    userID = userIDList[0].text # 아이디
    userInfoList = driver.find_elements_by_css_selector(".g47SY")
    userPost = userInfoList[0] # 게시물 수
    userFollower = userInfoList[1] # 팔로워 수
    userFollowing = userInfoList[2] # 팔로잉 수
    userPostReal = userPost.get_attribute('title')
    userFollowerReal = userFollower.get_attribute('title')
    userFollowingReal = userFollowing.get_attribute('title')
    if userPost.text.find('백') == -1 and userPost.text.find('천') == -1 and userPost.text.find('만') == -1:
        userPost = userPost.text
    else:
        userPost = userPostReal
    if userFollower.text.find('백') == -1 and userFollower.text.find('천') == -1 and userFollower.text.find('만') == -1:
        userFollower = userFollower.text
    else:
        userFollower = userFollowerReal
    if userFollowing.text.find('백') == -1 and userFollowing.text.find('천') == -1 and userFollowing.text.find('만') == -1:
        userFollowing = userFollowing.text
    else:
        userFollowing = userFollowingReal
    # 소개글
    intro = ""
    try:
        userInfoList = driver.find_elements_by_css_selector(".-vDIg span")
        intro = userInfoList[0].text
        intro = demoji.replace(intro," ")
    except:
        pass
    postList(driver)
def postList(driver):
    url = driver.current_url
    post_urls_list = []
    driver.get(url)
    time.sleep(2)
    # 스크롤 높이 가져옴
    last_height = driver.execute_script("return document.body.scrollHeight")
    while True:
        post_urls = driver.find_elements_by_css_selector("._2z6nI .Nnq7C.weEfm .v1Nh3.kIKUG._bz0w a")
        for url_list in post_urls:
            post_urls_list.append(url_list.get_attribute("href"))
        # 끝까지 스크롤 다운
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(5)
        # 스크롤 다운 후 스크롤 높이 다시 가져옴
        new_height = driver.execute_script("return document.body.scrollHeight")
        # 최근 100개만
        if len(post_urls_list) >= 100:
            break
        # 마지막 부분
        if new_height == last_height:
            break
        last_height = new_height
    # 중복 제거(필요한가?)
    post_urls_list = list(set(post_urls_list))
    print(len(post_urls_list))
    postInfo(driver, post_urls_list)
def postInfo(driver, post_urls_list):
    post = 0
    for url in post_urls_list:
        driver.get(url)
        time.sleep(2)
        try:
            # 계정 이름
            user_id = ""
            user_id_temp = driver.find_elements_by_css_selector(".sqdOP.yWX7d._8A5w5.ZIAjV")
            user_id = user_id_temp[0].text
            # 위치 정보
            location = ""
            location_temp = driver.find_elements_by_css_selector(".JF9hh")
            for loc in location_temp:
                location = location + loc.text
            # 해시태그
            tags = ""
            tags_temp = driver.find_elements_by_css_selector(".xil3i")
            for tag in tags_temp:
                tags = tags + tag.text
            # 게시글 본문
            content = ""
            content_temp = driver.find_elements_by_css_selector(".eo2As .EtaWk .P9YgZ .C4VMK span")
            content = content_temp[1].text
            content = demoji.replace(content," ")
            # 작성 날짜
            date = ""
            date_temp = driver.find_elements_by_css_selector("._1o9PC.Nzb55")
            for d in date_temp:
                d = d.get_attribute('title')
                date = date + d
            # 좋아요
            likes = ""
            try:
                like_temp = driver.find_elements_by_css_selector(".Nm9Fw span")
                likes = int(like_temp[1].text)
                likes = likes + 1
            except:
                looklike = driver.find_element_by_xpath("//*[@id=\"react-root\"]/section/main/div/div[1]/article/div[3]/section[2]/div/span").click()
                looklike_temp = driver.find_elements_by_css_selector(".vJRqr span")
                likes = looklike_temp[0].text
            user_post.loc[post]= [url, user_id, location, tags, content, date, likes]
            post = post + 1
        except:
            continue
user_post = pd.DataFrame(columns = ['url','id','location','tags','contents','date','likes'])
user_id = "아이디"
user_pw = "비번"
loginUrl(user_id, user_pw)
user_post

