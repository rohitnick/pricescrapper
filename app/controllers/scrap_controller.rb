require "rubygems"
require "mechanize"
require "nokogiri"

class ScrapController < ApplicationController
  def index
      @isbn = params[:isbn]
      @title = params[:title]
      @mrp = params[:mrp]
      @author = params[:author]
      @publisher = params[:publisher]
      @imglink = params[:imglink]
  end
  
  def getbook
      isbn = params[:isbn]
      @val = ""
      @site = Array.new(7) { Array.new(5) }
      scrapfk(isbn, 1)
      scrapba(isbn, 0)
      scrapmaansu(isbn, 2)
      scrapib(isbn, 3)
      scraplm(isbn, 4)
      scrapuread(isbn, 5)
      scrapcw(isbn, 6)
      render :layout => false
  end
  
  def scrapfk(isbn, i)
    @site[i][0] = "http://www.flipkart.com/search.php?query="+isbn
    @site[i][1]= "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/flipkart_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div.mprod-summary')
    if (ele.length == 0)
      @site[i][2] = "N.A" ; @site[i][3] = "N.A" ; @site[i][4] = "N.A"
    else
      @site[i][2] = ele.css('span.pprice').text.strip[3..-1]
      @site[i][3] = ele.css('div.shipping-details .fk-font-bold').text
      @site[i][4] = ele.css('div#fk-stock-info-id').text
      if(@site[i][4] == "")
        @site[i][4] = @site[i][3] ; @site[i][3] = "N.A"
      end
    end
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  def scrapba(isbn, i)
    @site[i][0] = "http://www.bookadda.com/books/"+isbn
    @site[i][1]= "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/bookadda_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div#prdctdetl')
    @site[i][2] = ele.css('span.actlprc').text.strip[3..-1]
    @site[i][3] = ele.css('span.numofdys strong').text
    @site[i][4] = ele.css('span.stckdtls').text
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  def scrapmaansu(isbn, i)
    @site[i][0] = "http://www.maansu.com/"+isbn
    @site[i][1]= "http://c223968.r68.cf1.rackcdn.com/maansu_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div.product-description')
    @site[i][2] = ele.css('span.price-red').text.strip[0..-3]
    @site[i][3] = ele.css('strong')[6].text
    @site[i][4] = ele.css('strong')[5].text
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  def scrapib(isbn, i)
    @site[i][0] = "http://www.infibeam.com/Books/search?q="+isbn
    @site[i][1]= "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/infibeam_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div#ib_details')
    @site[i][2] = ele.css('span.infiPrice').text
    @site[i][3] = ele.css('b')[1].text
    @site[i][4] = ele.css('span.status').text
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  def scraplm(isbn, i)
    @site[i][0] = "http://www.landmarkonthenet.com/books/msp/"+isbn
    @site[i][1] = "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/landmarkonthenet_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div.primary .clearfix')
    @site[i][2] = ele.css('span.price-current').text.strip[3..-1]
    @site[i][3] = ele.css('table.delivery-info td')[7].text
    @site[i][4] = ele.css('table.delivery-info td')[1].text
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  
  def scrapuread(isbn, i)
    @site[i][0] = "http://www.uread.com/search-books/"+isbn
    @site[i][1]= "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/uread_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div.product-detail-summary')
    if(ele.length == 0)
        @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
    else
      @site[i][2] = ele.css('label#ctl00_phBody_ProductDetail_lblourPrice span').text.strip[1..-2]
      @site[i][3] = ele.css('label#ctl00_phBody_ProductDetail_lblBusiness b').text
      @site[i][4] = ele.css('label#ctl00_phBody_ProductDetail_lblAvailable').text
      if( @site[i][4] == "")
          @site[i][4] = "In Stock"
      elsif(@site[i][4]== "Out of Stock")
          @site[i][3] = "N.A"
      end
    end
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
  def scrapcw(isbn, i)
    @site[i][0] = "http://www.crossword.in/books/search?q="+isbn
    @site[i][1]= "http://c0028655.cdn1.cloudfiles.rackspacecloud.com/crossword_store.png"
    page = getPage(@site[i][0])
    ele = page.search('div.variant-desc')
    if (ele.length == 0)
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
    else
      @site[i][2] = ele.css('span.variant-final-price').text.strip[1..-1]
      @site[i][3] = ele.css('span.ships-in b').text
      @site[i][4] = ele.css('span.in-stock b').text
      if (@site[i][4] == "")
         @site[i][3] = "N.A" ; @site[i][4] = "Out of Stock"
      end
    end
    rescue
      @site[i][2] = "N.A" ;  @site[i][3] = "N.A" ; @site[i][4] = "N.A"
  end
  
end
