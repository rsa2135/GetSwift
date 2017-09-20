DEPOT = {latitude: -37.8176789,
longitude: 144.95796380000002}

class Prepare

  def self.data(list, type)
    if type == 'drones'
      self.transform_drones(list)
    else
      self.transform_packages(list)
    end
  end


  private

  def self.transform_drones(drones)
    distance = -1
    drones.each do |drone|
      if drone['packages'].empty?
        distance = Distance::euclidean(
          lat_start: drone['location']['latitude'],
          long_start: drone['location']['longitude'],
          lat_end: DEPOT[:latitude], 
          long_end: DEPOT[:longitude]
        )
      else
        distance = Distance::euclidean(
          lat_start: drone['location']['latitude'],
          long_start: drone['location']['longitude'],
          lat_end: drone['packages'][0]['destination']['latitude'],
          long_end: drone['packages'][0]['destination']['longitude']
        ) + Distance::euclidean(
          lat_start: drone['packages'][0]['destination']['latitude'],
          long_start: drone['packages'][0]['destination']['longitude'],
          lat_end: DEPOT[:latitude], 
          long_end: DEPOT[:longitude]
        )
      end
      drone['distance_from_depot'] = distance
      drone['assigned'] = false
    end
  end

  def self.transform_packages(packages)
    packages.each do |package|
      distance = Distance::euclidean(
        lat_start: package['destination']['latitude'],
        long_start: package['destination']['longitude'],
        lat_end: DEPOT[:latitude], 
        long_end: DEPOT[:longitude]
      )

      package['distance_from_depot'] = distance
    end
  end

end