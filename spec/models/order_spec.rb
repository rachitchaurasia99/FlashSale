require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'enum' do
    it { should define_enum_for :status }
  end

  describe 'association' do
    it { should belong_to :user }
    it { should belong_to(:address).optional }
    it { should have_many :payments }
    it { should have_many :refunds }
    it { should have_many :line_items }
    it { should have_many(:deals).through(:line_items) }
  end

  describe 'scope' do                             
    let!(:user) { create(:user) }
    let!(:address) { create(:address, user: user) }
    let!(:order) { create(:order, user: user, address: address) }
    context 'placed_orders' do
      let!(:placed_order) { create(:order, :is_placed, user: user, address: address) }
      let!(:unplaced_order) { create(:order, user: user, address: address) }
      it 'should show placed orders' do
        placed_orders = Order.placed_orders
        expect(placed_orders).to include placed_order
      end
    end

    context 'deal_exists' do
      let!(:deal){ create(:deal) }
      let!(:line_item){ create(:line_item, deal: deal, order: order) }
      let!(:deal_exists){ user.orders.deal_exists(deal) }
      it 'should contain the deal' do
        expect(deal_exists).to include line_item.order
      end
    end
  end
end
