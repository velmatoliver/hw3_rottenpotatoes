# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.inex(e2), "Wrong order"
end

Then /^I should see movies rated: (.*)/ do |rating_list|
  # ensure elements are (not)? visible by comparing
  # number of movies in the database, with the one shown
  # Then I should see PG,R movies
  ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
  rating_list.split(",").each do |field|
    assert ratings.include?(field.strip)
  end
end

Then /^I should not see movies rated: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
  rating_list.split(",").each do |field|
    assert !ratings.include?(field.strip)
  end
end

Then /I should see (none|all) of the movies/ do |filter|
  db_size = 0
  db_size = Movie.all.size if filter == "all"
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

When /^I (un)?check all the ratings$/ do | uncheck |
  Movie.all_ratings.each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end
