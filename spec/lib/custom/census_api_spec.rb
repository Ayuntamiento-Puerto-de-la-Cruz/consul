require "rails_helper"

describe CensusApi do
  let(:api) { CensusApi.new }

  describe "#call" do
    let(:valid_body) do
      { habitante: {
        fechanacim: "1980-01-01T00:00:00",
        tiene_errores: false }}
    end
    let(:invalid_body) do
      { habitante: {
          tiene_errores: true }}
    end

    it "returns the response for the first valid variant" do
      allow(api).to receive(:get_response_body).with(1, "00123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "0123456").and_return(valid_body)

      response = api.call(1, "123456")

      expect(response).to be_valid
      expect(response.date_of_birth).to eq(Date.new(1980, 1, 1))
    end

    it "returns the last failed response" do
      allow(api).to receive(:get_response_body).with(1, "00123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "0123456").and_return(invalid_body)
      response = api.call(1, "123456")

      expect(response).not_to be_valid
    end
  end
end
