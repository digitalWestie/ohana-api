require 'rails_helper'

describe Admin::ServicesController do
  describe 'GET edit' do
    before(:each) do
      @loc = create(:nearby_loc)
      @service = @loc.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to edit service' do
        log_in_as_admin(:super_admin)

        get :edit, location_id: @loc.id, id: @service.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :edit, location_id: @loc.id, id: @service.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:alert]).
          to eq("Sorry, you don't have access to that page.")
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      @loc = create(:nearby_loc)
    end

    context 'when admin is super admin' do
      it 'allows access to edit service' do
        log_in_as_admin(:super_admin)

        get :new, location_id: @loc.id

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new, location_id: @loc.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:alert]).
          to eq("Sorry, you don't have access to that page.")
      end
    end
  end
end
