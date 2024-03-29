require 'spec_helper'

  describe "AuthenticationPages" do

     subject { page }

  	 describe "signin page" do
  	    before { visit login_path }

  	    describe "with invalid information" do
        		before { click_button "Login" }

  	    it { should have_content('Login') }
  	    it { should have_title('Login') }
  	    it { should have_selector('div.alert.alert-error', text: 'Invalid') }

        describe "after visiting another page" do
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error') }
        end
      end
      
  	describe "with valid information" do
  	      let(:user) { FactoryGirl.create(:user) }
  	      before do
  	        fill_in "Email",    with: user.email.upcase
  	        fill_in "Password", with: user.password
  	        click_button "Login"
  	      end

  	      it { should have_title(user.name) }
  	      it { should have_link('Profile',    href: user_path(user)) }
  	      it { should have_link('Settings',   href: edit_user_path(user)) }
  	     # remmoved 
  	      it { should_not have_link('Log in', href: login_path) }


  	    end
  	    # missing two test but implemented in app

      end
      describe "authorization" do
        describe "for non-signed-in users" do
          let(:user) { FactoryGirl.create(:user) }

          describe "in the Users controller" do

            describe "visiting the edit page" do
              before { visit edit_user_path(user) }
              it { should have_title('Login') }
            end

            describe "submitting to the update action" do
              before { patch user_path(user) }
              specify { expect(response).to redirect_to(login_path) }
            end
          end
        end
        
        describe "as wrong user" do
          let(:user) { FactoryGirl.create(:user) }
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
          before { log_in user, no_capybara: true }

          describe "visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it { should_not have_title(full_title('Edit user')) }
          end

          describe "submitting a PATCH request to the Users#update action" do
            before { patch user_path(wrong_user) }
            specify { expect(response).to redirect_to(root_url) }
          end
        end

        describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Login"
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              expect(page).to have_title('Edit user')
            end
          end
        end

      end

  end
end