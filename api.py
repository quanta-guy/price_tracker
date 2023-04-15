#!/usr/bin/python -tt
from flask import Flask,jsonify,request
import requests
from bs4 import BeautifulSoup
from flask_cors import CORS, cross_origin


app=Flask(__name__)
CORS(app, supports_credentials=True)
@app.route('/getPrice', methods=["POST","GET"] )
@cross_origin(supports_credentials=True,origins='*')
def getValue():
   link = request.args.get('link')
   r=requests.get(str(link))
   soup = BeautifulSoup(r.content,'html.parser')
   response=soup.find('div',class_='_30jeq3 _16Jk6d').get_text()
   price = response[1:].replace(',','')
   response=jsonify(price)
   response.headers.add("Access-Control-Allow-Origin","*")
   return response

if __name__ == '__main__':
  
    app.run(debug = False, host='0.0.0.0')