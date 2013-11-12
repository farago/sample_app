require 'spec_helper'

describe "User pages" do

  subject { page }

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
          submitSignupForm
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
end