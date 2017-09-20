class Distance

  # Euclidean distance is far less intensive to compute and provides a very 
  # accurate estimate for small areas (up to 0.4% for a distance 50km)
  def self.euclidean(args)
    deglen = 110.25
    x = args[:lat_start] - args[:lat_end]
    y = (args[:long_start] - args[:long_end]) * Math.cos(args[:lat_end])
    deglen * Math.sqrt(x * x + y * y)
  end

end
