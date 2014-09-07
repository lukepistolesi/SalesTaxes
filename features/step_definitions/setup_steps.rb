Given(/^no keywords for items classification are set$/) do
  CucumberHelper.classification_keywords = {}
end

Given(/^the following classification keywords are set$/) do |table|
  keywords = {}
  table.hashes.each do |row|
    keywords[row['Category'].downcase.to_sym] = row['Keywords']
  end
  CucumberHelper.classification_keywords = keywords
end
