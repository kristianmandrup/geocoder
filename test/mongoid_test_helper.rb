require 'rubygems'
require 'test/unit'
require 'test_helper'
require 'mongoid'
require 'mongoid_geospatial'
require 'geocoder/models/mongoid'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Mongoid.configure do |config|
  config.logger = Logger.new($stderr, :debug)
end

##
# Geocoded model.
#
class Place
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  geocoded_by :address, :coordinates => :location
  field :name
  field :address
  field :location, :type => Array

  def initialize(name, address)
    super()
    write_attribute :name, name
    write_attribute :address, address
  end
end

class GeoSpacialPlace
  include Mongoid::Document
  include Mongoid::Geospatial
  include Geocoder::Model::Mongoid

  # rake db:mongoid:create_indexes
  field :location,      type: Point,    spatial: {lat: :latitude, lng: :longitude, return_array: true }

  geocoded_by :address, :coordinates => :location #, :skip_index => true

  field :address

  def initialize(name, address)
    super()
    write_attribute :name, name
    write_attribute :address, address
  end   
end


class PlaceWithoutIndex
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :location, :type => Array
  geocoded_by :location, :skip_index => true
end
