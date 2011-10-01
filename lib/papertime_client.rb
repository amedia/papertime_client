require 'httpclient'
require 'json'

# Use by creating a client given the domain where papertime is to be found
# e.g. client = PapertimeClient.new('http://localhost:3001')
#
# then making requests like so:
#
# client.get_publication_dates(:domain => 'op.no', :production_days => 6)
# client.get_deadline_date(:domain => 'amta.no', :publication_date => Date.today+9, :production_days => 4)


class PapertimeClient
  def initialize(domain)
    @base_uri = URI.parse(domain)+'api/v1/'
  end
  
  def domain_from_url(url)
    return unless url
    url = URI.split(url)[2] if url.starts_with?("http")
    return url.gsub(/^www\./, '')    
  end
  
  # Get all viable publication dates after today given a required processing time 
  # of :production_days for the publication identified with the :domain
  # e.g. client.get_publication_dates(:domain => 'op.no', :production_days => 6)
  # returns a hash with the single key 'issues' which points to an array of Date-objects
  def get_publication_dates(params)
    params[:domain] = domain_from_url(params[:domain])
    uri = @base_uri+'publication_dates'
    uri.query = "domain=#{params[:domain]}&production_days=#{params[:production_days]}"
    result = content_from(uri)
    result['issues'] = result['issues'].map{|date| Date.parse(date)}
    result
  end
  
  # Compute the deadline for publication on :publication_date given a processing time
  # of :production_days for the publication identified with the :domain
  # e.g. client.get_deadline_date(:domain => 'amta.no', :publication_date => Date.today+9, :production_days => 4)
  # returns the Date
  def get_deadline_date(params)
    params[:domain] = domain_from_url(params[:domain])
    uri = @base_uri+'deadline_date'
    uri.query = "domain=#{params[:domain]}&publication_date=#{params[:publication_date]}&production_days=#{params[:production_days]}"
    result = content_from(uri)
    return Date.parse(result['deadline']) if result['deadline']
    result    
  end
  
  # Compute the nearest possible publication date from a :domain and :desired_publication_date
  # e.g. client.get_nearest_publication_date(:domain => 'amta.no', :desired_publication_date => Date.today+9)
  # returns the Date
  def get_nearest_publication_date(params = {})
    raise ArgumentError, "Cannot retrieve publication date without domain" unless params[:domain]
    raise ArgumentError, "Cannot retrieve publication date without desired publication date" unless params[:desired_publication_date]
    domain = domain_from_url(params[:domain])
    uri = @base_uri + 'nearest_publication_date'
    uri.query = "domain=#{domain}&desired_publication_date=#{params[:desired_publication_date]}"
    result = content_from(uri)    
    return if result.nil?
    return Date.parse(result['publication_date']) if result['publication_date']
    result
  end
  
  private
  
  def content_from(uri)
    begin
      client = HTTPClient.new.get_content(uri)
      return JSON.parse(client)
    rescue Errno::ECONNREFUSED => e
      puts("Could not connect to papertime server: #{e.message}")
      puts e.inspect
      puts e.backtrace
    rescue Exception => e
      puts("Something went wrong while calling papertime api: #{e.message}")
      puts e.inspect
      puts e.backtrace
    end
  end
  
end
