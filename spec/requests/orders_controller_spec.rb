require 'rails_helper'

STRIPE_URL_REGEX = %r{^https://checkout.stripe.com/c/pay}

RSpec.describe "OrdersControllers", type: :request do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "GET #index" do
    context 'if user_id param is not present then show all orders' do
      let!(:orders) { create_list(:order, 5, user: create(:user), address: create(:address, user: user)) }
      it 'should show all orders' do
        get orders_path
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end

    context "if user_id is present" do
      let!(:user) { create(:user) }
      let!(:address1) { create(:address, user: user) }
      let!(:address2) { create(:address, user: user) }
      let!(:order1) { create(:order, user: user, address: address1) }
      let!(:order2) { create(:order, user: user, address: address2) }

      it "should show all user orders" do
        get orders_path(user_id: user.id)
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, user: user, address: address) }

    before do
      get order_path(id: order)
    end

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'should render show' do
      expect(response).to render_template(:show)
    end
  end

  describe "PATCH #update" do
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, address: address, user: user) }

    context "order doesn't exists" do
      it 'should redirect to root_path' do
        patch order_path(id: -1)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq('Order Not found')
      end
    end

    context 'order exists' do
      context 'order can be updated and proceed to stripe' do
        it 'should redirect to stripe' do
          create_list(:line_item, 2, order: order, deal: create(:deal))
          patch order_path(order, order: { status: :placed, address: address })
          expect(response).to have_http_status(302)
          expect(response.location).to match_regex(STRIPE_URL_REGEX)
        end
      end
    end
  end

  describe 'GET #cart' do
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, address: address, user: user) }

    context "order doesn't exists" do
      it 'should redirect to root_path' do
        patch order_path(id: -1)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq('Order Not found')
      end
    end

    context 'when there are no lineitems' do
      it 'should redirect to root path' do
        get cart_order_path(order)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq('You have no deals selected') 
      end
    end

    context 'when there are lineitems' do
      it 'should render cart' do
        create_list(:line_item, 2, order: order, deal: create(:deal))
        get cart_order_path(order)
        expect(response).to have_http_status(200)
        expect(response).to render_template(:cart) 
      end
    end
  end

  describe 'POST #add_to_cart' do
    context 'if user has already bought the deal' do
      let!(:user) { create(:user) }
      let!(:address) { create(:address, user: user) }
      let!(:order) { create(:order, address: address, user: user) }
      let!(:deal) { create(:deal)}
      let!(:line_item) { create(:line_item, order: order, deal: deal) }

      it 'should redirect to root' do
        post add_to_cart_order_path(deal)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq('You can only buy one quantity of this deal')
      end
    end

    context 'if user has never bought this deal' do
      let!(:user) { create(:user) }
      let!(:address) { create(:address, user: user) }
      let!(:order) { create(:order, address: address, user: user) }
      let!(:deal) { create(:deal)}

      it 'should redirect to root' do
        post add_to_cart_order_path(deal)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('Item Added')
      end
    end
  end

  describe 'POST #remove from cart' do
    context 'if deal exists' do
      let!(:user) { create(:user) }
      let!(:address) { create(:address, user: user) }
      let!(:order) { create(:order, address: address, user: user) }
      let!(:deal) { create(:deal)}
      let!(:line_item) { create(:line_item, order: order, deal: deal) }

      it 'should redirect back to cart or root path' do
        post remove_from_cart_order_path(line_item)
        expect(response).to have_http_status(302)
      end
    end

    context "if deal doesn't exists" do
      let!(:user) { create(:user) }
      let!(:address) { create(:address, user: user) }
      let!(:order) { create(:order, address: address, user: user) }
      let!(:deal) { create(:deal)}
      
      it 'should redirect to root' do
        post add_to_cart_order_path(deal)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('Item Added')
      end
    end
  end

  describe 'GET #checkout' do
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, address: address, user: user) }

    it 'should render checkout' do
      get checkout_order_path(order)
      expect(response).to render_template(:checkout) 
    end
  end
end
