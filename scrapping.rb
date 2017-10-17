require "rubygems"
require "google_drive"
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pp'


# GoogleDrive.login("tim.garret83@gmail.com", "uj6ow3gj")

def get_the_email_of_a_townhal_from_its_webpage(url)
    page = Nokogiri::HTML(open("#{url}"))
    email = page.xpath('//table/tr[3]/td/table/tr[1]/td[1]/table[4]/tr[2]
    					/td/table/tr[4]/td[2]/p/font')
    
    email.text

end

def get_all_the_urls_of_var_townhalls(url)
     session = GoogleDrive::Session.from_config("config.json")
     ws = session.spreadsheet_by_key("1_u_DvOSPzYY7UOK7ny2KO4vCQ9apF7b8EK5aztuYzx0").worksheets[0]
    towns_mail_list = Hash.new()
    i = 3 

    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/var.html"))
    page.xpath('//a[@class="lientxt"]').each do |town|
        town_name = town.text.downcase
        town_name = town_name.split(' ').join('-')
    proper_town_name = town_name.capitalize
        url = "http://annuaire-des-mairies.com/83/#{town_name}.html"
        towns_mail_list[proper_town_name] = get_the_email_of_a_townhal_from_its_webpage(url)
    end

     towns_mail_list.each do |key, value|
            puts "#{key}: #{value} "
             i += 1
              ws[i, 1] = "#{key}"
              ws[i, 2] = "#{value}"
                ws.save    
     end
    
        # obj = JSON.parse(json)
        # json = File.read('input.json')
        # pp obj
end

get_all_the_urls_of_var_townhalls("http://annuaire-
						des-mairies.com/var.html")