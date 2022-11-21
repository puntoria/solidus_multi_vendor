require 'spec_helper'

describe Spree::V2::Storefront::StockLocationSerializer do
  subject { described_class.new(stock_location) }

  let(:vendor) { create(:vendor, name: 'Test', about_us: 'Hello World') }
  let(:stock_location) { create(:stock_location, vendor: vendor) }

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }

  it do
    expect(subject.serializable_hash).to eq(
      {
        data: {
          id: stock_location.id.to_s,
          type: :stock_location,
          attributes: {
            name: stock_location.name
          },
          relationships: {
            vendor: {
              data: {
                id: vendor.id.to_s,
                type: :vendor
              }
            }
          }
        }
      }
    )
  end
end
