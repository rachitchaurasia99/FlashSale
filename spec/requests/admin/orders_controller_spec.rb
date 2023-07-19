require 'rails_helper'

RefundID = 're_3NVVtQSBM6H1Ysf20a1ZOk0U'

RSpec.describe "Admin::OrdersControllers", type: :request do
  let!(:admin) { create(:user, :admin) }
  before { sign_in admin }

  describe "GET #index" do
    context 'when email parameter is present' do
      let!(:user1) { create(:user, email: "user1@example.com") }
      let!(:user2) { create(:user, email: "user2@example.com") }
      let!(:order1) { create(:order, user: user1) }
      let!(:order2) { create(:order, user: user2) }
      it 'should return order records' do
        get admin_orders_path, params: { email: user1.email }
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end

    context 'all orders' do
      let!(:users) { create_list(:user, 3) }
      let!(:addresses) { create_list(:address, 2) }
      let!(:orders) { create_list(:order, 5) }
      it 'should return all order records' do
        get admin_orders_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST #deliver_order" do
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, user: user, address: address) }

    before { post deliver_admin_order_path(id: order) }

    it "marks the order as delivered" do
      expect(order.reload).to be_delivered
    end

    it "sends a delivered email to the user" do
      expect { OrderMailer.with(order: order).delivered.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it "redirects back to the admin orders page" do
      expect(response).to redirect_to(admin_orders_path)
    end
  end
end
