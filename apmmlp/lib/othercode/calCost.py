import requests
from PyPDF2 import PdfReader
from pdf2image import convert_from_bytes
import tempfile
import io
import os
import numpy as np

from flask import Flask,request
app = Flask(__name__)
@app.route("/price",methods= ["POST","GET"])

def price():
  link=request.get_json()
  pdf_url=link['pdfurl']

# pdf_url = 'https://firebasestorage.googleapis.com/v0/b/usingfirebase-ccaa7.appspot.com/o/pdfs%2FT1.pdf.pdf?alt=media&token=a76bd3ab-bea9-4215-97bf-b4073ab44043'
  
  # pdf_url=url
  response = requests.get(pdf_url)
  total=0
  l=0
  opac=[]
  if response.status_code == 200:
    pdf_content = response.content
    # Convert the PDF to an image
    images = convert_from_bytes(pdf_content, dpi=100)
    l=len(images)

    for i in range(0,l):
      img_ary=np.array(images[i])
      count=0
      price=0
      h=images[i].height
      w=images[i].width
      t=h*w
      for x in range(0,h):
        for y in range(0,w):
          if (img_ary[x][y][0]==255 and img_ary[x][y][1]==255 and img_ary[x][y][2]==255):
            count+=1
      var=1-(count/t)
      opac.append(var)
      if(var==1):
        price=20
      elif(var>=0.76 and var<=0.99):
        price=10
      elif(var>=0.56 and var<=0.75):
        price=7
      elif(var>=0.51 and var<=0.55):
        price=5
      elif(var>=0.26 and var<=0.50):
        price=3.5
      elif(var>=0 and var<=0.25):
        price=2.5

      total+=price
  
  obj={}
  obj['pagecount']=l
  obj['cost']=total
  obj['pdfurl']=pdf_url
  obj['opacity']=opac

  return obj

if __name__=='__main__':
  app.run(debug=True, port=2000) 