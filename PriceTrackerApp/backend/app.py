#!/usr/bin/python -tt
# Importing necessary libraries and modules
from flask import Flask, jsonify, request
import requests
from bs4 import BeautifulSoup
from flask_cors import CORS, cross_origin
import time
from modules import notification # Importing a custom module for FCM notifications


# Creating a Flask app instance and enabling CORS

app = Flask(__name__)
CORS(app, supports_credentials=True)

# Route for searching by word

@app.route('/search', methods=["POST", "GET"])
@cross_origin(supports_credentials=True, origins='*')
def getSearchItems():
        # Retrieving the link from the request arguments

    link = request.args.get('link')
        # Sending a GET request to the provided link and parsing the content

    r = requests.get(str(link))
    soup = BeautifulSoup(r.content, 'html.parser')
        # Initializing variables for product information extraction

    header = "https://www.flipkart.com"
    products = []
    Img_links = []
    pdt_link = []
    pdt_price = []
        # Looping through HTML elements to extract product information

    for data in soup.findAll('div', class_='_4ddWXP'):
      raw = data.find('a', attrs={'class': 's1Q9rs'})
      products.append(raw['title'])
      pdt_link.append(header+raw['href'])
             # ... (similar loops for other cases)

    if (products==[]) :
      for data in soup.findAll('div', class_='_2kHMtA'):
         raw = data.find('a', attrs={'class': '_1fQZEK'})
         temp = raw.find('div', attrs={'class':'_4rR01T'})
         products.append(temp.text)
      
         pdt_link.append(header+raw['href'])

      if (products==[]) :
          print ("am here")
          for data in soup.findAll('div', class_='_13oc-S'):
            raw = data.find('div', attrs={'class': '_1xHGtK _373qXS'})
            pdt_link_data=raw.find('a',{'class':'_2UzuFa'})
            temp = data.find('div',attrs={'data-id':'BKPGNPGX5QHCVZVH'}) 
            pdt_link.append(header+pdt_link_data['href'])
            names = raw.find('div',attrs={'class':"_2B099V"})
            product_names = names.find('a',attrs={'class':'IRpwTa'})
            products.append(product_names['title'])
            Img_link=pdt_link_data.find('div',attrs={'class':'_3ywSr_'})
            Img_link = Img_link.find('div',attrs={'class':'_312yBx SFzpgZ'})
            Img_link=Img_link.find('img',attrs={'class':'_2r_T1I'})    
            Img_links.append(Img_link['src'])        
            print(Img_links)
    for data in soup.findAll("div", class_='CXW8mj'):
      Img_link = data.find('img', attrs={'class': '_396cs4'})
      Img_links.append(Img_link['src'])
    for data in soup.findAll('div', class_='_25b18c'):
      price = data.find('div', class_='_30jeq3').get_text()
      pdt_price.append(price[1:].replace(',', ''))
    
        # Creating a JSON response

    x = jsonify({'products': products, 'img_data': Img_links,
                'pdt_link': pdt_link, 'price_lst': pdt_price})
    return x

#Search by link
@app.route('/q', methods=["POST", "GET"])
@cross_origin(supports_credentials=True, origins='*')
def getProduct():
       # Retrieving the link and expected amount from the request arguments

   link = request.args.get('link')
   exp_amt=request.args.get('ea')
       # Sending a GET request to the provided link and parsing the content

   r = requests.get(str(link))
   soup = BeautifulSoup(r.content, 'html.parser')
       # Extracting product details

   s = soup.find('span', class_='B_NuCI')
   price=soup.find('div', class_='_30jeq3 _16Jk6d')
   price = price.text[1:].replace(',', '')
   img_link = soup.find('img', class_="_396cs4 _2amPTt _3qGmMb")
      # ... (handling cases where img_link is None)

   if(img_link==None):
    img_link=soup.find('img',class_ = '_2r_T1I _396QI4')
   
       # Extracting product name from the span tag

   for line in s:
       pdt_name = (line.text)
       break
       # Creating a JSON response for product information

   pdt_inf = {"price": price, "img_link":img_link['src'],"pdt_name":pdt_name}

   return jsonify(pdt_inf)

# Route for the infinite loop and notification

@app.route('/notify',methods=['GET','POST'])
@cross_origin(supports_credentials=True, origins='*')
def notifier():
       # Retrieving link, expected amount, and token from the request arguments

   link = request.args.get('link')
   exp_amt=request.args.get('ea')
   token = request.args.get('token')
       # Sending a GET request to the provided link and parsing the content

   r = requests.get(str(link))
   soup = BeautifulSoup(r.content, 'html.parser')
      # Extracting price information and continuously checking for price drop

   price=soup.find('div', class_='_30jeq3 _16Jk6d')
   price = price.text[1:].replace(',', '')
   while(int(exp_amt)<int(price)):
        r = requests.get(str(link))
        soup = BeautifulSoup(r.content, 'html.parser')
        price=soup.find('div', class_='_30jeq3 _16Jk6d')
        price = price.text[1:].replace(',', '')
        time.sleep(secs=1800)
      # Extracting product name after price drop

   s = soup.find('span', class_='B_NuCI')
   for line in s:
       pdt_name = (line.text)
       break
      # Notifying about price drop using FCM_handler module

   pdt_inf="{}has reached{} Hurray!".format(pdt_name,price)
   notification.notify('Price Dropped',pdt_inf,[token])
   return jsonify({'Response':"Success"})


# Running the Flask app if executed directly

if __name__ == '__main__':

    app.run(debug=True, host='0.0.0.0')
