from asyncio import sleep
from errno import ENODATA
import json
import linecache
from msilib.schema import SelfReg
from multiprocessing import process
import os
import glob
import time
from dotenv import load_dotenv
from flask import Flask, request, jsonify
import urllib


app = Flask(__name__)

@app.route('/', methods=['POST','GET']) 
def foo():
# write into .text.txt    
    if request.method == 'POST':
        data = request.json     
        json_object = json.dumps(data)        
        files = glob.glob('var.json')
        for f in files:
            os.remove(f)
        with open('var.json', 'a') as file:
            file.write(json_object)
        #envdata = json.load(open('var.json'))    
        #files = glob.glob('.env')
        #for f in files:
        #    os.remove(f)
        #with open('.env', 'a') as f:
        #    for key, value in ENODATA.items():
        #         f.write(f"{key.upper()}={value}\n")      
        load_dotenv('.env')
        password = os.environ.get("APPNAME")
        pic_url = os.environ.get("ICONPIC")
        my_str = '<string name="AppName">' 
        my_strr= '</string>' 
        new_line =f'{my_str} {password} {my_strr}'        
        particular_line = linecache.getline('android/app/src/main/res/values/strings.xml', 3)
        with open('android/app/src/main/res/values/strings.xml', 'r') as file :
            filedata = file.read()
            filedata = filedata.replace(particular_line, new_line + '\n')
        with open('android/app/src/main/res/values/strings.xml', 'w') as file:
            file.write(filedata)
        my_str1 = '<string>' 
        my_strr1= '</string>' 
        new_line1 =f'{my_str1} {password} {my_strr1}'    
        particular_line1 = linecache.getline('ios/Runner/info.plist', 8)
        with open('ios/Runner/info.plist', 'r') as file :
            filedata = file.read()
            filedata = filedata.replace(particular_line1, new_line1 + '\n')
        with open('ios/Runner/info.plist', 'w') as file:
            file.write(filedata)
        #with open("var.json") as jsonFile:
        #    jsonObject = json.load(jsonFile)
        #    jsonFile.close()
        #product = jsonObject['email']           
        #email_line = linecache.getline('codemagic.yaml', 25)    
        #with open('codemagic.yaml', 'r') as file1 :
            #filedata1 = file1.read()
            #filedata1 = filedata1.replace(email_line, '- '+product+'\n')
        #with open('codemagic.yaml', 'w') as file1:
            #file1.write(filedata1)
        #pic_url="https://firebasestorage.googleapis.com/v0/b/converttoapp.appspot.com/o/images%2Fbb0c0179-1a8e-46e1-b690-7d23a0442ee0?alt=media&token=e2828d10-7fee-414e-9c11-82afb2298e12"
        urllib.request.urlretrieve(pic_url, "C:\\Users\\soukaina\\Desktop\\Myflaskproject\\testflask\\android\\app\\src\\main\\res\\mipmap-hdpi\\ic_launcher.png") 
        urllib.request.urlretrieve(pic_url, "C:\\Users\\soukaina\\Desktop\\Myflaskproject\\testflask\\android\\app\\src\\main\\res\\mipmap-mdpi\\ic_launcher.png") 
        urllib.request.urlretrieve(pic_url, "C:\\Users\\soukaina\\Desktop\\Myflaskproject\\testflask\\android\\app\\src\\main\\res\\mipmap-xhdpi\\ic_launcher.png")  
        urllib.request.urlretrieve(pic_url, "C:\\Users\\soukaina\\Desktop\\Myflaskproject\\testflask\\android\\app\\src\\main\\res\\mipmap-xxhdpi\\ic_launcher.png")  
        urllib.request.urlretrieve(pic_url, "C:\\Users\\soukaina\\Desktop\\Myflaskproject\\testflask\\android\\app\\src\\main\\res\\mipmap-xxxhdpi\\ic_launcher.png")             
        time.sleep(20)       
        os.system("flutter run")       
    return "hello world"
    # run flutter to generate ios and apk using run methodshgh process to run flutter app from python flutter build apk / flutter build ios. I can do it
    # zip ios and apkdfgsfgfrsrfghwskjdc nkjdnk:gfhfg
    # send zip to client using email adresse 
    #hello worl please work
    #waaahhhlnjn
if __name__ =='__main__':
    app.run()    
