require 'json'

# Sort array of users by last name
#
# @param [Array, #users] users to be sorted
# @return [Array, #users] sorted users
def order_users_by_last_name(users)
  users.sort_by { |user| user['last_name'] }
end

# Sort array of companies by id
#
# @param [Array, #companies] companies to be sorted
# @return [Array, #companies] sorted companies
def order_companies_by_id(companies)
  companies.sort_by { |company| company['id'] }
end

# filter and group our users for a particular company
#
# @param [Array, #users] users to be filtered and grouped
# @param [Object, #company] company specific info
# @return [Array, #users] filtered and grouped users by status
def group_users_by_company(users, company)
  users
    .select { |user| user['company_id'] == company['id'] && user['active_status'] == true }
    .map { |user| user.merge!({ 'tokens_topped_up' => user['tokens'] + company['top_up'] }) }
    .group_by { |user| company['email_status'] && user['email_status'] ? :emailed : :not_emailed }
end

# sum all the tops ups for a given company
#
# @param [Array, #users] users
# @param [Object, #company] company specific info
# @return [int] sum of all the top ups
def sum_top_ups_for_company(users, company)
  (
    (users[:emailed].nil? ? 0 : users[:emailed].length) +
    (users[:not_emailed].nil? ? 0 : users[:not_emailed].length)
  ) * company['top_up']
end

# generate raw challenge data for our companies and users
#
# @param [Array, #users] users
# @param [Array, #companies] companies
# @return [Array] raw array of hashed data
def generate_challenge_data(companies, users)
  companies&.map { |company|
    grouped_users_in_this_company = group_users_by_company(users, company)
    {
      'company' => company,
      'emailed' => grouped_users_in_this_company[:emailed],
      'not_emailed' => grouped_users_in_this_company[:not_emailed],
      'total_top_ups' => sum_top_ups_for_company(grouped_users_in_this_company, company)
    }
  }
end

# rehsapes raw users data into our file specific format
#
# @param [Array, #users] users
# @return [String] string in our desired format ready to write to our file
def reshape_users_for_file(users)
  users&.map { |row|
    "\t#{row['last_name']}, #{row['first_name']}, #{row['email']}\n"\
    "\t\tPrevious Token Balance #{row['tokens']}\n"\
    "\t\tNew Token Balance #{row['tokens_topped_up']}\n"\
  }&.join('')
end

# rehsapes raw challenge data into our file specific format
#
# @param [Array, #companies] companies
# @return [String] string in our desired format ready to write to our file
def reshape_companies_for_file(companies)
  companies&.map { |row|
    "Company Id: #{row['company']['id']}\n"\
    "Company Name: #{row['company']['name']}\n"\
    "Users Emailed:\n"\
    "#{reshape_users_for_file(row['emailed'])}"\
    "Users Not Emailed:\n"\
    "#{reshape_users_for_file(row['not_emailed'])}"\
    "Total amount of top ups for #{row['company']['name']}: #{row['total_top_ups']}"\
  }&.join("\n\n")
end

# dump our shaped data to the file
#
# @param [String] data
def output_text_file(data)
  File.write('output.txt', data)
end

companies = order_companies_by_id(JSON.parse(File.read('companies.json')))
users = order_users_by_last_name(JSON.parse(File.read('users.json')))

challenge_data = generate_challenge_data(companies, users)
reshaped_challenge_data = reshape_companies_for_file(challenge_data)

output_text_file(reshaped_challenge_data)
