require 'json'

def order_users_by_last_name (users)
  users.sort_by { |user| user["last_name"] }
end

def order_companies_by_id (companies)
  companies.sort_by { |company| company["id"] }
end

def group_users_by_company (users, company)
  users.select {|user| user["company_id"] == company["id"] && user['active_status'] == true}
    .map { |user| 
      user["tokens_topped_up"] = user["tokens"] + company["top_up"]
      user
    }
    .group_by { |user| user["email_status"] ? :emailed : :not_emailed }    
end

def total_top_ups_for_company (users, company)    
  ((users[:emailed].nil? ? 0 : users[:emailed].length) + (users[:not_emailed].nil? ? 0 : users[:not_emailed].length)) * company["top_up"]
end

def reshape_users_for_file (users)
  shaped_data = ""
  if !users.nil?
    users.each do |row|
      shaped_data << "\t#{row['last_name']}, #{row['first_name']}, #{row['email']}\n"
      shaped_data << "\t\tPrevious Token Balance #{row['tokens']}\n"
		  shaped_data << "\t\tNew Token Balance #{row['tokens_topped_up']}\n"
    end
  end  

  shaped_data

end

def reshape_data_for_file (companies)
  shaped_data = ""

  companies.each do |row|
    shaped_data << "Company Id: #{row['company']['id']}\n"
    shaped_data << "Company Name: #{row['company']['name']}\n"    
    shaped_data << "Users Emailed: \n"
    shaped_data << reshape_users_for_file(row['emailed'])
    shaped_data << "Users Not Emailed: \n"
    shaped_data << reshape_users_for_file(row['not_emailed']) 
    shaped_data << "Total amount of top ups for #{row['company']['name']}: #{row['total_top_ups']} \n"
    shaped_data << "\n"
  end

  shaped_data
end  

=begin
def find_users_by_company (company_id, users)
  users.select {|user| user["company_id"] == company_id && user['active_status'] == true}
end

def group_users_by_status (users)
  users.group_by { |user| user["email_status"] ? :emailed : :not_emailed }
end

#users_in_this_company = find_users_by_company(company["id"], users)
  #topped_up_users_in_this_company = users_in_this_company.map { |user| 
  #  user["tokens_topped_up"] = user["tokens"] + company["top_up"]
  #  user
  #}
  #grouped_users_in_this_company = group_users_by_status(topped_up_users_in_this_company)
=end

companies = order_companies_by_id(JSON.parse(File.read('companies.json')))
users = order_users_by_last_name(JSON.parse(File.read('users.json')))

challenge_data = companies.map { |company|
  grouped_users_in_this_company = group_users_by_company(users, company)          
  {
      "company" => company,    
      "emailed" => grouped_users_in_this_company[:emailed],
      "not_emailed" => grouped_users_in_this_company[:not_emailed],
      "total_top_ups" => total_top_ups_for_company(grouped_users_in_this_company, company)
    }
   
}

#puts challenge_data
reshaped_challenge_data = reshape_data_for_file(challenge_data)

puts reshaped_challenge_data

#output_file(challenge)

# read files
# users that belong to company
# group by status
# top up
# accumulate 