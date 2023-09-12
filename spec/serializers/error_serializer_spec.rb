require 'rails_helper'

RSpec.describe 'Error Serializer' do
  describe 'serialization' do
    before(:each) do 
      @error = NameError.new('hullaballoo')
      @serialized_error = ErrorSerializer.serialize_error(@error, 404)
    end

    it 'serialized errors have structure' do 

      check_hash_structure(@serialized_error, :error, Hash)
      check_hash_structure(@serialized_error[:error], :status, Integer)
      check_hash_structure(@serialized_error[:error], :message, String)

    end

    it 'serialized error matched error' do 
      expect(@serialized_error[:error][:status]).to eq(404)
      expect(@serialized_error[:error][:message]).to eq('hullaballoo')
    end
  end
end