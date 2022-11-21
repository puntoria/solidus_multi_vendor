require 'spec_helper'

describe Spree::VendorAbility do
  let!(:vendor){ FactoryBot.create(:vendor) }
  let!(:shipment){
    FactoryBot.create(:shipment,
      order: FactoryBot.create(:order,
        store: FactoryBot.create(:store)))
  }
  let!(:ability){ described_class.new FactoryBot.create(:user, vendors: [vendor]) }

  describe 'allows stores' do
    it 'allows vendors to ship shipments' do
      expect(ability.can?(:ship, shipment)).to be true
    end

    it 'does not allow vendors to manage shipments' do
      expect(ability.can?(:manage, shipment)).to be false
    end
  end
end
