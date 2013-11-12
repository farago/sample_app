module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def setStrings
  	let(:submit) { "Create my account" }
  	let(:tooLong) { "Name is too long (maximum is 50 characters)" }
  	let(:nameBlank) { "Name can't be blank" }
  	let(:emailBlank) { "Email can't be blank" }
  	let(:emailInvalid) { "Email is invalid" }
  	let(:tooShort) { "Password is too short (minimum is 6 characters)" }
  	let(:password) { "short" }
  	let(:passwordBlank) { "Password can't be blank" }
  	let(:notMatching) { "Password confirmation doesn't match Password" }
  end

  def submitSignupForm(name = '', email = '', password = '', confirmation = '')
  	fill_in "Name",         with: name
  	fill_in "Email",        with: email
  	fill_in "Password",     with: password
  	fill_in "Confirmation", with: confirmation
  	click_button submit
  end

  def submitSigninForm(email = '', password = '')
    fill_in "Email",         with: email
    fill_in "Password",      with: password
  	click_button 'Sign in'
  end

end