include ApplicationHelper
def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end


def valid_example_signin(user)
  fill_in "Name",         with: user
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password",     with: "foobar"
end

RSpec::Matchers.define :have_page_items do |ctext|
  match do |page|
    expect(page).to have_content(ctext)
    expect(page).to have_title(full_title(ctext))
  end
end

RSpec::Matchers.define :have_signout do |link|
  match do |page|
    expect(page).to have_link(link)
  end
end


RSpec::Matchers.define :have_successful_login do |user|
  match do |page|
     expect(page).to have_title(user.name) 
     expect(page).to have_link('Users',      href: users_path) 
     expect(page).to have_link('Profile',     href: user_path(user))
     expect(page).to have_link('Settings',    href: edit_user_path(user))
     expect(page).to have_link('Sign out',    href: signout_path)  
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
