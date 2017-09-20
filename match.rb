require_relative 'requests'
require_relative 'distance'
require_relative 'preparer'
require 'json'

class Match
  attr_reader :packages
  attr_accessor :drones, :assigned_packages, :unassigned_packages

  def initialize(fetcher = Request.new)
    @drones = Prepare::data(fetcher.drones, 'drones')
    @packages = Prepare::data(fetcher.packages, 'packages')
    @assigned_packages = []
    @unassigned_packages = []
  end

  def assign
    self.matcher
    assigned = {
      assignments: assigned_packages, 
      unassignedPackageIds: unassigned_packages
    }

    JSON.generate(assigned)
  end

  def matcher
    sorted_drones = sort_by_distance(drones)
    potential_drone = sorted_drones.shift
    sort_by_time(packages).each do |package|

      if potential_drone && in_time?(potential_drone, package['deadline'])
        assigned_drone = {droneId: potential_drone['droneId'], packageId: package['packageId']}
        self.assigned_packages <<  assigned_drone
        potential_drone = sorted_drones.shift
      else 
        self.unassigned_packages << package['packageId']
      end

    end

  end


  private

  def in_time?(drone, deadline)
    (Time.now.to_i + travel_time(drone['distance_from_depot'])) < deadline
  end

  def sort_by_time(packages)
    sorted = packages.sort_by { |package| package['deadline'] }
    sorted
  end

  def sort_by_distance(drones)
    sorted = drones.sort_by { |drone| drone['distance_from_depot'] }
    sorted
  end

  def travel_time(distance)
    # time = (distance / speed) * minutes * seconds
    (distance / 50) * 60 * 60
  end
end

puts Match.new.assign