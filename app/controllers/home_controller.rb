require "rubygems"
require "mechanize"

class HomeController < ApplicationController
  def index
  end

  def search
      title = params[:title]
      @val = ""
      searchfk(title)
      render :layout => false
  end
  
  def searchfk(title)
      page = getPage("http://www.flipkart.com/search/a/books?query="+title)
      page.search('div.fk-inf-scroll-item').each do |ele|
          imglink = ele.css('a img')[0]['data-src']
          title = (ele.css('div.lu-title-wrapper a')[0].text).strip
          begin
            author = (ele.css('div.lu-title-wrapper a')[1].text).strip
            publisher = (ele.css('div.year-released')[1].children[2].text).strip
          rescue
            author = ""
            publisher = ""
          end
          isbn = (ele.css('a')[1]['href']).split("?")[1].strip[4..16]
          mrp = ele.css('span.pu-old').text
          if(mrp == "")
            mrp = ele.css('div.pu-final').text
          end
          link = "/scrap?isbn=#{isbn}&title=#{title}&mrp=#{mrp}&author=#{author}&publisher=#{publisher}&imglink=#{imglink}"
          @val += "<table class='message_question' ><tr valign='top'>
                    <td width='65'><a href='#{link}'><img width='60' onerror='onImgErrorSmall(this)' src='#{imglink}' /></a></td>
                    <td >
                      <div class='heading'><a href='#{link}'> #{title} </a></div>
                      <div class='sub' style='font-family: cambria; font-size: 12px;'>
                        <table width='550'>
                          <tr>
                            <td width='100'>MRP : #{mrp}</td>
                            <td width='160'>Author : #{author}</td>
                            <td>Publisher : #{publisher}</td>
                          </tr>
                        </table>
                      </div>
                    </td>
                  </tr></table>"
      end
  end

end
