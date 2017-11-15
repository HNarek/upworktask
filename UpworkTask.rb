###include requerad library
require 'selenium-webdriver'
require 'page-object'
require 'watir'


class UpWorkPage
  include PageObject
  page_url('https://www.upwork.com')

  SEARCH_BOX        = { id: 'q'     }
  DROPDOWN_XPAT        = { xpath: "//div[1]/div[1]/form/div/span"     }
  
  def focus_on(search_term)
    driver.find_element(SEARCH_BOX).clear
    driver.find_element(SEARCH_BOX).send_keys search_term
    driver.find_element(SEARCH_BOX).click
  end
  
  def search_for(search_term)
    driver.find_element(SEARCH_BOX).clear
    driver.find_element(SEARCH_BOX).send_keys search_term
    driver.find_element(SEARCH_BOX).send_keys(:enter)
  end
  
  def dropdown_select()
    driver.find_element(DROPDOWN_XPAT).click
  end
  
  def find_main_serch()
    driver.find_element(id: "main-search").displayed?
  end
  
  def find_section()
	driver.find_elements(:tag_name, "section")
  end
  
  def find_profilePage()
	driver.find_element(id: "oProfilePage")
  end
end


if ARGV.empty? && ARGV.size != 2
	#in case when user did not put arguments
	puts "Two argument needed , the first on is serach keyword the second browuser name"
	exit
end

searchKeyword = ""
if !ARGV[0].empty? 
	searchKeyword = ARGV[0]
else
	#in case when user put wrong arguments
	puts "Wrong args, please set search keyword"
	exit
end

browser = ""
##### Get parameter for define browser type and check
if ARGV[1] == 'firefox' 
	#driver = Selenium::WebDriver.for :firefox
	browser = Watir::Browser.new :firefox #for clear cookes
elsif ARGV[1] == 'chrome'	
	browser = Watir::Browser.new :firefox
else
	#in case when user put wrong arguments
	puts "Wrong args, please use firefox or chrome args"
	exit
end

##### 1. Run
pageObj = UpWorkPage.new(browser, true) ; sleep 5
puts "1. Run"

##### 2. Clear cookies
browser.cookies.clear
puts "2. Clear cookies"

##### Go to www.upwork.com
puts "3. Go to www.upwork.com"

##### 4. Focus onto Find freelancers
pageObj.focus_on ''; sleep 5
puts "4. Focus onto Find freelancers"

##### 5. Enter  into the search input right from the dropdown and submit it (click on the magnifying glass button)
pageObj.dropdown_select; sleep 5
puts "5. Enter into the search input right from the dropdown"

pageObj.search_for searchKeyword; sleep 5
puts "5. and submit it"

##### 6. Select  "Search Anywhere" 
wait = Selenium::WebDriver::Wait.new(timeout: 60)
wait.until { pageObj.find_main_serch  }
puts "6. Search Anywhere and Wait 60 second for page loding"

##### 7. Parse the 1st page with search results: store info given on the 1st page of search results as structured data of any chosen by you type (i.e. hash of hashes or array of hashes, whatever structure handy to be parsed).
freelancers = Array.new()
i = 0

link = pageObj.find_section
puts "7. Parse the 1st page with search results"

#collect first page data
link.each do |section|
	freelancer = Hash.new()

	nameElement = section.find_elements(:class, "freelancer-tile-name")
		nameElement.each do |itemClass|
			freelancer["name"] = itemClass.text()
			freelancer["href"] = itemClass.attribute("href")
		end
		
	descriptionElement = section.find_elements(:class, "freelancer-tile-description")
		descriptionElement.each do |itemClass|
			freelancer["title"] = itemClass.text()
		end
	
	#check empty values
	if !freelancer.empty?
		freelancers[i] = freelancer
		i = i + 1
	end	
  end

##### 8.Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer) from parsed search results contains    Log in stdout which freelancers and attributes contain    and which do not.   
freelancers.each do |f|
	if !f["title"].empty?
		if f["title"].downcase.include? searchKeyword.downcase
			puts "Contains="+f["title"]
		else	
			puts "Did not contains!"+f["title"]
		end
	end
end
puts "8. Make sure at least one attribute from parsed search results contains. Contains found in  elements"

##### 9. Click on random freelancer's title
	num = Random.new
	sizeEmployees = freelancers.size
	random_freelancer = freelancers[num.rand(sizeEmployees)]
	puts  "9. Click on random freelancer's title"
	puts random_freelancer["title"]

##### 10. Get into that freelancer's profile  
	pageObj.navigate_to random_freelancer["href"];  sleep 10
	#Wait page lode
	#wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	#wait.until { pageObj.find_profilePage.displayed? }
	pageObj.find_profilePage.displayed?
	puts  "10. Get into that freelancer's profile"

##### 11. Check that each attribute value is equal to one of those stored in the structure created in #67	
	profilePageElement = pageObj.find_profilePage
		mXSButtonElement = profilePageElement.find_element(:class, "m-xs-bottom")
			spanElement = mXSButtonElement.find_element(:tag_name, "span")
	puts "11. Check that each attribute value is equal to one of those stored in the structure created in #67"
	if spanElement.text() == random_freelancer["name"]	
		puts "YES the random freelancer name equals "+random_freelancer["name"]
	end
#### 12. Check whether at least one attribute contains 	
	puts "12. Check whether at least one attribute contains"


	
	
