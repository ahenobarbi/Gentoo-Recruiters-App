Given /^a question "([^\"]*)"$/ do |title|
  @question = Question.find_by_title(title)
  if @question.nil?
    @question = Question.create!( :title => title)
  end
  if @question.content.nil?
    QuestionContentText.create! :question => @question, :content => "fake"
    @question.reload
  end
end

Given /^a question "([^\"]*)" in category "([^\"]*)"$/ do |title, category|
  Given "a question \"#{title}\""
  Given "a category \"#{category}\""
  QuestionCategory.create!(:category => @category, :question => @question)
end

Given /^a question "([^\"]*)" in group "([^\"]*)"$/ do |title, group|
  Given "a question \"#{title}\""
  Given "question group \"#{group}\""
  @question.question_group = @question_group
  @question.save!
end

Given /^following questions:$/ do |table|
  for question in table.raw
    if question.size == 1
      Given "a question \"#{question[0]}\""
    elsif question.size == 2
      Given "a question \"#{question[0]}\" in category \"#{question[1]}\""
    elsif question.size == 3
      Given "a question \"#{question[0]}\" in category \"#{question[1]}\""
      Given "a question \"#{question[0]}\" in group \"#{question[2]}\""
    else
      fail "Each row of table should have one or two columns"
    end
  end
end

Then /^I should see following:$/ do |table|
  for txt in table.raw.flatten
    Then "I should see \"#{txt}\""
  end
end

Then /^I should not see following:$/ do |table|
  for txt in table.raw.flatten
    Then "I should not see \"#{txt}\""
  end
end

Given /^question "([^"]*)" has no content$/ do |title|
  Given "a question \"#{title}\""
  @question.content._?.destroy
end
