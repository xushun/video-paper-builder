Then /^I create a new video paper named "([^\"]*)"$/ do |title|
  fill_in "video_paper_title", :with => title
  click_button "Enter in notes"
end

When /^I edit the video paper title named "([^\"]*)"$/ do |title|
  When "I go to #{title}'s video paper edit page"
  fill_in "video_paper_title", :with => "Updated #{title}"
  click_button "Enter in notes"
end

Then /^I should see an embedded video$/ do
  page.should have_css('#kplayer')
end

Then /^I should not see an embedded video$/ do
  page.should_not have_css('#kplayer')
end

When /^I pre-confirm$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

Then /^I destroy video paper named "([^\"]*)"$/ do |title|
  When "I go to my video papers page"
  Then "I pre-confirm"
  click_link_or_button("Remove")
end
