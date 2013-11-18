require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do

    before { visit signup_path }
    setStrings

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "name tests" do

      describe "when name is too long" do
        before do
          submitSignupForm(name: "a"*51)
        end
        
         it "should display error message" do
          expect { should have_content(tooLong)}
        end
      end
      
      describe "when name is blank" do
        before do
          submitSignupForm(name: "", email: "ex@df.com", password: "password", confirmation: "password")
        end
        
        it "should display error message" do
          expect { should have_content(nameBlank)}
        end
      end
    end

    describe "email tests" do

      describe "email is invalid" do
        before do
          submitSignupForm(email: "asadfasdf")
        end
        
        it "should display error message" do
          expect { should have_content(emailInvalid)}
        end
      end
      
      describe "when email is blank" do
        before do
          submitSignupForm
        end
        
        it "should display error message" do
          expect { should have_content(emailBlank)}
        end
      end
    end

    describe "password tests" do

      describe "password is too short" do
        before do
          submitSignupForm(password: password)
        end
        
        it "should display error message" do
          expect { should have_content(tooShort)}
        end
      end
      
      describe "when password is blank" do
        before do
          submitSignupForm
        end
        
        it "should display error message" do
          expect { should have_content(passwordBlank)}
        end
      end

      describe "when confirmation doesn't match" do
        before do
          submitSignupForm(password: password, confirmation: "sdfs")
        end
        
        it "should display error message" do
          expect { should have_content(notMatching)}
        end
      end
    end

    describe "with valid information" do
      before do
        submitSignupForm("Example User", "us3er@example.com", "foobar", "foobar")
      end

      describe "after saving the user" do
        let(:user) { User.find_by(email: 'us3er@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

      describe "followed by signout" do
         before { click_link "Sign out" }
         it { should have_link('Sign in') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: false
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end