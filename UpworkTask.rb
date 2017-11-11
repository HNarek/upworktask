require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox

driver.manage().delete_all_cookies
driver.navigate.to "https://www.upwork.com"


element = driver.find_element(:id, 'q')
element.click

element2 = driver.find_element(:xpath, "//div[1]/div[1]/form/div/span");
element2.click

element3 = driver.find_element(:xpath, '//label[contains(text(),"Freelancers")]')
element3.click

element.send_keys(:enter)
wait = Selenium::WebDriver::Wait.new(timeout: 30)

wait.until { driver.find_element(id: "main-search").displayed? }

#######################################collect data
employees = Array.new(10)
i = 0

link = driver.find_elements(:tag_name, "section")
link.each do |section|
	employee = Hash.new( "employee" )

	classElement = section.find_elements(:class, "freelancer-tile-name")
		classElement.each do |itemClass|
			employee["name"] = itemClass.text()
			employee["href"] = itemClass.attribute("href")
		end
		
	classElement = section.find_elements(:class, "freelancer-tile-description")
		classElement.each do |itemClass|
			employee["title"] = itemClass.text()
		end
	i = i + 1
	
	if !employee.empty?
		employees[i] = employee
	end	
  end

  #puts employees
#######################################get random  
  #employees.shuffle.first
  num = Random.new
  sizeEmployees = employees.size
  random_employee = employees[num.rand(sizeEmployees)]
#######################################navigate to user profile
	if !random_employee["href"].empty? || !random_employee["href"] = nil
		driver.get random_employee["href"]
		wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		wait.until { driver.find_element(id: "oProfilePage").displayed? }
		
		classElement3 = driver.find_element(id: "oProfilePage")
			classElement4 = classElement3.find_element(:class, "m-xs-bottom")
				classElement5 = classElement3.find_element(:tag_name, "span")
			
			puts classElement5.text()
		
		
		#puts classElement
		#elementSpan = driver.find_element(:xpath, '//*[@id="optimizely-header-container-default"]//h2[@class="m-xs-bottom"]/span')
	

		
		classElement5.text() == random_employee["name"]	
	end
  



