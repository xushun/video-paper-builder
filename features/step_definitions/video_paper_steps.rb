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

Given /^a video paper named "([^\"]*)"$/ do |title|
  paper = Factory(:video_paper, :title => title, :user => @current_user, :status => "unpublished")
end

Given /^a published video paper named "([^"]*)" with a private video$/ do |title|
  paper = Factory(:video_paper, :title => title, :user => @current_user, :status => "published")
  video = Factory(:video, :video_paper => paper, :private => true)
end

Given /^the video paper "([^"]*)" is shared with me$/ do |title|
  paper = VideoPaper.find_by_title title
  paper.users << @current_user
end

Given /^my video paper "([^"]*)" is shared with "([^"]*)"$/ do |title, shared_user|
  paper = VideoPaper.find_by_title title
  paper.user.should == @current_user
  paper.users << (User.find_by_email shared_user)
end

Given /^the following video papers$/ do |table|
  table.hashes.each do |row|
    paper = Factory(:video_paper, :title => row["title"], :user => User.find_by_email(row["user"]), :status => row["status"])
  end
end

Given /^the following video papers with videos$/ do |table|
  table.hashes.each do |row|
    paper = Factory(:video_paper, :title => row["title"], :user => User.find_by_email(row["user"]), :status => row["status"])
    video = Factory(:video, :video_paper => paper)
  end
end

When /^(?:|I )fake upload the test video$/ do
  # set entry id as if flash video uploader did it
  # It would be nice if we could the approach below, but capybara and selenium don't support
  # setting hidden fields:
  # find('#video_entry_id').set(KalturaUtil.find_test_video_id)
  #
  # so instead we do it with javascript this will break if run in a driver that doesn't support javascript
  page.execute_script(
    "document.getElementById('video_entry_id').value='#{KalturaUtil.find_test_video_id}';" +
    "document.getElementById('button_submit').disabled = false;")
end

