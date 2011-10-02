require 'spec_helper'

# SERVER_ADDRESS is defined in spec_helper.

describe PapertimeClient do

  before :each do
    @client = PapertimeClient.new(SERVER_ADDRESS)
  end

  it "has base_url" do
    @client.base_url.should eq("#{SERVER_ADDRESS}/api/v1/")
  end

  it "finds a deadline date for amta.no" do
    @client.get_deadline_date(
      :domain => 'amta.no',
      :publication_date => Date.today+9,
      :production_days => 4).class.should eq Date
  end

  it "finds publication for 'www.amta.no' and 'amta.no'" do
    @client.find_publication_by_domain('www.amta.no')["publication"]["title"].should eq "AKERSHUS AMSTIDENDE"
    @client.find_publication_by_domain('amta.no')["publication"]["title"].should eq "AKERSHUS AMSTIDENDE"    
  end

  it "finds publication for Fjellgaten 3, Bergen" do
    @client.find_publications_by_lat_lon(
      60.39722717832889, 5.329188849684669
    )["publications"][0]["publication"]["title"].should eq "BERGENSAVISEN"
  end

  it "returns valid kml" do
    @client.coverage_areas_kml[0..3].should eq "<kml"
    @client.coverage_areas_kml.length.should > 10000
  end

end
